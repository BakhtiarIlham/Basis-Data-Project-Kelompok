-- 8.1 Trigger: when a reservasi_slot is inserted, set jadwal_slot.status -> DIPESAN
DELIMITER $$
CREATE TRIGGER trg_rs_after_insert
AFTER INSERT ON reservasi_slot
FOR EACH ROW
BEGIN
  UPDATE jadwal_slot SET status = 'DIPESAN' WHERE slot_id = NEW.slot_id;
  -- optional: notify petugas/admin (simple entry in notifikasi table)
  INSERT INTO notifikasi (recipient_type, recipient_id, reservasi_id, pesan)
  VALUES ('ADMIN', NULL, NEW.reservasi_id, CONCAT('Slot dipesan. reservasi_id=', NEW.reservasi_id, ', slot=', NEW.slot_id));
END$$
DELIMITER ;

-- 8.2 Trigger: when reservasi.status updated to 'Dikonfirmasi', insert notifikasi to user
DELIMITER $$
CREATE TRIGGER trg_reservasi_after_update
AFTER UPDATE ON reservasi
FOR EACH ROW
BEGIN
  IF OLD.status <> NEW.status THEN
    IF NEW.status = 'Dikonfirmasi' THEN
      INSERT INTO notifikasi (recipient_type, recipient_id, reservasi_id, pesan)
      VALUES ('USER', NEW.user_id, NEW.reservasi_id, CONCAT('Reservasi ', NEW.kode_reservasi, ' telah dikonfirmasi.'));
    ELSEIF NEW.status = 'DIBATALKAN' THEN
      INSERT INTO notifikasi (recipient_type, recipient_id, reservasi_id, pesan)
      VALUES ('USER', NEW.user_id, NEW.reservasi_id, CONCAT('Reservasi ', NEW.kode_reservasi, ' dibatalkan.'));
    END IF;
  END IF;
END$$
DELIMITER ;

-- 8.3 Trigger: when pembayaran becomes LUNAS -> update reservasi.total_amount and maybe reservasi.status
DELIMITER $$
CREATE TRIGGER trg_pembayaran_after_update
AFTER UPDATE ON pembayaran
FOR EACH ROW
BEGIN
  IF OLD.status <> NEW.status AND NEW.status = 'LUNAS' THEN
    -- optional: mark reservasi as Dikonfirmasi only if currently MENUNGGU
    UPDATE reservasi SET total_amount = (SELECT COALESCE(SUM(harga),0) FROM reservasi_slot WHERE reservasi_id = NEW.reservasi_id)
    WHERE reservasi_id = NEW.reservasi_id;
    IF (SELECT status FROM reservasi WHERE reservasi_id = NEW.reservasi_id) = 'MENUNGGU' THEN
      UPDATE reservasi SET status = 'Dikonfirmasi', konfirmasi_at = NOW() WHERE reservasi_id = NEW.reservasi_id;
    END IF;
    INSERT INTO notifikasi (recipient_type, recipient_id, reservasi_id, pesan)
    VALUES ('USER', (SELECT user_id FROM reservasi WHERE reservasi_id = NEW.reservasi_id), NEW.reservasi_id, CONCAT('Pembayaran diterima untuk reservasi ', (SELECT kode_reservasi FROM reservasi WHERE reservasi_id = NEW.reservasi_id)));
  END IF;
END$$
DELIMITER ;

-- 8.4 Trigger: when reservasi is cancelled -> free slots & create refund request (optional)
DELIMITER $$
CREATE TRIGGER trg_reservasi_after_delete_or_cancel
AFTER UPDATE ON reservasi
FOR EACH ROW
BEGIN
  -- if status changed to DIBATALKAN then free slots and set jadwal back to TERSEDIA
  IF OLD.status <> NEW.status AND NEW.status = 'DIBATALKAN' THEN
    -- free all slots linked to this reservation
    UPDATE jadwal_slot js
    JOIN reservasi_slot rs ON rs.slot_id = js.slot_id
    SET js.status = 'TERSEDIA'
    WHERE rs.reservasi_id = NEW.reservasi_id;
    -- optionally create refund record if payment existed and was LUNAS
    INSERT INTO notifikasi (recipient_type, recipient_id, reservasi_id, pesan)
    VALUES ('USER', NEW.user_id, NEW.reservasi_id, CONCAT('Reservasi ', NEW.kode_reservasi, ' dibatalkan, silakan cek refund.'));
  END IF;
END$$
DELIMITER ;