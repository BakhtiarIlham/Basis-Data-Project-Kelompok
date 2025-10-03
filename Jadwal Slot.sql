-- 3.1 JadwalSlot - representasi slot waktu per lapangan
CREATE TABLE jadwal_slot (
  slot_id INT AUTO_INCREMENT PRIMARY KEY,
  lapangan_id INT NOT NULL,
  tanggal DATE NOT NULL,
  jam_mulai TIME NOT NULL,
  jam_selesai TIME NOT NULL,
  harga_override DECIMAL(12,2) DEFAULT NULL,
  status ENUM('TERSEDIA','DIPESAN','BLOCKED') DEFAULT 'TERSEDIA',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (lapangan_id) REFERENCES lapangan(lapangan_id) ON DELETE CASCADE,
  CONSTRAINT uc_lapangan_slot UNIQUE (lapangan_id, tanggal, jam_mulai, jam_selesai)
) ENGINE=InnoDB;

CREATE INDEX idx_jadwal_lapangan_date ON jadwal_slot(lapangan_id, tanggal);
