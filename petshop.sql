-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 10, 2024 at 03:37 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `petshop`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `tambah_produk` (IN `nama_produk` VARCHAR(100), IN `harga` INT(11), IN `stok` INT(100))   BEGIN
    IF harga > 0 THEN
        INSERT INTO produk (nama_produk, harga, stok) VALUES (nama_produk, harga, stok);
    ELSE
        SELECT 'Harga harus lebih dari nol' AS pesan;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `tampilkan_hewan` ()   BEGIN
    DECLARE jumlah_hewan INT;   
    SELECT COUNT(*) INTO jumlah_hewan FROM hewan;   
    IF jumlah_hewan > 0 THEN
        SELECT * FROM hewan;
    ELSE
        SELECT 'Tidak ada data hewan' AS keterangan;
    END IF;   
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `get_total_products` () RETURNS INT(11)  BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total FROM produk;
    RETURN total;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `hitung_hewan_kucing` (`tanggal_masuk` DATE, `tanggal_keluar` DATE) RETURNS INT(11)  BEGIN
    DECLARE total_kucing INT;
    SELECT COUNT(*) INTO total_kucing
    FROM penitipan p
    INNER JOIN hewan h ON p.id_hewan = h.id_hewan
    WHERE h.jenis_hewan = 'Kucing'
    AND p.tanggal_masuk >= tanggal_masuk AND p.tanggal_keluar <= tanggal_keluar;
    RETURN total_kucing;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `id_customer` int(11) NOT NULL,
  `nama_customer` varchar(100) DEFAULT NULL,
  `alamat` varchar(200) DEFAULT NULL,
  `nomor_telepon` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`id_customer`, `nama_customer`, `alamat`, `nomor_telepon`) VALUES
(1, 'Faizah', 'Jl. Semanu No. 123', '081234567789'),
(2, 'Dina', 'Jl. Gebang No. 456', '082213456654'),
(3, 'Ulfa', 'Jl. Alpokat No. 789', '081234112321'),
(4, 'Vania', 'Jl. Denggung No. 321', '081889765890'),
(5, 'Laksmira', 'Jl. Kalasan No. 654', '081324453324'),
(6, 'Sefiana', 'Jl. Bayem No. 133', '082654456332'),
(7, 'Putri', 'Jl. Alpokat No. 236', '081678876331'),
(8, 'Riska', 'Jl. Muji No. 556', '081987212211'),
(9, 'Annisah', 'Jl. Maguwo No. 231', '082665778234'),
(10, 'Kartika', 'Jl. Depok No. 154', '081445554323'),
(11, 'Yanti', 'Jl. Seturan No. 273', '081276654322'),
(12, 'Vinda', 'Jl. Nusa No. 216', '082453345221'),
(13, 'Indah', 'Jl. Cermai No. 412', '081231667098'),
(14, 'Novi', 'Jl. Mini No. 131', '081245567765'),
(15, 'Naswa', 'Jl. Palem No. 224', '082667765890'),
(16, 'Febia', 'Jl. Jawi No. 129', '081445678767'),
(17, 'Laras', 'Jl. Patuk No. 126', '082356653456'),
(18, 'Christi', 'Jl. Gebang No. 455', '082212890789'),
(19, 'Indah', 'Jl. Kuat No. 221', '082234789987');

-- --------------------------------------------------------

--
-- Table structure for table `hewan`
--

CREATE TABLE `hewan` (
  `id_hewan` int(11) NOT NULL,
  `nama_hewan` varchar(100) DEFAULT NULL,
  `jenis_hewan` varchar(50) DEFAULT NULL,
  `id_pemilik` int(11) DEFAULT NULL,
  `umur` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hewan`
--

INSERT INTO `hewan` (`id_hewan`, `nama_hewan`, `jenis_hewan`, `id_pemilik`, `umur`) VALUES
(1, 'Dogy', 'Anjing', 3, 5),
(2, 'Gembul', 'Kucing', 1, 3),
(3, 'Buddy', 'Anjing', 13, 4),
(4, 'Ciko', 'Kucing', 4, 4),
(5, 'Cecen', 'Anjing', 9, 4),
(6, 'Beben', 'Kucing', 5, 4),
(7, 'Bandot', 'Kucing', 8, 3),
(8, 'Blecky', 'Anjing', 7, 4),
(9, 'Lusi', 'Kucing', 6, 3),
(10, 'Doby', 'Anjing', 2, 3),
(11, 'Miko', 'Kucing', 10, 4),
(12, 'Apeng', 'Kucing', 11, 3),
(13, 'Snowy', 'Anjing', 12, 3),
(14, 'Luna', 'Kucing', 14, 4),
(15, 'Lexy', 'Anjing', 15, 4);

--
-- Triggers `hewan`
--
DELIMITER $$
CREATE TRIGGER `after_insert_hewan` AFTER INSERT ON `hewan` FOR EACH ROW BEGIN
INSERT INTO hewan_log( id_hewan, activity, nama_hewan, id_pemilik, date_created ) VALUES( NEW.id_hewan, 'AFTER INSERT', NEW.nama_hewan, NEW.id_pemilik, NOW()) ;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_update_hewan` AFTER UPDATE ON `hewan` FOR EACH ROW BEGIN
    INSERT INTO hewan_log (id_hewan, activity, nama_hewan, id_pemilik, date_created)
    VALUES (NEW.id_hewan, 'AFTER UPDATE', NEW.nama_hewan, NEW.id_pemilik, NOW());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_delete_hewan` BEFORE DELETE ON `hewan` FOR EACH ROW BEGIN
    INSERT INTO hewan_log (id_hewan, activity, nama_hewan, id_pemilik, date_created)
    VALUES (OLD.id_hewan, 'BEFORE DELETE', OLD.nama_hewan, OLD.id_pemilik, NOW());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_insert_hewan` BEFORE INSERT ON `hewan` FOR EACH ROW BEGIN
    INSERT INTO hewan_log (id_hewan, activity, nama_hewan, id_pemilik, date_created)
    VALUES (NEW.id_hewan, 'BEFORE INSERT', NEW.nama_hewan, NEW.id_pemilik, NOW());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_update_hewan` BEFORE UPDATE ON `hewan` FOR EACH ROW BEGIN
    INSERT INTO hewan_log (id_hewan, activity, nama_hewan, id_pemilik, date_created)
    VALUES (OLD.id_hewan, 'BEFORE UPDATE', OLD.nama_hewan, OLD.id_pemilik, NOW());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_delete_hewan` AFTER UPDATE ON `hewan` FOR EACH ROW BEGIN
	INSERT INTO hewan_log (id_hewan, activity, nama_hewan, id_pemilik, date_created)
	VALUES (OLD.id_hewan, 'UPDATE DELETE', OLD.nama_hewan, OLD.id_pemilik, NOW());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `hewan_log`
--

CREATE TABLE `hewan_log` (
  `id_hewan` int(11) DEFAULT NULL,
  `activity` char(20) DEFAULT NULL,
  `nama_hewan` varchar(100) DEFAULT NULL,
  `id_pemilik` int(11) DEFAULT NULL,
  `date_created` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hewan_log`
--

INSERT INTO `hewan_log` (`id_hewan`, `activity`, `nama_hewan`, `id_pemilik`, `date_created`) VALUES
(16, 'BEFORE INSERT', 'Kenko', 6, '2024-07-09 18:13:40'),
(17, 'BEFORE INSERT', 'Kiki', 8, '2024-07-09 18:13:40'),
(10, 'BEFORE UPDATE', 'Doby', 2, '2024-07-09 18:18:40'),
(7, 'BEFORE DELETE', 'Bandot', 8, '2024-07-09 18:23:15'),
(7, 'BEFORE INSERT', 'Coki', 9, '2024-07-09 18:28:35'),
(7, 'AFTER INSERT', 'Coki', 9, '2024-07-09 18:28:35'),
(7, 'BEFORE UPDATE', 'Coki', 9, '2024-07-09 18:32:42'),
(7, 'AFTER UPDATE', 'Chiko', 9, '2024-07-09 18:32:42'),
(7, 'BEFORE UPDATE', 'Chiko', 9, '2024-07-09 18:33:01'),
(7, 'AFTER UPDATE', 'Chiko', 9, '2024-07-09 18:33:01'),
(11, 'BEFORE UPDATE', 'Miko', 10, '2024-07-09 18:37:01'),
(11, 'AFTER UPDATE', 'Miki', 10, '2024-07-09 18:37:01'),
(11, 'UPDATE DELETE', 'Miko', 10, '2024-07-09 18:37:01'),
(11, 'BEFORE DELETE', 'Miki', 10, '2024-07-09 18:37:01');

-- --------------------------------------------------------

--
-- Table structure for table `hewan_peliharaan`
--

CREATE TABLE `hewan_peliharaan` (
  `id_hewan` int(11) NOT NULL,
  `nama_hewan` varchar(100) DEFAULT NULL,
  `jenis_hewan` varchar(50) DEFAULT NULL,
  `id_pemilik` int(11) DEFAULT NULL,
  `umur` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hewan_peliharaan`
--

INSERT INTO `hewan_peliharaan` (`id_hewan`, `nama_hewan`, `jenis_hewan`, `id_pemilik`, `umur`) VALUES
(1, 'Dogy', 'Anjing', 3, 5),
(2, 'Gembul', 'Kucing', 1, 3),
(3, 'Dodo', 'Kucing', 2, 4);

-- --------------------------------------------------------

--
-- Table structure for table `karyawan`
--

CREATE TABLE `karyawan` (
  `id_karyawan` int(11) NOT NULL,
  `nama_karyawan` varchar(100) DEFAULT NULL,
  `nomor_telepon` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `karyawan`
--

INSERT INTO `karyawan` (`id_karyawan`, `nama_karyawan`, `nomor_telepon`) VALUES
(1, 'Maria', '082123765543'),
(2, 'Angelina', '081215636454'),
(3, 'Andika', '082345543332'),
(4, 'Firly', '081234125636'),
(5, 'Bambang', '081221331423');

-- --------------------------------------------------------

--
-- Table structure for table `pembelian`
--

CREATE TABLE `pembelian` (
  `id_pembelian` int(11) NOT NULL,
  `tanggal_pembelian` date DEFAULT NULL,
  `id_customer` int(11) DEFAULT NULL,
  `id_produk` int(11) DEFAULT NULL,
  `total_pembelian` int(25) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pembelian`
--

INSERT INTO `pembelian` (`id_pembelian`, `tanggal_pembelian`, `id_customer`, `id_produk`, `total_pembelian`) VALUES
(1, '2024-07-01', 1, 2, 65000),
(2, '2024-07-01', 2, 4, 95000),
(3, '2024-07-02', 3, 15, 75000),
(4, '2024-07-03', 4, 6, 50000),
(5, '2024-07-03', 5, 7, 55000),
(6, '2024-07-04', 8, 1, 75000),
(7, '2024-07-04', 18, 8, 95000),
(8, '2024-07-04', 12, 20, 90000),
(9, '2024-07-05', 9, 21, 75000),
(10, '2024-07-05', 6, 25, 50000),
(11, '2024-07-05', 14, 19, 95000),
(12, '2024-07-06', 15, 18, 50000),
(13, '2024-07-06', 19, 17, 55000),
(14, '2024-07-06', 11, 23, 55000),
(15, '2024-07-07', 13, 32, 32000),
(16, '2024-07-07', 10, 28, 8000),
(17, '2024-07-08', 12, 35, 35000),
(18, '2024-07-08', 13, 40, 12000),
(19, '2024-07-08', 7, 21, 75000),
(20, '2024-07-09', 8, 17, 55000),
(21, '2024-07-09', 1, 30, 26000),
(22, '2024-07-10', 11, 38, 8000),
(23, '2024-07-10', 2, 37, 20000),
(24, '2024-07-01', 2, 2, 65000);

-- --------------------------------------------------------

--
-- Table structure for table `pemilik`
--

CREATE TABLE `pemilik` (
  `id_pemilik` int(11) NOT NULL,
  `nama_pemilik` varchar(100) DEFAULT NULL,
  `alamat` varchar(200) DEFAULT NULL,
  `nomor_telepon` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pemilik`
--

INSERT INTO `pemilik` (`id_pemilik`, `nama_pemilik`, `alamat`, `nomor_telepon`) VALUES
(1, 'Annisa Ulfa', 'Jl. Pemilik No. 123', '081234567890'),
(2, 'Dina Kartika', 'Jl. Indah No. 456', '085678901234'),
(3, 'Maximila Benavania', 'Jl. Denggung No. 789', '087654321098'),
(4, 'Fitrotul Faizah', 'Jl. Semanu No. 321', '081290876543'),
(5, 'Riska Sefiana', 'Jl. Bayem No. 654', '082345678901'),
(6, 'Vinda Handayani', 'Jl. Kebumen No. 123', '081215656789'),
(7, 'Naswa febia', 'Jl. Kulonprogo No. 456', '081123456654'),
(8, 'Tania Damayanti', 'Jl. Sukoharjo No. 789', '082345543221'),
(9, 'Katrin Olivia', 'Jl. Lavender No. 321', '081908776567'),
(10, 'Loly Caterina', 'Jl. Prawiro No. 654', '082556678901'),
(11, 'Laras Sefrina', 'Jl. Pucuk No. 223', '081425367809'),
(12, 'Vivi Liana', 'Jl. Mancasan No. 453', '081567445378'),
(13, 'Mayang Sari', 'Jl. Anyelir No. 220', '083456223123'),
(14, 'Fujianti Utami', 'Jl. Gebang No. 453', '083432561212'),
(15, 'Iin Yulianti', 'Jl. Anggur No. 665', '082341145654');

-- --------------------------------------------------------

--
-- Table structure for table `penitipan`
--

CREATE TABLE `penitipan` (
  `id_penitipan` int(11) NOT NULL,
  `tanggal_masuk` date DEFAULT NULL,
  `tanggal_keluar` date DEFAULT NULL,
  `biaya` int(11) DEFAULT NULL,
  `id_hewan` int(11) DEFAULT NULL,
  `id_karyawan` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `penitipan`
--

INSERT INTO `penitipan` (`id_penitipan`, `tanggal_masuk`, `tanggal_keluar`, `biaya`, `id_hewan`, `id_karyawan`) VALUES
(1, '2024-07-01', '2024-07-05', 250000, 1, 1),
(2, '2024-07-02', '2024-07-06', 250000, 2, 2),
(3, '2024-07-02', '2024-07-04', 150000, 3, 3),
(4, '2024-07-02', '2024-07-05', 200000, 4, 4),
(5, '2024-07-03', '2024-07-06', 150000, 5, 5),
(6, '2024-07-04', '2024-07-06', 150000, 6, 1),
(7, '2024-07-04', '2024-07-08', 250000, 7, 2),
(8, '2024-07-05', '2024-07-08', 200000, 8, 3),
(9, '2024-07-05', '2024-07-09', 250000, 9, 4),
(10, '2024-07-06', '2024-07-07', 50000, 10, 5),
(11, '2024-07-04', '2024-07-06', 150000, 11, 5),
(12, '2024-07-04', '2024-07-08', 250000, 12, 4),
(13, '2024-07-05', '2024-07-08', 200000, 13, 3),
(14, '2024-07-05', '2024-07-09', 250000, 14, 2),
(15, '2024-07-06', '2024-07-07', 50000, 15, 1);

-- --------------------------------------------------------

--
-- Table structure for table `produk`
--

CREATE TABLE `produk` (
  `id_produk` int(11) NOT NULL,
  `nama_produk` varchar(100) DEFAULT NULL,
  `harga` int(11) DEFAULT NULL,
  `stok` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `produk`
--

INSERT INTO `produk` (`id_produk`, `nama_produk`, `harga`, `stok`) VALUES
(1, 'Me-O Kitten', 75000, 60),
(2, 'Felibite Dry Cat Food', 65000, 20),
(3, 'Whiskas Dry Cat Food', 50000, 30),
(4, 'Royal Canin Kitten Pouch Gravy Jelly', 95000, 100),
(5, 'BOLT Cat Food', 70000, 50),
(6, 'Friskies Meaty Grills', 50000, 30),
(7, 'Maxi Premium Cat Food', 55000, 20),
(8, 'Royal Canin Indoor Adult', 95000, 50),
(9, 'Cleo Adult Cat Food Salmon Flavor', 60000, 60),
(10, 'Equilibrio Cat Food', 55000, 50),
(11, 'Royal Canin Ageing', 90000, 50),
(12, 'Whiskas Junior', 25000, 50),
(13, 'Cat Choize Kitten Cat Food', 25000, 20),
(14, 'Pedigree Beef & Vegetable', 70000, 20),
(15, 'Pro Plan Sensitive Skin & Stomach', 75000, 25),
(16, 'Happy Dog NaturCroq Lamb & Rice', 75000, 50),
(17, 'Bravery Chicken Small Breed', 55000, 50),
(18, 'Real Nature Lake Turtle', 50000, 50),
(19, 'Royal Canin Puppy', 95000, 60),
(20, 'Royal Canin Mini Dog', 90000, 60),
(21, 'Science Diet Adult', 75000, 50),
(22, 'Instinct Original', 75000, 50),
(23, 'Wellness CORE Puppy Formula Dog', 55000, 100),
(24, 'Bolt Dog Food', 75000, 80),
(25, 'Dog Choize', 50000, 30),
(26, 'Timberwolf', 70000, 30),
(27, 'Happy Dog NaturCroq Senior', 50000, 50),
(28, 'Kalung Cat', 8000, 100),
(29, 'Kalung Dog', 10000, 50),
(30, 'Baju Cat Mini', 26000, 35),
(31, 'Baju Dog Adult', 32000, 40),
(32, 'Baju Cat Adult', 32000, 35),
(33, 'Pet Kingdom Pasir', 30000, 30),
(34, 'Unicharm Pet Deo Pasir', 35000, 30),
(35, 'MAXlife Cat Litter', 35000, 20),
(36, 'Catsan Light Pasir', 25000, 20),
(37, 'Arthacat Natural Tofu Cat Litter', 20000, 20),
(38, 'Serokan Pasir Dog/Cat', 5000, 20),
(39, 'Bak Pasir', 20000, 50),
(40, 'Spray For Cat', 12000, 50),
(41, 'Spray For Dog', 15000, 50),
(42, 'Me-O Creamy Treats Salmon', 25000, 100),
(43, 'Vitakraft Cat Stick', 25000, 80),
(44, 'Bio creamy cat treat snack ', 25000, 100),
(45, 'LIEBAO Creamy Treats ', 25000, 100),
(46, 'Mainan Kucing', 12000, 20),
(47, 'Kandang Kucing', 200000, 20);

-- --------------------------------------------------------

--
-- Table structure for table `transaksi`
--

CREATE TABLE `transaksi` (
  `id_transaksi` int(11) NOT NULL,
  `jenis_transaksi` varchar(50) DEFAULT NULL,
  `id_customer` int(11) DEFAULT NULL,
  `id_pembelian` int(11) DEFAULT NULL,
  `total_transaksi` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transaksi`
--

INSERT INTO `transaksi` (`id_transaksi`, `jenis_transaksi`, `id_customer`, `id_pembelian`, `total_transaksi`) VALUES
(1, 'Pembelian', 1, 1, 150000.00),
(2, 'Penitipan', 2, 2, 200000.00),
(3, 'Pembelian', 3, 3, 100000.00),
(4, 'Penitipan', 4, 4, 250000.00),
(5, 'Pembelian', 5, 5, 300000.00),
(6, 'Penitipan', 6, 6, 350000.00),
(7, 'Pembelian', 7, 7, 400000.00),
(8, 'Penitipan', 8, 8, 450000.00),
(9, 'Pembelian', 9, 9, 500000.00),
(10, 'Penitipan', 10, 10, 550000.00),
(11, 'Pembelian', 11, 11, 600000.00),
(12, 'Penitipan', 12, 12, 650000.00),
(13, 'Pembelian', 13, 13, 700000.00),
(14, 'Penitipan', 14, 14, 750000.00),
(15, 'Pembelian', 15, 15, 800000.00);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vi_cus`
-- (See below for the actual view)
--
CREATE TABLE `vi_cus` (
`id_customer` int(11)
,`nama_customer` varchar(100)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_customer_cal`
-- (See below for the actual view)
--
CREATE TABLE `v_customer_cal` (
`id_customer` int(11)
,`nama_customer` varchar(100)
,`nomor_telepon` varchar(20)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_customer_petshop`
-- (See below for the actual view)
--
CREATE TABLE `v_customer_petshop` (
`id_customer` int(11)
,`nama_customer` varchar(100)
,`alamat` varchar(200)
,`nomor_telepon` varchar(20)
);

-- --------------------------------------------------------

--
-- Structure for view `vi_cus`
--
DROP TABLE IF EXISTS `vi_cus`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vi_cus`  AS SELECT `v_customer_cal`.`id_customer` AS `id_customer`, `v_customer_cal`.`nama_customer` AS `nama_customer` FROM `v_customer_cal` ;

-- --------------------------------------------------------

--
-- Structure for view `v_customer_cal`
--
DROP TABLE IF EXISTS `v_customer_cal`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_customer_cal`  AS SELECT `customer`.`id_customer` AS `id_customer`, `customer`.`nama_customer` AS `nama_customer`, `customer`.`nomor_telepon` AS `nomor_telepon` FROM `customer` WHERE `customer`.`id_customer` in (10,14,18) ;

-- --------------------------------------------------------

--
-- Structure for view `v_customer_petshop`
--
DROP TABLE IF EXISTS `v_customer_petshop`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_customer_petshop`  AS SELECT `customer`.`id_customer` AS `id_customer`, `customer`.`nama_customer` AS `nama_customer`, `customer`.`alamat` AS `alamat`, `customer`.`nomor_telepon` AS `nomor_telepon` FROM `customer` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`id_customer`);

--
-- Indexes for table `hewan`
--
ALTER TABLE `hewan`
  ADD PRIMARY KEY (`id_hewan`),
  ADD KEY `id_pemilik` (`id_pemilik`);

--
-- Indexes for table `hewan_peliharaan`
--
ALTER TABLE `hewan_peliharaan`
  ADD PRIMARY KEY (`id_hewan`),
  ADD KEY `hewan_name` (`nama_hewan`,`jenis_hewan`),
  ADD KEY `idx_jenis_hewan` (`jenis_hewan`),
  ADD KEY `idx_hewan_peliharaan` (`nama_hewan`);

--
-- Indexes for table `karyawan`
--
ALTER TABLE `karyawan`
  ADD PRIMARY KEY (`id_karyawan`);

--
-- Indexes for table `pembelian`
--
ALTER TABLE `pembelian`
  ADD PRIMARY KEY (`id_pembelian`),
  ADD KEY `id_customer` (`id_customer`),
  ADD KEY `id_produk` (`id_produk`);

--
-- Indexes for table `pemilik`
--
ALTER TABLE `pemilik`
  ADD PRIMARY KEY (`id_pemilik`);

--
-- Indexes for table `penitipan`
--
ALTER TABLE `penitipan`
  ADD PRIMARY KEY (`id_penitipan`),
  ADD KEY `id_hewan` (`id_hewan`),
  ADD KEY `id_karyawan` (`id_karyawan`);

--
-- Indexes for table `produk`
--
ALTER TABLE `produk`
  ADD PRIMARY KEY (`id_produk`);

--
-- Indexes for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD PRIMARY KEY (`id_transaksi`),
  ADD KEY `id_customer` (`id_customer`),
  ADD KEY `id_pembelian` (`id_pembelian`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `customer`
--
ALTER TABLE `customer`
  MODIFY `id_customer` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `hewan`
--
ALTER TABLE `hewan`
  MODIFY `id_hewan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `karyawan`
--
ALTER TABLE `karyawan`
  MODIFY `id_karyawan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `pembelian`
--
ALTER TABLE `pembelian`
  MODIFY `id_pembelian` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `pemilik`
--
ALTER TABLE `pemilik`
  MODIFY `id_pemilik` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `penitipan`
--
ALTER TABLE `penitipan`
  MODIFY `id_penitipan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `produk`
--
ALTER TABLE `produk`
  MODIFY `id_produk` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT for table `transaksi`
--
ALTER TABLE `transaksi`
  MODIFY `id_transaksi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `hewan`
--
ALTER TABLE `hewan`
  ADD CONSTRAINT `hewan_ibfk_1` FOREIGN KEY (`id_pemilik`) REFERENCES `pemilik` (`id_pemilik`);

--
-- Constraints for table `pembelian`
--
ALTER TABLE `pembelian`
  ADD CONSTRAINT `pembelian_ibfk_1` FOREIGN KEY (`id_customer`) REFERENCES `customer` (`id_customer`),
  ADD CONSTRAINT `pembelian_ibfk_2` FOREIGN KEY (`id_produk`) REFERENCES `produk` (`id_produk`);

--
-- Constraints for table `penitipan`
--
ALTER TABLE `penitipan`
  ADD CONSTRAINT `penitipan_ibfk_1` FOREIGN KEY (`id_hewan`) REFERENCES `hewan` (`id_hewan`),
  ADD CONSTRAINT `penitipan_ibfk_2` FOREIGN KEY (`id_karyawan`) REFERENCES `karyawan` (`id_karyawan`);

--
-- Constraints for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD CONSTRAINT `transaksi_ibfk_1` FOREIGN KEY (`id_customer`) REFERENCES `customer` (`id_customer`),
  ADD CONSTRAINT `transaksi_ibfk_2` FOREIGN KEY (`id_pembelian`) REFERENCES `pembelian` (`id_pembelian`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
