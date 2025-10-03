-- 4.1 Reservasi header
CREATE TABLE reservasi (
  reservasi_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  kode_reservasi VARCHAR(50) UNIQUE NOT NULL,
  total_amount DECIMAL(12,2) DEFAULT 0.00,
  status ENUM('MENUNGGU','Dikonfirmasi','SELSESAI','DIBATALKAN','EXPIRED') DEFAULT 'MENUNGGU',
  catatan TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  konfirmasi_by INT NULL, -- admin/petugas id (users.user_id)
  konfirmasi_at DATETIME NULL,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  FOREIGN KEY (konfirmasi_by) REFERENCES users(user_id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE INDEX idx_reservasi_user ON reservasi(user_id);
CREATE INDEX idx_reservasi_status ON reservasi(status);

-- 4.2 Reservasi slots - link reservasi ke jadwal_slot (1 reservasi dapat memesan >1 slot)
CREATE TABLE reservasi_slot (
  rs_id INT AUTO_INCREMENT PRIMARY KEY,
  reservasi_id INT NOT NULL,
  slot_id INT NOT NULL,
  harga DECIMAL(12,2) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (reservasi_id) REFERENCES reservasi(reservasi_id) ON DELETE CASCADE,
  FOREIGN KEY (slot_id) REFERENCES jadwal_slot(slot_id) ON DELETE CASCADE,
  CONSTRAINT uc_reserved_slot UNIQUE (slot_id) -- ensure a slot cannot be double-booked by DB-level unique constraint on slot_id in this table
) ENGINE=InnoDB;

CREATE INDEX idx_rs_reservasi ON reservasi_slot(reservasi_id);
CREATE INDEX idx_rs_slot ON reservasi_slot(slot_id);

