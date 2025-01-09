-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jan 09, 2025 at 07:44 AM
-- Server version: 8.0.31
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `vitsmart`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `CalculateBMI` ()   BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE pID_Pengguna INT;
    DECLARE pTinggi DECIMAL(5,2);
    DECLARE pBerat DECIMAL(5,2);
    DECLARE cur CURSOR FOR SELECT ID_Pengguna, Tinggi_Badan, Berat_Badan FROM Pengguna;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO pID_Pengguna, pTinggi, pBerat;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Konversi tinggi badan ke meter (jika dalam cm)
        SET pTinggi = pTinggi / 100;
        
        -- Hitung BMI
        SET @BMI = pBerat / (pTinggi * pTinggi);
        
        -- Tentukan kategori berdasarkan nilai BMI
        IF @BMI < 18.5 THEN
            SET @Keterangan = 'Kurus';
        ELSEIF @BMI >= 18.5 AND @BMI < 24.9 THEN
            SET @Keterangan = 'Normal';
        ELSEIF @BMI >= 25 AND @BMI < 29.9 THEN
            SET @Keterangan = 'Gemuk';
        ELSE
            SET @Keterangan = 'Obesitas';
        END IF;
        
        -- Periksa apakah sudah ada data untuk ID_Pengguna tersebut
        IF EXISTS (SELECT 1 FROM Analisis_Kesehatan WHERE ID_Kesehatan = pID_Pengguna) THEN
            -- Jika sudah ada, update data yang ada
            UPDATE Analisis_Kesehatan
            SET Tanggal_Analisis = CURDATE(),
                Hasil_Analisis = CONCAT('BMI: ', ROUND(@BMI, 2)),
                Keterangan = @Keterangan
            WHERE ID_Kesehatan = pID_Pengguna;
        ELSE
            -- Jika belum ada, insert data baru
            INSERT INTO Analisis_Kesehatan (ID_Kesehatan, Tanggal_Analisis, Hasil_Analisis, Keterangan, ID_Pengguna)
            VALUES (pID_Pengguna, CURDATE(), CONCAT('BMI: ', ROUND(@BMI, 2)), @Keterangan, pID_Pengguna);
        END IF;
    END LOOP;

    CLOSE cur;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteAccess` (IN `p_ID` INT)   BEGIN
    IF NOT EXISTS (SELECT 1 FROM vitsmart_access WHERE id = p_ID) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID akses tidak ditemukan';
    END IF;

    DELETE FROM vitsmart_access WHERE id = p_ID;

    SELECT 'Akses berhasil dihapus' AS success_message;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteAnalisisKesehatan` (IN `p_ID_Kesehatan` INT)   BEGIN
    IF NOT EXISTS (SELECT 1 FROM Analisis_Kesehatan WHERE ID_Kesehatan = p_ID_Kesehatan) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Kesehatan tidak ditemukan';
    END IF;

    DELETE FROM Analisis_Kesehatan WHERE ID_Kesehatan = p_ID_Kesehatan;

    SELECT 'Analisis Kesehatan berhasil dihapus' AS success_message;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteDataAkun` (IN `p_ID_Signup` INT)   BEGIN
    IF NOT EXISTS (SELECT 1 FROM Data_Akun WHERE ID_Signup = p_ID_Signup) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Signup tidak ditemukan';
    END IF;

    DELETE FROM Data_Akun WHERE ID_Signup = p_ID_Signup;

    SELECT 'Data akun berhasil dihapus' AS success_message;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteHobby` (IN `p_ID_Hobby` INT)   BEGIN
    IF NOT EXISTS (SELECT 1 FROM Hobby WHERE ID_Hobby = p_ID_Hobby) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Hobby tidak ditemukan';
    END IF;

    DELETE FROM Hobby WHERE ID_Hobby = p_ID_Hobby;

    SELECT 'Hobby berhasil dihapus' AS success_message;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteKebutuhanAktivitas` (IN `p_ID_Aktivitas` INT)   BEGIN
    IF NOT EXISTS (SELECT 1 FROM Kebutuhan_Aktivitas WHERE ID_Aktivitas = p_ID_Aktivitas) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Aktivitas tidak ditemukan';
    END IF;

    DELETE FROM Kebutuhan_Aktivitas WHERE ID_Aktivitas = p_ID_Aktivitas;

    SELECT 'Kebutuhan Aktivitas berhasil dihapus' AS success_message;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteKebutuhanMakanan` (IN `p_ID_Makanan` INT)   BEGIN
    IF NOT EXISTS (SELECT 1 FROM Kebutuhan_Makanan WHERE ID_Makanan = p_ID_Makanan) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Makanan tidak ditemukan';
    END IF;

    DELETE FROM Kebutuhan_Makanan WHERE ID_Makanan = p_ID_Makanan;

    SELECT 'Kebutuhan Makanan berhasil dihapus' AS success_message;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteKebutuhanTidur` (IN `p_ID_Tidur` INT)   BEGIN
    IF NOT EXISTS (SELECT 1 FROM Kebutuhan_Tidur WHERE ID_Tidur = p_ID_Tidur) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Tidur tidak ditemukan';
    END IF;

    DELETE FROM Kebutuhan_Tidur WHERE ID_Tidur = p_ID_Tidur;

    SELECT 'Kebutuhan Tidur berhasil dihapus' AS success_message;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteOlahraga` (IN `p_ID_Olahraga` INT)   BEGIN
    IF NOT EXISTS (SELECT 1 FROM Olahraga WHERE ID_Olahraga = p_ID_Olahraga) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Olahraga tidak ditemukan';
    END IF;

    DELETE FROM Olahraga WHERE ID_Olahraga = p_ID_Olahraga;

    SELECT 'Olahraga berhasil dihapus' AS success_message;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeletePengguna` (IN `p_ID_Pengguna` INT)   BEGIN
    IF NOT EXISTS (SELECT 1 FROM Pengguna WHERE ID_Pengguna = p_ID_Pengguna) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Pengguna tidak ditemukan';
    END IF;

    DELETE FROM Pengguna WHERE ID_Pengguna = p_ID_Pengguna;

    SELECT 'Data pengguna berhasil dihapus' AS success_message;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteTabelVitsmart` (IN `p_ID_Metadata` INT)   BEGIN
    IF NOT EXISTS (SELECT 1 FROM Tabel_Vitsmart WHERE ID_Metadata = p_ID_Metadata) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Metadata tidak ditemukan';
    END IF;

    DELETE FROM Tabel_Vitsmart WHERE ID_Metadata = p_ID_Metadata;

    SELECT 'Data Tabel_Vitsmart berhasil dihapus' AS success_message;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAllAnalisisKesehatan` ()   BEGIN
    SELECT * FROM Analisis_Kesehatan;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAllDataAkun` ()   BEGIN
    SELECT * FROM Data_Akun;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAllHobby` ()   BEGIN
    SELECT * FROM Hobby;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAllKebutuhanAktivitas` ()   BEGIN
    SELECT * FROM Kebutuhan_Aktivitas;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAllKebutuhanMakanan` ()   BEGIN
    SELECT * FROM Kebutuhan_Makanan;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAllKebutuhanTidur` ()   BEGIN
    SELECT * FROM Kebutuhan_Tidur;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAllOlahraga` ()   BEGIN
    SELECT * FROM Olahraga;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAllPengguna` ()   BEGIN
    SELECT * FROM Pengguna;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAllTabelVitsmart` ()   BEGIN
    SELECT * FROM Tabel_Vitsmart;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertAccess` (IN `p_Username` VARCHAR(255), IN `p_Role` VARCHAR(255), IN `p_Access_Rights` TEXT)   BEGIN
    INSERT INTO vitsmart_access (username, role, access_rights)
    VALUES (p_Username, p_Role, p_Access_Rights);

    SELECT 'Akses berhasil ditambahkan' AS success_message;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertAnalisisKesehatan` (IN `p_Tanggal_Analisis` DATE, IN `p_Hasil_Analisis` VARCHAR(100), IN `p_Keterangan` TEXT, IN `p_ID_Makanan` INT, IN `p_ID_Tidur` INT, IN `p_ID_Aktivitas` INT)   BEGIN
    IF p_ID_Makanan IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Kebutuhan_Makanan WHERE ID_Makanan = p_ID_Makanan) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Makanan tidak ditemukan';
    END IF;

    IF p_ID_Tidur IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Kebutuhan_Tidur WHERE ID_Tidur = p_ID_Tidur) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Tidur tidak ditemukan';
    END IF;

    IF p_ID_Aktivitas IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Kebutuhan_Aktivitas WHERE ID_Aktivitas = p_ID_Aktivitas) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Aktivitas tidak ditemukan';
    END IF;

    INSERT INTO Analisis_Kesehatan (Tanggal_Analisis, Hasil_Analisis, Keterangan, ID_Makanan, ID_Tidur, ID_Aktivitas)
    VALUES (p_Tanggal_Analisis, p_Hasil_Analisis, p_Keterangan, p_ID_Makanan, p_ID_Tidur, p_ID_Aktivitas);

    SELECT 'Analisis Kesehatan berhasil ditambahkan' AS success_message;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertDataAkun` (IN `p_Username` VARCHAR(100), IN `p_Email` VARCHAR(100), IN `p_Password` VARCHAR(100), IN `p_Tanggal_Pendaftaran` DATE)   BEGIN
    IF EXISTS (SELECT 1 FROM Data_Akun WHERE Username = p_Username) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: Username sudah digunakan';
    END IF;

    IF EXISTS (SELECT 1 FROM Data_Akun WHERE Email = p_Email) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: Email sudah digunakan';
    END IF;

    INSERT INTO Data_Akun (Username, Email, Password, Tanggal_Pendaftaran)
    VALUES (p_Username, p_Email, p_Password, p_Tanggal_Pendaftaran);

    SELECT 'Data akun berhasil ditambahkan' AS success_message;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertHobby` (IN `p_Nama_Hobby` VARCHAR(100), IN `p_Durasi_Hobby` DECIMAL(5,2), IN `p_Frekuensi_Hobby` VARCHAR(100))   BEGIN
    INSERT INTO Hobby (Nama_Hobby, Durasi_Hobby, Frekuensi_Hobby)
    VALUES (p_Nama_Hobby, p_Durasi_Hobby, p_Frekuensi_Hobby);

    SELECT 'Hobby berhasil ditambahkan' AS success_message;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertKebutuhanAktivitas` (IN `p_Nama_Aktivitas` VARCHAR(100), IN `p_Durasi_Aktivitas` DECIMAL(5,2), IN `p_Kategori` VARCHAR(100), IN `p_ID_Hobby` INT, IN `p_ID_Olahraga` INT)   BEGIN
    IF p_ID_Hobby IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Hobby WHERE ID_Hobby = p_ID_Hobby) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Hobby tidak ditemukan';
    END IF;

    IF p_ID_Olahraga IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Olahraga WHERE ID_Olahraga = p_ID_Olahraga) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Olahraga tidak ditemukan';
    END IF;

    INSERT INTO Kebutuhan_Aktivitas (Nama_Aktivitas, Durasi_Aktivitas, Kategori, ID_Hobby, ID_Olahraga)
    VALUES (p_Nama_Aktivitas, p_Durasi_Aktivitas, p_Kategori, p_ID_Hobby, p_ID_Olahraga);

    SELECT 'Kebutuhan Aktivitas berhasil ditambahkan' AS success_message;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertKebutuhanMakanan` (IN `p_Nama_Makanan` VARCHAR(100), IN `p_Kalori` DECIMAL(10,2), IN `p_Nutrisi` VARCHAR(100), IN `p_Kategori` VARCHAR(100))   BEGIN
    INSERT INTO Kebutuhan_Makanan (Nama_Makanan, Kalori, Nutrisi, Kategori)
    VALUES (p_Nama_Makanan, p_Kalori, p_Nutrisi, p_Kategori);

    SELECT 'Kebutuhan Makanan berhasil ditambahkan' AS success_message;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertKebutuhanTidur` (IN `p_Durasi_Tidur` DECIMAL(5,2), IN `p_Waktu_Tidur` TIME, IN `p_Kualitas_Tidur` VARCHAR(100))   BEGIN
    INSERT INTO Kebutuhan_Tidur (Durasi_Tidur, Waktu_Tidur, Kualitas_Tidur)
    VALUES (p_Durasi_Tidur, p_Waktu_Tidur, p_Kualitas_Tidur);

    SELECT 'Kebutuhan Tidur berhasil ditambahkan' AS success_message;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertOlahraga` (IN `p_Nama_Olahraga` VARCHAR(100), IN `p_Durasi_Olahraga` DECIMAL(5,2), IN `p_Intensitas_Olahraga` VARCHAR(100))   BEGIN
    INSERT INTO Olahraga (Nama_Olahraga, Durasi_Olahraga, Intensitas_Olahraga)
    VALUES (p_Nama_Olahraga, p_Durasi_Olahraga, p_Intensitas_Olahraga);

    SELECT 'Olahraga berhasil ditambahkan' AS success_message;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertPengguna` (IN `p_Nama` VARCHAR(100), IN `p_Usia` INT, IN `p_Jenis_Kelamin` VARCHAR(100), IN `p_Tinggi_Badan` DECIMAL(5,2), IN `p_Berat_Badan` DECIMAL(5,2), IN `p_Riwayat_Kesehatan` VARCHAR(100), IN `p_ID_Signup` INT)   BEGIN
    IF NOT EXISTS (SELECT 1 FROM Data_Akun WHERE ID_Signup = p_ID_Signup) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Signup tidak valid';
    END IF;

    INSERT INTO Pengguna (Nama, Usia, Jenis_Kelamin, Tinggi_Badan, Berat_Badan, Riwayat_Kesehatan, ID_Signup)
    VALUES (p_Nama, p_Usia, p_Jenis_Kelamin, p_Tinggi_Badan, p_Berat_Badan, p_Riwayat_Kesehatan, p_ID_Signup);

    SELECT 'Data pengguna berhasil ditambahkan' AS success_message;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertTabelVitsmart` (IN `p_ID_Pengguna` INT)   BEGIN
    IF NOT EXISTS (SELECT 1 FROM Pengguna WHERE ID_Pengguna = p_ID_Pengguna) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Pengguna tidak ditemukan';
    END IF;

    INSERT INTO Tabel_Vitsmart (ID_Pengguna)
    VALUES (p_ID_Pengguna);

    SELECT 'Data Tabel_Vitsmart berhasil ditambahkan' AS success_message;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateAccess` (IN `p_ID` INT, IN `p_Username` VARCHAR(255), IN `p_Role` VARCHAR(255), IN `p_Access_Rights` TEXT)   BEGIN
    IF NOT EXISTS (SELECT 1 FROM vitsmart_access WHERE id = p_ID) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID akses tidak ditemukan';
    END IF;

    UPDATE vitsmart_access
    SET username = p_Username,
        role = p_Role,
        access_rights = p_Access_Rights
    WHERE id = p_ID;

    SELECT 'Akses berhasil diperbarui' AS success_message;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateAnalisisKesehatan` (IN `p_ID_Kesehatan` INT, IN `p_Tanggal_Analisis` DATE, IN `p_Hasil_Analisis` VARCHAR(100), IN `p_Keterangan` TEXT, IN `p_ID_Makanan` INT, IN `p_ID_Tidur` INT, IN `p_ID_Aktivitas` INT)   BEGIN
    IF p_ID_Kesehatan IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Analisis_Kesehatan WHERE ID_Kesehatan = p_ID_Kesehatan) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Kesehatan tidak ditemukan';
    END IF;

    IF p_ID_Makanan IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Kebutuhan_Makanan WHERE ID_Makanan = p_ID_Makanan) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Makanan tidak ditemukan';
    END IF;

    IF p_ID_Tidur IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Kebutuhan_Tidur WHERE ID_Tidur = p_ID_Tidur) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Tidur tidak ditemukan';
    END IF;

    IF p_ID_Aktivitas IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Kebutuhan_Aktivitas WHERE ID_Aktivitas = p_ID_Aktivitas) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Aktivitas tidak ditemukan';
    END IF;

    UPDATE Analisis_Kesehatan
    SET Tanggal_Analisis = p_Tanggal_Analisis,
        Hasil_Analisis = p_Hasil_Analisis,
        Keterangan = p_Keterangan,
        ID_Makanan = p_ID_Makanan,
        ID_Tidur = p_ID_Tidur,
        ID_Aktivitas = p_ID_Aktivitas
    WHERE ID_Kesehatan = p_ID_Kesehatan;

    SELECT 'Analisis Kesehatan berhasil diperbarui' AS success_message;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateDataAkun` (IN `p_ID_Signup` INT, IN `p_Username` VARCHAR(100), IN `p_Email` VARCHAR(100), IN `p_Password` VARCHAR(100), IN `p_Tanggal_Pendaftaran` DATE)   BEGIN
    IF NOT EXISTS (SELECT 1 FROM Data_Akun WHERE ID_Signup = p_ID_Signup) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Signup tidak ditemukan';
    END IF;

    IF EXISTS (SELECT 1 FROM Data_Akun WHERE Username = p_Username AND ID_Signup != p_ID_Signup) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: Username sudah digunakan';
    END IF;

    IF EXISTS (SELECT 1 FROM Data_Akun WHERE Email = p_Email AND ID_Signup != p_ID_Signup) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: Email sudah digunakan';
    END IF;

    UPDATE Data_Akun
    SET Username = p_Username,
        Email = p_Email,
        Password = p_Password,
        Tanggal_Pendaftaran = p_Tanggal_Pendaftaran
    WHERE ID_Signup = p_ID_Signup;

    SELECT 'Data akun berhasil diperbarui' AS success_message;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateHobby` (IN `p_ID_Hobby` INT, IN `p_Nama_Hobby` VARCHAR(100), IN `p_Durasi_Hobby` DECIMAL(5,2), IN `p_Frekuensi_Hobby` VARCHAR(100))   BEGIN
    IF NOT EXISTS (SELECT 1 FROM Hobby WHERE ID_Hobby = p_ID_Hobby) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Hobby tidak ditemukan';
    END IF;

    UPDATE Hobby
    SET Nama_Hobby = p_Nama_Hobby,
        Durasi_Hobby = p_Durasi_Hobby,
        Frekuensi_Hobby = p_Frekuensi_Hobby
    WHERE ID_Hobby = p_ID_Hobby;

    SELECT 'Hobby berhasil diperbarui' AS success_message;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateKebutuhanAktivitas` (IN `p_ID_Aktivitas` INT, IN `p_Nama_Aktivitas` VARCHAR(100), IN `p_Durasi_Aktivitas` DECIMAL(5,2), IN `p_Kategori` VARCHAR(100), IN `p_ID_Hobby` INT, IN `p_ID_Olahraga` INT)   BEGIN
    IF p_ID_Aktivitas IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Kebutuhan_Aktivitas WHERE ID_Aktivitas = p_ID_Aktivitas) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Aktivitas tidak ditemukan';
    END IF;

    IF p_ID_Hobby IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Hobby WHERE ID_Hobby = p_ID_Hobby) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Hobby tidak ditemukan';
    END IF;

    IF p_ID_Olahraga IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Olahraga WHERE ID_Olahraga = p_ID_Olahraga) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Olahraga tidak ditemukan';
    END IF;

    UPDATE Kebutuhan_Aktivitas
    SET Nama_Aktivitas = p_Nama_Aktivitas,
        Durasi_Aktivitas = p_Durasi_Aktivitas,
        Kategori = p_Kategori,
        ID_Hobby = p_ID_Hobby,
        ID_Olahraga = p_ID_Olahraga
    WHERE ID_Aktivitas = p_ID_Aktivitas;

    SELECT 'Kebutuhan Aktivitas berhasil diperbarui' AS success_message;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateKebutuhanMakanan` (IN `p_ID_Makanan` INT, IN `p_Nama_Makanan` VARCHAR(100), IN `p_Kalori` DECIMAL(10,2), IN `p_Nutrisi` VARCHAR(100), IN `p_Kategori` VARCHAR(100))   BEGIN
    IF NOT EXISTS (SELECT 1 FROM Kebutuhan_Makanan WHERE ID_Makanan = p_ID_Makanan) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Makanan tidak ditemukan';
    END IF;

    UPDATE Kebutuhan_Makanan
    SET Nama_Makanan = p_Nama_Makanan,
        Kalori = p_Kalori,
        Nutrisi = p_Nutrisi,
        Kategori = p_Kategori
    WHERE ID_Makanan = p_ID_Makanan;

    SELECT 'Kebutuhan Makanan berhasil diperbarui' AS success_message;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateKebutuhanTidur` (IN `p_ID_Tidur` INT, IN `p_Durasi_Tidur` DECIMAL(5,2), IN `p_Waktu_Tidur` TIME, IN `p_Kualitas_Tidur` VARCHAR(100))   BEGIN
    IF NOT EXISTS (SELECT 1 FROM Kebutuhan_Tidur WHERE ID_Tidur = p_ID_Tidur) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Tidur tidak ditemukan';
    END IF;

    UPDATE Kebutuhan_Tidur
    SET Durasi_Tidur = p_Durasi_Tidur,
        Waktu_Tidur = p_Waktu_Tidur,
        Kualitas_Tidur = p_Kualitas_Tidur
    WHERE ID_Tidur = p_ID_Tidur;

    SELECT 'Kebutuhan Tidur berhasil diperbarui' AS success_message;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateOlahraga` (IN `p_ID_Olahraga` INT, IN `p_Nama_Olahraga` VARCHAR(100), IN `p_Durasi_Olahraga` DECIMAL(5,2), IN `p_Intensitas_Olahraga` VARCHAR(100))   BEGIN
    IF NOT EXISTS (SELECT 1 FROM Olahraga WHERE ID_Olahraga = p_ID_Olahraga) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Olahraga tidak ditemukan';
    END IF;

    UPDATE Olahraga
    SET Nama_Olahraga = p_Nama_Olahraga,
        Durasi_Olahraga = p_Durasi_Olahraga,
        Intensitas_Olahraga = p_Intensitas_Olahraga
    WHERE ID_Olahraga = p_ID_Olahraga;

    SELECT 'Olahraga berhasil diperbarui' AS success_message;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdatePengguna` (IN `p_ID_Pengguna` INT, IN `p_Nama` VARCHAR(100), IN `p_Usia` INT, IN `p_Jenis_Kelamin` VARCHAR(100), IN `p_Tinggi_Badan` DECIMAL(5,2), IN `p_Berat_Badan` DECIMAL(5,2), IN `p_Riwayat_Kesehatan` VARCHAR(100), IN `p_ID_Signup` INT, IN `p_ID_Kesehatan` INT)   BEGIN
    IF NOT EXISTS (SELECT 1 FROM Pengguna WHERE ID_Pengguna = p_ID_Pengguna) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Pengguna tidak ditemukan';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM Data_Akun WHERE ID_Signup = p_ID_Signup) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Signup tidak valid';
    END IF;

    IF p_ID_Kesehatan IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Analisis_Kesehatan WHERE ID_Kesehatan = p_ID_Kesehatan) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Kesehatan tidak valid';
    END IF;

    UPDATE Pengguna
    SET Nama = p_Nama,
        Usia = p_Usia,
        Jenis_Kelamin = p_Jenis_Kelamin,
        Tinggi_Badan = p_Tinggi_Badan,
        Berat_Badan = p_Berat_Badan,
        Riwayat_Kesehatan = p_Riwayat_Kesehatan,
        ID_Signup = p_ID_Signup,
        ID_Kesehatan = p_ID_Kesehatan
    WHERE ID_Pengguna = p_ID_Pengguna;

    SELECT 'Data pengguna berhasil diperbarui' AS success_message;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateTabelVitsmart` (IN `p_ID_Metadata` INT, IN `p_ID_Pengguna` INT)   BEGIN
    IF NOT EXISTS (SELECT 1 FROM Tabel_Vitsmart WHERE ID_Metadata = p_ID_Metadata) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Metadata tidak ditemukan';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM Pengguna WHERE ID_Pengguna = p_ID_Pengguna) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Pengguna tidak ditemukan';
    END IF;

    UPDATE Tabel_Vitsmart
    SET ID_Pengguna = p_ID_Pengguna
    WHERE ID_Metadata = p_ID_Metadata;

    SELECT 'Data Tabel_Vitsmart berhasil diperbarui' AS success_message;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `analisis_kesehatan`
--

CREATE TABLE `analisis_kesehatan` (
  `ID_Kesehatan` int NOT NULL,
  `Tanggal_Analisis` date NOT NULL,
  `Hasil_Analisis` varchar(100) NOT NULL,
  `Keterangan` text,
  `ID_Pengguna` int DEFAULT NULL,
  `ID_Makanan` int DEFAULT NULL,
  `ID_Tidur` int DEFAULT NULL,
  `ID_Aktivitas` int DEFAULT NULL,
  `action_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `action_type` enum('INSERT','UPDATE','DELETE') DEFAULT NULL,
  `old_data` text,
  `new_data` text,
  `performed_by` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `analisis_kesehatan`
--

INSERT INTO `analisis_kesehatan` (`ID_Kesehatan`, `Tanggal_Analisis`, `Hasil_Analisis`, `Keterangan`, `ID_Pengguna`, `ID_Makanan`, `ID_Tidur`, `ID_Aktivitas`, `action_time`, `action_type`, `old_data`, `new_data`, `performed_by`) VALUES
(1, '2025-01-08', 'BMI: 17.76', 'Kurus', 1, 1, 1, 1, '2024-12-31 16:42:02', 'UPDATE', 'Tanggal_Analisis = 2025-01-07, Hasil_Analisis = BMI: 17.76, Keterangan = Kurus, ID_Makanan = 1, ID_Tidur = 1, ID_Aktivitas = 1', 'Tanggal_Analisis = 2025-01-08, Hasil_Analisis = BMI: 17.76, Keterangan = Kurus, ID_Makanan = 1, ID_Tidur = 1, ID_Aktivitas = 1', 'root@localhost'),
(2, '2025-01-08', 'BMI: 24.91', 'Obesitas', 2, 2, 2, 2, '2024-12-31 16:42:31', 'UPDATE', 'Tanggal_Analisis = 2025-01-07, Hasil_Analisis = BMI: 24.91, Keterangan = Obesitas, ID_Makanan = 2, ID_Tidur = 2, ID_Aktivitas = 2', 'Tanggal_Analisis = 2025-01-08, Hasil_Analisis = BMI: 24.91, Keterangan = Obesitas, ID_Makanan = 2, ID_Tidur = 2, ID_Aktivitas = 2', 'root@localhost'),
(3, '2025-01-08', 'BMI: 22.68', 'Normal', 3, NULL, NULL, NULL, '2025-01-07 09:39:30', 'UPDATE', NULL, NULL, 'root@localhost'),
(4, '2025-01-08', 'BMI: 21.48', 'Normal', 4, NULL, NULL, NULL, '2025-01-07 09:39:30', 'UPDATE', NULL, NULL, 'root@localhost'),
(5, '2025-01-08', 'BMI: 22.22', 'Normal', 5, NULL, NULL, NULL, '2025-01-07 09:39:30', 'UPDATE', NULL, NULL, 'root@localhost'),
(9, '2025-01-08', 'BMI: 26.63', 'Gemuk', 9, NULL, NULL, NULL, '2025-01-07 11:39:45', 'UPDATE', NULL, NULL, 'root@localhost'),
(10, '2025-01-08', 'BMI: 22.60', 'Normal', 10, NULL, NULL, NULL, '2025-01-08 11:33:14', 'INSERT', NULL, NULL, 'root@localhost');

--
-- Triggers `analisis_kesehatan`
--
DELIMITER $$
CREATE TRIGGER `AuditTrail_BeforeInsertAnalisisKesehatan` BEFORE INSERT ON `analisis_kesehatan` FOR EACH ROW BEGIN
    SET NEW.performed_by = USER();
    SET NEW.action_type = 'INSERT';
    SET NEW.new_data = CONCAT(
		'Tanggal_Analisis = ', NEW.Tanggal_Analisis,
		', Hasil_Analisis = ', NEW.Hasil_Analisis,
		', Keterangan = ', NEW.Keterangan,
		', ID_Makanan = ', NEW.ID_Makanan,
		', ID_Tidur = ', NEW.ID_Tidur,
		', ID_Aktivitas = ', NEW.ID_Aktivitas
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `AuditTrail_BeforeUpdateAnalisisKesehatan` BEFORE UPDATE ON `analisis_kesehatan` FOR EACH ROW BEGIN
    SET NEW.performed_by = USER();
    SET NEW.action_type = 'UPDATE';
	SET NEW.old_data = CONCAT('Tanggal_Analisis = ', OLD.Tanggal_Analisis, ', Hasil_Analisis = ', OLD.Hasil_Analisis, ', Keterangan = ', OLD.Keterangan, ', ID_Makanan = ', OLD.ID_Makanan, ', ID_Tidur = ', OLD.ID_Tidur, ', ID_Aktivitas = ', OLD.ID_Aktivitas);
	SET NEW.new_data = CONCAT('Tanggal_Analisis = ', NEW.Tanggal_Analisis, ', Hasil_Analisis = ', NEW.Hasil_Analisis, ', Keterangan = ', NEW.Keterangan, ', ID_Makanan = ', NEW.ID_Makanan, ', ID_Tidur = ', NEW.ID_Tidur, ', ID_Aktivitas = ', NEW.ID_Aktivitas);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `data_akun`
--

CREATE TABLE `data_akun` (
  `ID_Signup` int NOT NULL,
  `Username` varchar(100) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `Password` varchar(100) NOT NULL,
  `Tanggal_Pendaftaran` date NOT NULL,
  `action_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `action_type` enum('INSERT','UPDATE','DELETE') DEFAULT NULL,
  `old_data` text,
  `new_data` text,
  `performed_by` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `data_akun`
--

INSERT INTO `data_akun` (`ID_Signup`, `Username`, `Email`, `Password`, `Tanggal_Pendaftaran`, `action_time`, `action_type`, `old_data`, `new_data`, `performed_by`) VALUES
(1, 'Fikri123', 'fikriarmia27@gmail.com', 'fikriaf27@', '2024-12-31', '2024-12-31 16:38:36', 'UPDATE', 'Username = Fikri123, Email = fikrfi@example.com, Password = password123', 'Username = Fikri123, Email = fikriarmia27@gmail.com, Password = fikriaf27@', 'root@localhost'),
(2, 'Dava298', 'dava@example.com', 'passworddava123', '2024-12-31', '2024-12-31 16:42:18', 'INSERT', NULL, 'Username = Dava298, Email = dava@example.com, Password = passworddava123', 'root@localhost'),
(3, 'Rizki', 'rizki@example.com', 'password123', '2025-01-01', '2025-01-07 09:16:49', 'UPDATE', 'Username = Rizki, Email = rizki@example.com, Password = password123', 'Username = Rizki, Email = rizki@example.com, Password = password123', 'root@localhost'),
(4, 'Aulia', 'aulia@example.com', 'securepass', '2025-01-02', '2025-01-07 09:16:49', 'UPDATE', 'Username = Aulia, Email = aulia@example.com, Password = securepass', 'Username = Aulia, Email = aulia@example.com, Password = securepass', 'root@localhost'),
(5, 'Nabila', 'nabila@example.com', 'mypassword', '2025-01-03', '2025-01-07 09:16:49', 'UPDATE', 'Username = Nabila, Email = nabila@example.com, Password = mypassword', 'Username = Nabila, Email = nabila@example.com, Password = mypassword', 'root@localhost'),
(8, 'vulgan', 'vulgan@gmail.com', 'vulgansaran', '2025-01-07', '2025-01-07 11:29:52', 'INSERT', NULL, 'Username = vulgan, Email = vulgan@gmail.com, Password = vulgansaran', 'root@localhost');

--
-- Triggers `data_akun`
--
DELIMITER $$
CREATE TRIGGER `AuditTrail_BeforeInsertDataAkun` BEFORE INSERT ON `data_akun` FOR EACH ROW BEGIN
    SET NEW.performed_by = USER();
    SET NEW.action_type = 'INSERT';
    SET NEW.new_data = CONCAT('Username = ', NEW.Username, ', Email = ', NEW.Email, ', Password = ', NEW.Password);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `AuditTrail_BeforeUpdateDataAkun` BEFORE UPDATE ON `data_akun` FOR EACH ROW BEGIN
    SET NEW.performed_by = USER();
    SET NEW.action_type = 'UPDATE';
    SET NEW.old_data = CONCAT(
        'Username = ', OLD.Username, ', Email = ', OLD.Email, ', Password = ', OLD.Password
    );
    SET NEW.new_data = CONCAT(
        'Username = ', NEW.Username, ', Email = ', NEW.Email, ', Password = ', NEW.Password
    );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hobby`
--

CREATE TABLE `hobby` (
  `ID_Hobby` int NOT NULL,
  `Nama_Hobby` varchar(100) NOT NULL,
  `Durasi_Hobby` decimal(5,2) NOT NULL,
  `Frekuensi_Hobby` varchar(100) NOT NULL,
  `action_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `action_type` enum('INSERT','UPDATE','DELETE') DEFAULT NULL,
  `old_data` text,
  `new_data` text,
  `performed_by` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `hobby`
--

INSERT INTO `hobby` (`ID_Hobby`, `Nama_Hobby`, `Durasi_Hobby`, `Frekuensi_Hobby`, `action_time`, `action_type`, `old_data`, `new_data`, `performed_by`) VALUES
(1, 'Membaca', '120.00', 'Setiap Hari', '2025-01-07 07:08:34', 'INSERT', NULL, 'Nama_Hobby = Membaca, Durasi_Hobby = 120.00, Frekuensi_Hobby = Setiap Hari', 'root@localhost'),
(2, 'Melukis', '90.00', 'Mingguan', '2025-01-07 07:08:34', 'INSERT', NULL, 'Nama_Hobby = Melukis, Durasi_Hobby = 90.00, Frekuensi_Hobby = Mingguan', 'root@localhost'),
(3, 'Berkebun', '150.00', 'Mingguan', '2025-01-07 07:08:34', 'INSERT', NULL, 'Nama_Hobby = Berkebun, Durasi_Hobby = 150.00, Frekuensi_Hobby = Mingguan', 'root@localhost'),
(4, 'Memasak', '60.00', 'Setiap Hari', '2025-01-07 07:08:34', 'INSERT', NULL, 'Nama_Hobby = Memasak, Durasi_Hobby = 60.00, Frekuensi_Hobby = Setiap Hari', 'root@localhost'),
(5, 'Fotografi', '180.00', 'Bulanan', '2025-01-07 07:08:34', 'INSERT', NULL, 'Nama_Hobby = Fotografi, Durasi_Hobby = 180.00, Frekuensi_Hobby = Bulanan', 'root@localhost');

--
-- Triggers `hobby`
--
DELIMITER $$
CREATE TRIGGER `AuditTrail_BeforeInsertHobby` BEFORE INSERT ON `hobby` FOR EACH ROW BEGIN
    SET NEW.performed_by = USER();
    SET NEW.action_type = 'INSERT';
    SET NEW.new_data = CONCAT('Nama_Hobby = ', NEW.Nama_Hobby, ', Durasi_Hobby = ', NEW.Durasi_Hobby, ', Frekuensi_Hobby = ', NEW.Frekuensi_Hobby);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `AuditTrail_BeforeUpdateHobby` BEFORE UPDATE ON `hobby` FOR EACH ROW BEGIN
    SET NEW.performed_by = USER();
    SET NEW.action_type = 'UPDATE';
    SET NEW.old_data = CONCAT('Nama_Hobby = ', OLD.Nama_Hobby, ', Durasi_Hobby = ', OLD.Durasi_Hobby, ', Frekuensi_Hobby = ', OLD.Frekuensi_Hobby);
	SET NEW.new_data = CONCAT('Nama_Hobby = ', NEW.Nama_Hobby, ', Durasi_Hobby = ', NEW.Durasi_Hobby, ', Frekuensi_Hobby = ', NEW.Frekuensi_Hobby);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint UNSIGNED NOT NULL,
  `reserved_at` int UNSIGNED DEFAULT NULL,
  `available_at` int UNSIGNED NOT NULL,
  `created_at` int UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `kebutuhan_aktivitas`
--

CREATE TABLE `kebutuhan_aktivitas` (
  `ID_Aktivitas` int NOT NULL,
  `Nama_Aktivitas` varchar(100) NOT NULL,
  `Durasi_Aktivitas` decimal(5,2) NOT NULL,
  `Kategori` varchar(100) NOT NULL,
  `ID_Hobby` int DEFAULT NULL,
  `ID_Olahraga` int DEFAULT NULL,
  `action_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `action_type` enum('INSERT','UPDATE','DELETE') DEFAULT NULL,
  `old_data` text,
  `new_data` text,
  `performed_by` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `kebutuhan_aktivitas`
--

INSERT INTO `kebutuhan_aktivitas` (`ID_Aktivitas`, `Nama_Aktivitas`, `Durasi_Aktivitas`, `Kategori`, `ID_Hobby`, `ID_Olahraga`, `action_time`, `action_type`, `old_data`, `new_data`, `performed_by`) VALUES
(1, 'Jogging', '30.00', 'Olahraga', 1, 1, '2025-01-07 09:02:21', 'INSERT', NULL, 'Nama_Aktivitas = Jogging, Durasi_Aktivitas = 30.00, Kategori = Olahraga', 'root@localhost'),
(2, 'Membaca Buku', '60.00', 'Hobi', 2, 2, '2025-01-07 09:02:21', 'INSERT', NULL, 'Nama_Aktivitas = Membaca Buku, Durasi_Aktivitas = 60.00, Kategori = Hobi', 'root@localhost'),
(3, 'Menonton Film', '120.00', 'Rekreasi', 3, 3, '2025-01-07 09:02:21', 'INSERT', NULL, 'Nama_Aktivitas = Menonton Film, Durasi_Aktivitas = 120.00, Kategori = Rekreasi', 'root@localhost'),
(4, 'Belajar Bahasa Asing', '45.00', 'Pendidikan', 4, 4, '2025-01-07 09:02:21', 'INSERT', NULL, 'Nama_Aktivitas = Belajar Bahasa Asing, Durasi_Aktivitas = 45.00, Kategori = Pendidikan', 'root@localhost'),
(5, 'Meditasi', '20.00', 'Relaksasi', 5, 5, '2025-01-07 09:02:21', 'INSERT', NULL, 'Nama_Aktivitas = Meditasi, Durasi_Aktivitas = 20.00, Kategori = Relaksasi', 'root@localhost');

--
-- Triggers `kebutuhan_aktivitas`
--
DELIMITER $$
CREATE TRIGGER `AuditTrail_BeforeInsertKebutuhanAktivitas` BEFORE INSERT ON `kebutuhan_aktivitas` FOR EACH ROW BEGIN
    SET NEW.performed_by = USER();
    SET NEW.action_type = 'INSERT';
    SET NEW.new_data = CONCAT(
		'Nama_Aktivitas = ', NEW.Nama_Aktivitas, ', ',
		'Durasi_Aktivitas = ', NEW.Durasi_Aktivitas, ', ',
		'Kategori = ', NEW.Kategori
	);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `AuditTrail_BeforeUpdateKebutuhanAktivitas` BEFORE UPDATE ON `kebutuhan_aktivitas` FOR EACH ROW BEGIN
    SET NEW.performed_by = USER();
    SET NEW.action_type = 'UPDATE';
    SET NEW.old_data = CONCAT(
		'Nama_Aktivitas = ', OLD.Nama_Aktivitas, ', ',
		'Durasi_Aktivitas = ', OLD.Durasi_Aktivitas, ', ',
		'Kategori = ', OLD.Kategori
	);
	SET NEW.new_data = CONCAT(
		'Nama_Aktivitas = ', NEW.Nama_Aktivitas, ', ',
		'Durasi_Aktivitas = ', NEW.Durasi_Aktivitas, ', ',
		'Kategori = ', NEW.Kategori
	);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `kebutuhan_makanan`
--

CREATE TABLE `kebutuhan_makanan` (
  `ID_Makanan` int NOT NULL,
  `Nama_Makanan` varchar(100) NOT NULL,
  `Kalori` decimal(10,2) NOT NULL,
  `Nutrisi` varchar(100) NOT NULL,
  `Kategori` enum('Vegetarian','Vegan','Gluten-Free','High Protein','Low Carb') NOT NULL,
  `action_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `action_type` enum('INSERT','UPDATE','DELETE') DEFAULT NULL,
  `old_data` text,
  `new_data` text,
  `performed_by` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `kebutuhan_makanan`
--

INSERT INTO `kebutuhan_makanan` (`ID_Makanan`, `Nama_Makanan`, `Kalori`, `Nutrisi`, `Kategori`, `action_time`, `action_type`, `old_data`, `new_data`, `performed_by`) VALUES
(1, 'Salad Sayur', '150.00', 'Serat, Vitamin A, Vitamin C', 'Vegetarian', '2025-01-04 05:48:44', 'INSERT', NULL, 'Nama Makanan = Salad Sayur, Kalori = 150.00, Nutrisi = Serat, Vitamin A, Vitamin C, Kategori = Vegetarian', 'root@localhost'),
(2, 'Tofu Stir-Fry', '200.00', 'Protein, Vitamin B12, Zat Besi', 'Vegan', '2025-01-04 05:55:19', 'INSERT', NULL, 'Nama Makanan = Tofu Stir-Fry, Kalori = 200.00, Nutrisi = Protein, Vitamin B12, Zat Besi, Kategori = Vegan', 'root@localhost'),
(3, 'Chicken Salad', '250.00', 'Protein, Vitamin B, Lemak Sehat', 'High Protein', '2025-01-04 05:55:19', 'INSERT', NULL, 'Nama Makanan = Chicken Salad, Kalori = 250.00, Nutrisi = Protein, Vitamin B, Lemak Sehat, Kategori = High Protein', 'root@localhost'),
(4, 'Gluten-Free Pasta', '300.00', 'Karbohidrat, Vitamin B6', 'Gluten-Free', '2025-01-04 05:55:19', 'INSERT', NULL, 'Nama Makanan = Gluten-Free Pasta, Kalori = 300.00, Nutrisi = Karbohidrat, Vitamin B6, Kategori = Gluten-Free', 'root@localhost'),
(5, 'Keto Chicken Wings', '350.00', 'Protein, Lemak Sehat, Vitamin B', 'Low Carb', '2025-01-04 05:55:19', 'INSERT', NULL, 'Nama Makanan = Keto Chicken Wings, Kalori = 350.00, Nutrisi = Protein, Lemak Sehat, Vitamin B, Kategori = Low Carb', 'root@localhost');

--
-- Triggers `kebutuhan_makanan`
--
DELIMITER $$
CREATE TRIGGER `AuditTrail_BeforeInsertKebutuhanMakanan` BEFORE INSERT ON `kebutuhan_makanan` FOR EACH ROW BEGIN
    SET NEW.performed_by = USER();
    SET NEW.action_type = 'INSERT';
    SET NEW.new_data = CONCAT(
		'Nama Makanan = ', NEW.Nama_Makanan,
		', Kalori = ', NEW.Kalori,
		', Nutrisi = ', NEW.Nutrisi,
		', Kategori = ', NEW.Kategori
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `AuditTrail_BeforeUpdateKebutuhanMakanan` BEFORE UPDATE ON `kebutuhan_makanan` FOR EACH ROW BEGIN
    SET NEW.performed_by = USER();
    SET NEW.action_type = 'UPDATE';
	SET NEW.old_data = CONCAT('Nama Makanan = ', OLD.Nama_Makanan, ', Kalori = ', OLD.Kalori, ', Nutrisi = ', OLD.Nutrisi, ', Kategori = ', OLD.Kategori);
	SET NEW.new_data = CONCAT('Nama Makanan = ', NEW.Nama_Makanan, ', Kalori = ', NEW.Kalori, ', Nutrisi = ', NEW.Nutrisi, ', Kategori = ', NEW.Kategori);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `kebutuhan_tidur`
--

CREATE TABLE `kebutuhan_tidur` (
  `ID_Tidur` int NOT NULL,
  `Durasi_Tidur` decimal(5,2) NOT NULL,
  `Waktu_Tidur` time NOT NULL,
  `Kualitas_Tidur` varchar(100) NOT NULL,
  `action_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `action_type` enum('INSERT','UPDATE','DELETE') DEFAULT NULL,
  `old_data` text,
  `new_data` text,
  `performed_by` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `kebutuhan_tidur`
--

INSERT INTO `kebutuhan_tidur` (`ID_Tidur`, `Durasi_Tidur`, `Waktu_Tidur`, `Kualitas_Tidur`, `action_time`, `action_type`, `old_data`, `new_data`, `performed_by`) VALUES
(1, '8.00', '22:00:00', 'Sangat Baik', '2025-01-07 06:53:44', 'INSERT', NULL, 'ID_Tidur = 0, Durasi_Tidur = 8.00, Waktu_Tidur = 22:00:00, Kualitas_Tidur = Sangat Baik', 'root@localhost'),
(2, '7.50', '23:30:00', 'Cukup Baik', '2025-01-07 06:53:44', 'INSERT', NULL, 'ID_Tidur = 0, Durasi_Tidur = 7.50, Waktu_Tidur = 23:30:00, Kualitas_Tidur = Cukup Baik', 'root@localhost'),
(3, '6.00', '00:00:00', 'Kurang', '2025-01-07 06:53:44', 'INSERT', NULL, 'ID_Tidur = 0, Durasi_Tidur = 6.00, Waktu_Tidur = 00:00:00, Kualitas_Tidur = Kurang', 'root@localhost'),
(4, '8.25', '21:45:00', 'Sangat Baik', '2025-01-07 06:53:44', 'INSERT', NULL, 'ID_Tidur = 0, Durasi_Tidur = 8.25, Waktu_Tidur = 21:45:00, Kualitas_Tidur = Sangat Baik', 'root@localhost'),
(5, '5.50', '01:15:00', 'Buruk', '2025-01-07 06:53:44', 'INSERT', NULL, 'ID_Tidur = 0, Durasi_Tidur = 5.50, Waktu_Tidur = 01:15:00, Kualitas_Tidur = Buruk', 'root@localhost');

--
-- Triggers `kebutuhan_tidur`
--
DELIMITER $$
CREATE TRIGGER `AuditTrail_BeforeInsertKebutuhanTidur` BEFORE INSERT ON `kebutuhan_tidur` FOR EACH ROW BEGIN
    SET NEW.performed_by = USER();
    SET NEW.action_type = 'INSERT';
    SET NEW.new_data = CONCAT(
		'ID_Tidur = ', NEW.ID_Tidur, ', ',
		'Durasi_Tidur = ', NEW.Durasi_Tidur, ', ',
		'Waktu_Tidur = ', NEW.Waktu_Tidur, ', ',
		'Kualitas_Tidur = ', NEW.Kualitas_Tidur
	);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `AuditTrail_BeforeUpdateKebutuhanTidur` BEFORE UPDATE ON `kebutuhan_tidur` FOR EACH ROW BEGIN
    SET NEW.performed_by = USER();
    SET NEW.action_type = 'UPDATE';
    SET NEW.old_data = CONCAT(
		'ID_Tidur = ', OLD.ID_Tidur, ', ',
		'Durasi_Tidur = ', OLD.Durasi_Tidur, ', ',
		'Waktu_Tidur = ', OLD.Waktu_Tidur, ', ',
		'Kualitas_Tidur = ', OLD.Kualitas_Tidur
	);
	SET NEW.new_data = CONCAT(
		'ID_Tidur = ', NEW.ID_Tidur, ', ',
		'Durasi_Tidur = ', NEW.Durasi_Tidur, ', ',
		'Waktu_Tidur = ', NEW.Waktu_Tidur, ', ',
		'Kualitas_Tidur = ', NEW.Kualitas_Tidur
	);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int UNSIGNED NOT NULL,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2019_12_14_000001_create_personal_access_tokens_table', 2),
(5, '2025_01_02_114546_create_tabels_table', 2),
(6, '2025_01_02_121051_create_tabels_table', 3);

-- --------------------------------------------------------

--
-- Table structure for table `olahraga`
--

CREATE TABLE `olahraga` (
  `ID_Olahraga` int NOT NULL,
  `Nama_Olahraga` varchar(100) NOT NULL,
  `Durasi_Olahraga` decimal(5,2) NOT NULL,
  `Intensitas_Olahraga` varchar(100) NOT NULL,
  `action_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `action_type` enum('INSERT','UPDATE','DELETE') DEFAULT NULL,
  `old_data` text,
  `new_data` text,
  `performed_by` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `olahraga`
--

INSERT INTO `olahraga` (`ID_Olahraga`, `Nama_Olahraga`, `Durasi_Olahraga`, `Intensitas_Olahraga`, `action_time`, `action_type`, `old_data`, `new_data`, `performed_by`) VALUES
(1, 'Lari', '30.00', 'Sedang', '2025-01-07 07:03:41', 'INSERT', NULL, 'Nama_Olahraga = Lari, Durasi_Olahraga = 30.00, Intensitas_Olahraga = Sedang', 'root@localhost'),
(2, 'Renang', '45.00', 'Tinggi', '2025-01-07 07:03:41', 'INSERT', NULL, 'Nama_Olahraga = Renang, Durasi_Olahraga = 45.00, Intensitas_Olahraga = Tinggi', 'root@localhost'),
(3, 'Yoga', '60.00', 'Ringan', '2025-01-07 07:03:41', 'INSERT', NULL, 'Nama_Olahraga = Yoga, Durasi_Olahraga = 60.00, Intensitas_Olahraga = Ringan', 'root@localhost'),
(4, 'Bersepeda', '90.00', 'Sedang', '2025-01-07 07:03:41', 'INSERT', NULL, 'Nama_Olahraga = Bersepeda, Durasi_Olahraga = 90.00, Intensitas_Olahraga = Sedang', 'root@localhost'),
(5, 'Angkat Beban', '50.00', 'Tinggi', '2025-01-07 07:03:41', 'INSERT', NULL, 'Nama_Olahraga = Angkat Beban, Durasi_Olahraga = 50.00, Intensitas_Olahraga = Tinggi', 'root@localhost');

--
-- Triggers `olahraga`
--
DELIMITER $$
CREATE TRIGGER `AuditTrail_BeforeInsertOlahraga` BEFORE INSERT ON `olahraga` FOR EACH ROW BEGIN
    SET NEW.performed_by = USER();
    SET NEW.action_type = 'INSERT';
    SET NEW.new_data = CONCAT(
		'Nama_Olahraga = ', NEW.Nama_Olahraga, 
		', Durasi_Olahraga = ', NEW.Durasi_Olahraga, 
		', Intensitas_Olahraga = ', NEW.Intensitas_Olahraga
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `AuditTrail_BeforeUpdateOlahraga` BEFORE UPDATE ON `olahraga` FOR EACH ROW BEGIN
    SET NEW.performed_by = USER();
    SET NEW.action_type = 'UPDATE';
    SET NEW.old_data = CONCAT(
		'Nama_Olahraga = ', OLD.Nama_Olahraga, 
		', Durasi_Olahraga = ', OLD.Durasi_Olahraga, 
		', Intensitas_Olahraga = ', OLD.Intensitas_Olahraga
    );
	SET NEW.new_data = CONCAT(
		'Nama_Olahraga = ', NEW.Nama_Olahraga, 
		', Durasi_Olahraga = ', NEW.Durasi_Olahraga, 
		', Intensitas_Olahraga = ', NEW.Intensitas_Olahraga
    );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pengguna`
--

CREATE TABLE `pengguna` (
  `ID_Pengguna` int NOT NULL,
  `Nama` varchar(100) NOT NULL,
  `Usia` int NOT NULL,
  `Jenis_Kelamin` varchar(100) NOT NULL,
  `Tinggi_Badan` decimal(5,2) NOT NULL,
  `Berat_Badan` decimal(5,2) NOT NULL,
  `Riwayat_Kesehatan` varchar(100) DEFAULT NULL,
  `ID_Signup` int DEFAULT NULL,
  `action_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `action_type` enum('INSERT','UPDATE','DELETE') DEFAULT NULL,
  `old_data` text,
  `new_data` text,
  `performed_by` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `pengguna`
--

INSERT INTO `pengguna` (`ID_Pengguna`, `Nama`, `Usia`, `Jenis_Kelamin`, `Tinggi_Badan`, `Berat_Badan`, `Riwayat_Kesehatan`, `ID_Signup`, `action_time`, `action_type`, `old_data`, `new_data`, `performed_by`) VALUES
(1, 'Fikri Armia Fahmi', 20, 'Laki-laki', '175.52', '55.00', 'Sehat', 1, '2024-12-31 16:39:57', 'UPDATE', 'ID_Pengguna = 1, Nama = Fikri Armia Fahmi, Usia = 20, Jenis_Kelamin = Laki-laki, Tinggi_Badan = 175.52, Berat_Badan = 60.00, Riwayat_Kesehatan = Sehat, ', 'ID_Pengguna = 1, Nama = Fikri Armia Fahmi, Usia = 20, Jenis_Kelamin = Laki-laki, Tinggi_Badan = 175.52, Berat_Badan = 55.00, Riwayat_Kesehatan = Sehat, ', 'root@localhost'),
(2, 'Dava Ferdian Hadiputra', 20, 'Laki-laki', '170.00', '72.00', 'Sehat', 2, '2024-12-31 16:42:26', 'UPDATE', 'ID_Pengguna = 2, Nama = Dava Ferdian Hadiputra, Usia = 20, Jenis_Kelamin = Laki-laki, Tinggi_Badan = 170.00, Berat_Badan = 72.00, Riwayat_Kesehatan = Sehat, ', 'ID_Pengguna = 2, Nama = Dava Ferdian Hadiputra, Usia = 20, Jenis_Kelamin = Laki-laki, Tinggi_Badan = 170.00, Berat_Badan = 72.00, Riwayat_Kesehatan = Sehat, ', 'root@localhost'),
(3, 'Rizki Ahmad', 25, 'Laki-laki', '175.50', '70.25', 'Sehat', 3, '2025-01-07 09:19:53', 'UPDATE', 'ID_Pengguna = 6, Nama = Rizki Ahmad, Usia = 25, Jenis_Kelamin = Laki-laki, Tinggi_Badan = 175.50, Berat_Badan = 70.25, Riwayat_Kesehatan = Sehat, ', 'ID_Pengguna = 3, Nama = Rizki Ahmad, Usia = 25, Jenis_Kelamin = Laki-laki, Tinggi_Badan = 175.50, Berat_Badan = 70.25, Riwayat_Kesehatan = Sehat, ', 'root@localhost'),
(4, 'Aulia Putri', 22, 'Perempuan', '160.00', '55.00', 'Sehat', 4, '2025-01-07 09:19:53', 'UPDATE', 'ID_Pengguna = 7, Nama = Aulia Putri, Usia = 22, Jenis_Kelamin = Perempuan, Tinggi_Badan = 160.00, Berat_Badan = 55.00, Riwayat_Kesehatan = Sehat, ', 'ID_Pengguna = 4, Nama = Aulia Putri, Usia = 22, Jenis_Kelamin = Perempuan, Tinggi_Badan = 160.00, Berat_Badan = 55.00, Riwayat_Kesehatan = Sehat, ', 'root@localhost'),
(5, 'Nabila Sari', 30, 'Perempuan', '165.00', '60.50', 'Diabetes', 5, '2025-01-07 09:19:53', 'UPDATE', 'ID_Pengguna = 8, Nama = Nabila Sari, Usia = 30, Jenis_Kelamin = Perempuan, Tinggi_Badan = 165.00, Berat_Badan = 60.50, Riwayat_Kesehatan = Diabetes, ', 'ID_Pengguna = 5, Nama = Nabila Sari, Usia = 30, Jenis_Kelamin = Perempuan, Tinggi_Badan = 165.00, Berat_Badan = 60.50, Riwayat_Kesehatan = Diabetes, ', 'root@localhost'),
(9, 'vulgan', 13, 'Laki-laki', '130.00', '45.00', 'Sehat', 8, '2025-01-07 11:39:22', 'INSERT', NULL, 'ID_Pengguna = 0, Nama = vulgan, Usia = 13, Jenis_Kelamin = Laki-laki, Tinggi_Badan = 130.00, Berat_Badan = 45.00, Riwayat_Kesehatan = Sehat, ', 'root@localhost'),
(10, 'Fikri Armia Fahmi', 30, 'Laki-laki', '175.50', '70.00', 'Sehat', 1, '2025-01-08 11:33:14', 'INSERT', NULL, 'ID_Pengguna = 0, Nama = Fikri Armia Fahmi, Usia = 30, Jenis_Kelamin = Laki-laki, Tinggi_Badan = 175.50, Berat_Badan = 70.00, Riwayat_Kesehatan = Sehat, ', 'root@localhost');

--
-- Triggers `pengguna`
--
DELIMITER $$
CREATE TRIGGER `After_Pengguna_Delete` AFTER DELETE ON `pengguna` FOR EACH ROW BEGIN
    -- Panggil prosedur CalculateBMI
    CALL CalculateBMI();
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `After_Pengguna_Insert` AFTER INSERT ON `pengguna` FOR EACH ROW BEGIN
    -- Panggil prosedur CalculateBMI
    CALL CalculateBMI();
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `After_Pengguna_Update` AFTER UPDATE ON `pengguna` FOR EACH ROW BEGIN
    -- Panggil prosedur CalculateBMI
    CALL CalculateBMI();
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `AuditTrail_BeforeInsertPengguna` BEFORE INSERT ON `pengguna` FOR EACH ROW BEGIN
    SET NEW.performed_by = USER();
    SET NEW.action_type = 'INSERT';
    SET NEW.new_data = CONCAT(
            'ID_Pengguna = ', NEW.ID_Pengguna, ', ',
            'Nama = ', NEW.Nama, ', ',
            'Usia = ', NEW.Usia, ', ',
            'Jenis_Kelamin = ', NEW.Jenis_Kelamin, ', ',
            'Tinggi_Badan = ', NEW.Tinggi_Badan, ', ',
            'Berat_Badan = ', NEW.Berat_Badan, ', ',
            'Riwayat_Kesehatan = ', NEW.Riwayat_Kesehatan, ', '
	);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `AuditTrail_BeforeUpdatePengguna` BEFORE UPDATE ON `pengguna` FOR EACH ROW BEGIN
    SET NEW.performed_by = USER();
    SET NEW.action_type = 'UPDATE';
    SET NEW.old_data = CONCAT(
            'ID_Pengguna = ', OLD.ID_Pengguna, ', ',
            'Nama = ', OLD.Nama, ', ',
            'Usia = ', OLD.Usia, ', ',
            'Jenis_Kelamin = ', OLD.Jenis_Kelamin, ', ',
            'Tinggi_Badan = ', OLD.Tinggi_Badan, ', ',
            'Berat_Badan = ', OLD.Berat_Badan, ', ',
            'Riwayat_Kesehatan = ', OLD.Riwayat_Kesehatan, ', '
	);
    SET NEW.new_data = CONCAT(
            'ID_Pengguna = ', NEW.ID_Pengguna, ', ',
            'Nama = ', NEW.Nama, ', ',
            'Usia = ', NEW.Usia, ', ',
            'Jenis_Kelamin = ', NEW.Jenis_Kelamin, ', ',
            'Tinggi_Badan = ', NEW.Tinggi_Badan, ', ',
            'Berat_Badan = ', NEW.Berat_Badan, ', ',
            'Riwayat_Kesehatan = ', NEW.Riwayat_Kesehatan, ', '
	);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('ppV3NOBjOwnxyoSK7gRMy7ViVWj5QYJ9wE4yT58A', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRmpJQmo4RzIzUTBBYUlSMHQ3UGxnaUt3RU1Tb05sQmIxOTRTemJCVyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDA6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hbmFsaXNpcy1rZXNlaGF0YW4iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1735814474);

-- --------------------------------------------------------

--
-- Table structure for table `tabels`
--

CREATE TABLE `tabels` (
  `id` bigint UNSIGNED NOT NULL,
  `table_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `tabels`
--

INSERT INTO `tabels` (`id`, `table_name`, `created_at`, `updated_at`) VALUES
(1, 'analisis_kesehatan', '2025-01-03 00:26:29', '2025-01-03 00:26:29'),
(2, 'data_akun', '2025-01-02 05:13:04', '2025-01-02 05:13:04'),
(3, 'hobby', '2025-01-02 05:13:04', '2025-01-02 05:13:04'),
(4, 'kebutuhan_aktivitas', '2025-01-02 05:13:04', '2025-01-02 05:13:04'),
(5, 'kebutuhan_makanan', '2025-01-02 05:13:04', '2025-01-02 05:13:04'),
(6, 'kebutuhan_tidur', '2025-01-02 05:13:04', '2025-01-02 05:13:04'),
(7, 'olahraga', '2025-01-02 05:13:04', '2025-01-02 05:13:04'),
(8, 'pengguna', '2025-01-02 05:13:04', '2025-01-02 05:13:04'),
(9, 'tabel_vitsmart', '2025-01-02 05:13:04', '2025-01-02 05:13:04'),
(10, 'vitsmart_access', '2025-01-02 05:13:04', '2025-01-02 05:13:04');

-- --------------------------------------------------------

--
-- Table structure for table `tabel_vitsmart`
--

CREATE TABLE `tabel_vitsmart` (
  `ID_Metadata` int NOT NULL,
  `ID_Pengguna` int NOT NULL,
  `action_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `action_type` enum('INSERT','UPDATE','DELETE') DEFAULT NULL,
  `old_data` text,
  `new_data` text,
  `performed_by` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'vitsmart_admin', 'vitsmart@gmail.com', NULL, '$2y$10$Ki.YzJB09dVJAsBnT5rmjeJ0WGmE5HXeayP3euNBFLhCmfRmKT4pe', NULL, '2025-01-02 04:14:48', '2025-01-02 04:14:48'),
(2, 'vitsmart2', 'vitsmart2@gmail.com', NULL, '$2y$10$2af9je8n1ctoYYPveRVNs.N/CwGDlNTULszdtQ2fnGTrrVM309I7W', NULL, '2025-01-02 17:07:05', '2025-01-02 17:07:05'),
(3, 'fikri', 'fikir@gmail.com', NULL, '$2y$10$hfmeM6iy7h0wzT5rYOvpR.NdaKViN.PP5y9KDlnLHVaDiYHMIg7Nq', NULL, '2025-01-02 19:25:07', '2025-01-02 19:25:07');

-- --------------------------------------------------------

--
-- Table structure for table `vitsmart_access`
--

CREATE TABLE `vitsmart_access` (
  `id` int NOT NULL,
  `username` varchar(255) NOT NULL,
  `role` varchar(255) NOT NULL,
  `access_rights` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `action_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `action_type` enum('INSERT','UPDATE','DELETE') DEFAULT NULL,
  `old_data` text,
  `new_data` text,
  `performed_by` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `vitsmart_access`
--

INSERT INTO `vitsmart_access` (`id`, `username`, `role`, `access_rights`, `created_at`, `action_time`, `action_type`, `old_data`, `new_data`, `performed_by`) VALUES
(1, 'vitsmart_admin', 'Admin', 'ALL PRIVILEGES ON Vitsmart.*', '2024-12-31 16:38:13', '2024-12-31 16:38:13', 'INSERT', NULL, 'Username = vitsmart_admin, Role = Admin, Access_Rights = ALL PRIVILEGES ON Vitsmart.*', 'root@localhost'),
(2, 'vitsmart_master', 'User Master', 'SELECT, INSERT, UPDATE, DELETE ON Vitsmart.analisis_kesehatan', '2024-12-31 16:38:13', '2024-12-31 16:38:13', 'INSERT', NULL, 'Username = vitsmart_master, Role = User Master, Access_Rights = SELECT, INSERT, UPDATE, DELETE ON Vitsmart.analisis_kesehatan', 'root@localhost'),
(3, 'vitsmart_user', 'User Standar', 'SELECT, INSERT, UPDATE ON Vitsmart.pengguna', '2024-12-31 16:38:13', '2024-12-31 16:38:13', 'INSERT', NULL, 'Username = vitsmart_user, Role = User Standar, Access_Rights = SELECT, INSERT, UPDATE ON Vitsmart.pengguna', 'root@localhost'),
(4, 'vitsmart_analyst', 'Analyst', 'SELECT, INSERT, UPDATE, DELETE ON Vitsmart.analisis_kesehatan', '2024-12-31 16:38:13', '2024-12-31 16:38:13', 'UPDATE', 'Username = vitsmart_analyst, Role = Analyst, Access_Rights = SELECT ON Vitsmart.*', 'Username = vitsmart_analyst, Role = Analyst, Access_Rights = SELECT, INSERT, UPDATE, DELETE ON Vitsmart.analisis_kesehatan', 'root@localhost'),
(5, 'vitsmart_logger', 'Log Manager', 'SELECT, INSERT ON Vitsmart.analisis_kesehatan, Vitsmart.olahraga', '2024-12-31 16:38:13', '2024-12-31 16:38:13', 'INSERT', NULL, 'Username = vitsmart_logger, Role = Log Manager, Access_Rights = SELECT, INSERT ON Vitsmart.analisis_kesehatan, Vitsmart.olahraga', 'root@localhost'),
(6, 'vitsmart_dava', 'AdminDava', 'ALL PRIVILEGES ON Vitsmart.*', '2024-12-31 16:38:13', '2024-12-31 16:38:13', 'INSERT', NULL, 'Username = vitsmart_dava, Role = AdminDava, Access_Rights = ALL PRIVILEGES ON Vitsmart.*', 'root@localhost'),
(7, 'vitsmart_fikri', 'AdminFikri', 'ALL PRIVILEGES ON Vitsmart.*', '2024-12-31 16:38:13', '2024-12-31 16:38:13', 'INSERT', NULL, 'Username = vitsmart_fikri, Role = AdminFikri, Access_Rights = ALL PRIVILEGES ON Vitsmart.*', 'root@localhost'),
(8, 'root', 'Admin', 'ALL PRIVILEGES ON Vitsmart.*', '2025-01-03 16:04:17', '2025-01-03 16:04:17', 'UPDATE', 'Username = root, Role = Admin, Access_Rights = ALL PRIVILEGES ON Vtsmart.*', 'Username = root, Role = Admin, Access_Rights = ALL PRIVILEGES ON Vitsmart.*', 'root@localhost');

--
-- Triggers `vitsmart_access`
--
DELIMITER $$
CREATE TRIGGER `AuditTrail_BeforeInsertVitsmartAccess` BEFORE INSERT ON `vitsmart_access` FOR EACH ROW BEGIN
    SET NEW.performed_by = USER();
    SET NEW.performed_by = USER();
    SET NEW.action_type = 'INSERT';
    SET NEW.new_data = CONCAT('Username = ', NEW.username, ', Role = ', NEW.role, ', Access_Rights = ', NEW.access_rights);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `AuditTrail_BeforeUpdateVitsmartAccess` BEFORE UPDATE ON `vitsmart_access` FOR EACH ROW BEGIN
    SET NEW.performed_by = USER();
    SET NEW.action_type = 'UPDATE';
    SET NEW.old_data = CONCAT('Username = ', OLD.username, ', Role = ', OLD.role, ', Access_Rights = ', OLD.access_rights);
	SET NEW.new_data = CONCAT('Username = ', NEW.username, ', Role = ', NEW.role, ', Access_Rights = ', NEW.access_rights);
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `analisis_kesehatan`
--
ALTER TABLE `analisis_kesehatan`
  ADD PRIMARY KEY (`ID_Kesehatan`),
  ADD KEY `ID_Makanan` (`ID_Makanan`),
  ADD KEY `ID_Tidur` (`ID_Tidur`),
  ADD KEY `ID_Aktivitas` (`ID_Aktivitas`),
  ADD KEY `ID_Pengguna` (`ID_Pengguna`) USING BTREE;

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `data_akun`
--
ALTER TABLE `data_akun`
  ADD PRIMARY KEY (`ID_Signup`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `hobby`
--
ALTER TABLE `hobby`
  ADD PRIMARY KEY (`ID_Hobby`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `kebutuhan_aktivitas`
--
ALTER TABLE `kebutuhan_aktivitas`
  ADD PRIMARY KEY (`ID_Aktivitas`),
  ADD KEY `ID_Hobby` (`ID_Hobby`),
  ADD KEY `ID_Olahraga` (`ID_Olahraga`);

--
-- Indexes for table `kebutuhan_makanan`
--
ALTER TABLE `kebutuhan_makanan`
  ADD PRIMARY KEY (`ID_Makanan`);

--
-- Indexes for table `kebutuhan_tidur`
--
ALTER TABLE `kebutuhan_tidur`
  ADD PRIMARY KEY (`ID_Tidur`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `olahraga`
--
ALTER TABLE `olahraga`
  ADD PRIMARY KEY (`ID_Olahraga`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `pengguna`
--
ALTER TABLE `pengguna`
  ADD PRIMARY KEY (`ID_Pengguna`),
  ADD KEY `ID_Signup` (`ID_Signup`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `tabels`
--
ALTER TABLE `tabels`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tabel_vitsmart`
--
ALTER TABLE `tabel_vitsmart`
  ADD PRIMARY KEY (`ID_Metadata`),
  ADD KEY `ID_Pengguna` (`ID_Pengguna`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- Indexes for table `vitsmart_access`
--
ALTER TABLE `vitsmart_access`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `analisis_kesehatan`
--
ALTER TABLE `analisis_kesehatan`
  MODIFY `ID_Kesehatan` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `data_akun`
--
ALTER TABLE `data_akun`
  MODIFY `ID_Signup` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hobby`
--
ALTER TABLE `hobby`
  MODIFY `ID_Hobby` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `kebutuhan_aktivitas`
--
ALTER TABLE `kebutuhan_aktivitas`
  MODIFY `ID_Aktivitas` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `kebutuhan_makanan`
--
ALTER TABLE `kebutuhan_makanan`
  MODIFY `ID_Makanan` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `kebutuhan_tidur`
--
ALTER TABLE `kebutuhan_tidur`
  MODIFY `ID_Tidur` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `olahraga`
--
ALTER TABLE `olahraga`
  MODIFY `ID_Olahraga` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `pengguna`
--
ALTER TABLE `pengguna`
  MODIFY `ID_Pengguna` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tabels`
--
ALTER TABLE `tabels`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `tabel_vitsmart`
--
ALTER TABLE `tabel_vitsmart`
  MODIFY `ID_Metadata` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `vitsmart_access`
--
ALTER TABLE `vitsmart_access`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `analisis_kesehatan`
--
ALTER TABLE `analisis_kesehatan`
  ADD CONSTRAINT `analisis_kesehatan_ibfk_1` FOREIGN KEY (`ID_Makanan`) REFERENCES `kebutuhan_makanan` (`ID_Makanan`),
  ADD CONSTRAINT `analisis_kesehatan_ibfk_2` FOREIGN KEY (`ID_Tidur`) REFERENCES `kebutuhan_tidur` (`ID_Tidur`),
  ADD CONSTRAINT `analisis_kesehatan_ibfk_3` FOREIGN KEY (`ID_Aktivitas`) REFERENCES `kebutuhan_aktivitas` (`ID_Aktivitas`),
  ADD CONSTRAINT `analisis_kesehatan_ibfk_4` FOREIGN KEY (`ID_Pengguna`) REFERENCES `pengguna` (`ID_Pengguna`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `kebutuhan_aktivitas`
--
ALTER TABLE `kebutuhan_aktivitas`
  ADD CONSTRAINT `kebutuhan_aktivitas_ibfk_1` FOREIGN KEY (`ID_Hobby`) REFERENCES `hobby` (`ID_Hobby`),
  ADD CONSTRAINT `kebutuhan_aktivitas_ibfk_2` FOREIGN KEY (`ID_Olahraga`) REFERENCES `olahraga` (`ID_Olahraga`);

--
-- Constraints for table `pengguna`
--
ALTER TABLE `pengguna`
  ADD CONSTRAINT `pengguna_ibfk_1` FOREIGN KEY (`ID_Signup`) REFERENCES `data_akun` (`ID_Signup`);

--
-- Constraints for table `tabel_vitsmart`
--
ALTER TABLE `tabel_vitsmart`
  ADD CONSTRAINT `tabel_vitsmart_ibfk_1` FOREIGN KEY (`ID_Pengguna`) REFERENCES `pengguna` (`ID_Pengguna`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
