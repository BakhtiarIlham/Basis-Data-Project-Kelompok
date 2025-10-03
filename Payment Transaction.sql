-- 5. Pembayaran & transaksi
CREATE TABLE pembayaran (
  pembayaran_id INT AUTO_INCREMENT PRIMARY KEY,
  reservasi_id INT NOT NULL,
  jumlah DECIMAL(12,2) NOT NULL,
  metode ENUM('CASH','TRANSFER','EWALLET') DEFAULT 'TRANSFER',
  bukti_url VARCHAR(500),
  status ENUM('PENDING','LUNAS','REFUNDED') DEFAULT 'PENDING',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (reservasi_id) REFERENCES reservasi(reservasi_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE INDEX idx_pembayaran_reservasi ON pembayaran(reservasi_id);
CREATE INDEX idx_pembayaran_status ON pembayaran(status);