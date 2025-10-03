-- 7.1 Reservation detail view
CREATE OR REPLACE VIEW vw_reservation_detail AS
SELECT r.reservasi_id, r.kode_reservasi, r.user_id, u.nama AS user_nama, u.email AS user_email,
       r.total_amount, r.status AS reservasi_status, r.created_at AS reservasi_created_at,
       GROUP_CONCAT(CONCAT('lapangan:', l.nama_lapangan, ' | ', DATE_FORMAT(js.tanggal, '%Y-%m-%d'), ' ', js.jam_mulai, '-', js.jam_selesai) SEPARATOR ' || ') AS slots_info
FROM reservasi r
JOIN users u ON r.user_id = u.user_id
JOIN reservasi_slot rs ON rs.reservasi_id = r.reservasi_id
JOIN jadwal_slot js ON js.slot_id = rs.slot_id
JOIN lapangan l ON l.lapangan_id = js.lapangan_id
GROUP BY r.reservasi_id;

-- 7.2 Revenue per month view
CREATE OR REPLACE VIEW vw_revenue_monthly AS
SELECT DATE_FORMAT(p.created_at, '%Y-%m') AS periode, SUM(p.jumlah) AS total_revenue, COUNT(DISTINCT p.pembayaran_id) AS jumlah_transaksi
FROM pembayaran p
WHERE p.status = 'LUNAS'
GROUP BY DATE_FORMAT(p.created_at, '%Y-%m')
ORDER BY periode DESC;

-- 7.3 Most booked lapangan
CREATE OR REPLACE VIEW vw_most_booked_lapangan AS
SELECT l.lapangan_id, l.nama_lapangan, COUNT(rs.rs_id) AS jumlah_booking
FROM lapangan l
LEFT JOIN jadwal_slot js ON js.lapangan_id = l.lapangan_id
LEFT JOIN reservasi_slot rs ON rs.slot_id = js.slot_id
GROUP BY l.lapangan_id
ORDER BY jumlah_booking DESC;