-- 9. Helpful indexes (additional)
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_lapangan_aktif ON lapangan(aktif);
CREATE INDEX idx_slot_status_date ON jadwal_slot(status, tanggal);
