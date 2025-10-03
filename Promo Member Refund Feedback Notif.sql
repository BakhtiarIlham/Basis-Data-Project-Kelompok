-- 6.1 Promo
CREATE TABLE promo (
  promo_id INT AUTO_INCREMENT PRIMARY KEY,
  kode_promo VARCHAR(50) UNIQUE NOT NULL,
  deskripsi VARCHAR(255),
  diskon_persen DECIMAL(5,2) DEFAULT 0.00,
  min_total DECIMAL(12,2) DEFAULT 0.00,
  berlaku_mulai DATE,
  berlaku_sampai DATE,
  aktif BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB;

-- 6.2 Membership
CREATE TABLE membership (
  membership_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  tipe ENUM('SILVER','GOLD','PLATINUM') DEFAULT 'SILVER',
  diskon_persen DECIMAL(5,2) DEFAULT 0.00,
  masa_berlaku DATE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 6.3 Refunds
CREATE TABLE refunds (
  refund_id INT AUTO_INCREMENT PRIMARY KEY,
  pembayaran_id INT NOT NULL,
  reservasi_id INT NOT NULL,
  jumlah DECIMAL(12,2) NOT NULL,
  alasan TEXT,
  status ENUM('PENDING','APPROVED','REJECTED','COMPLETED') DEFAULT 'PENDING',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (pembayaran_id) REFERENCES pembayaran(pembayaran_id) ON DELETE CASCADE,
  FOREIGN KEY (reservasi_id) REFERENCES reservasi(reservasi_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 6.4 Feedback / Review
CREATE TABLE feedback (
  feedback_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  lapangan_id INT NOT NULL,
  reservasi_id INT NULL,
  rating TINYINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
  komentar TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  FOREIGN KEY (lapangan_id) REFERENCES lapangan(lapangan_id) ON DELETE CASCADE,
  FOREIGN KEY (reservasi_id) REFERENCES reservasi(reservasi_id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- 6.5 Notifikasi
CREATE TABLE notifikasi (
  notif_id INT AUTO_INCREMENT PRIMARY KEY,
  recipient_type ENUM('USER','PETUGAS','ADMIN') NOT NULL,
  recipient_id INT NULL, -- maps to users.user_id
  reservasi_id INT NULL,
  pesan TEXT NOT NULL,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (recipient_id) REFERENCES users(user_id) ON DELETE SET NULL,
  FOREIGN KEY (reservasi_id) REFERENCES reservasi(reservasi_id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE INDEX idx_notif_recipient ON notifikasi(recipient_type, recipient_id);
