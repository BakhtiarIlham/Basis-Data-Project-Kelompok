-- 2.1 Users (customers, admin, petugas, manajer)
CREATE TABLE users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  nama VARCHAR(150) NOT NULL,
  email VARCHAR(200) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  no_hp VARCHAR(30),
  role ENUM('CUSTOMER','ADMIN','PETUGAS','MANAGER') DEFAULT 'CUSTOMER',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  last_login DATETIME NULL
) ENGINE=InnoDB;

-- 2.2 Lapangan (basic)
CREATE TABLE lapangan (
  lapangan_id INT AUTO_INCREMENT PRIMARY KEY,
  kode VARCHAR(50) UNIQUE NOT NULL,
  nama_lapangan VARCHAR(150) NOT NULL,
  tipe ENUM('INDOOR','OUTDOOR') DEFAULT 'INDOOR',
  kapasitas INT DEFAULT 10,
  aktif BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 2.3 Lapangan detail (foto, fasilitas, deskripsi)
CREATE TABLE lapangan_detail (
  detail_id INT AUTO_INCREMENT PRIMARY KEY,
  lapangan_id INT NOT NULL,
  deskripsi TEXT,
  fasilitas TEXT,         -- comma-separated or JSON (simple)
  foto_url VARCHAR(500),
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (lapangan_id) REFERENCES lapangan(lapangan_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 2.4 Pricing rules (dynamic pricing, peak hours)
CREATE TABLE pricing_rules (
  rule_id INT AUTO_INCREMENT PRIMARY KEY,
  lapangan_id INT NULL,        -- NULL = global
  nama_rule VARCHAR(150),
  tipe_rule ENUM('PEAK','OFFPEAK','WEEKEND','CUSTOM') DEFAULT 'CUSTOM',
  persen_modifer DECIMAL(5,2) DEFAULT 0.00, -- e.g., 20.00 means +20%
  start_time TIME NULL,        -- optional time window
  end_time TIME NULL,
  hari ENUM('MON','TUE','WED','THU','FRI','SAT','SUN') NULL,
  aktif BOOLEAN DEFAULT TRUE,
  FOREIGN KEY (lapangan_id) REFERENCES lapangan(lapangan_id) ON DELETE SET NULL
) ENGINE=InnoDB;