/* ===================================================================
   Reservasi Futsal - Full DB Schema (for MySQL Workbench)
   - Database : reservasi_futsal_full
   - Includes: users, lapangan, lapangan_detail, jadwal(slot),
               reservasi, reservasi_slot (multi-slot support),
               pembayaran, promo, membership, feedback, notifikasi,
               refund, pricing_rules, views, triggers, sample data.
   =================================================================== */

-- 0. Safety: drop DB if you want to recreate 
-- DROP DATABASE IF EXISTS reservasi_futsal_full;

-- 1. Create DB
CREATE DATABASE IF NOT EXISTS reservasi_futsal_full
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;
USE reservasi_futsal_full;