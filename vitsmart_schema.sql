CREATE DATABASE Vitsmart;
USE Vitsmart;
SHOW TABLES;
SHOW TRIGGERS;
SHOW PROCEDURE STATUS WHERE Db = 'vitsmart';
select * from pengguna;

-- Tabel Hobby
CREATE TABLE Hobby (
    ID_Hobby INT AUTO_INCREMENT PRIMARY KEY,
    Nama_Hobby VARCHAR(100) NOT NULL,
    Durasi_Hobby DECIMAL(5,2) NOT NULL,
    Frekuensi_Hobby VARCHAR(100) NOT NULL,
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    action_type ENUM('INSERT', 'UPDATE', 'DELETE') DEFAULT NULL,
    old_data TEXT DEFAULT NULL,
    new_data TEXT DEFAULT NULL,
    performed_by VARCHAR(255)
);

-- Tabel Olahraga
CREATE TABLE Olahraga (
    ID_Olahraga INT AUTO_INCREMENT PRIMARY KEY,
    Nama_Olahraga VARCHAR(100) NOT NULL,
    Durasi_Olahraga DECIMAL(5,2) NOT NULL,
    Intensitas_Olahraga VARCHAR(100) NOT NULL,
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    action_type ENUM('INSERT', 'UPDATE', 'DELETE') DEFAULT NULL,
    old_data TEXT DEFAULT NULL,
    new_data TEXT DEFAULT NULL,
    performed_by VARCHAR(255)
);


-- Tabel Kebutuhan_Makanan
CREATE TABLE Kebutuhan_Makanan (
    ID_Makanan INT AUTO_INCREMENT PRIMARY KEY,
    Nama_Makanan VARCHAR(100) NOT NULL,
    Kalori DECIMAL(10,2) NOT NULL,
    Nutrisi VARCHAR(100) NOT NULL,
    Kategori VARCHAR(100) NOT NULL,
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    action_type ENUM('INSERT', 'UPDATE', 'DELETE') DEFAULT NULL,
    old_data TEXT DEFAULT NULL,
    new_data TEXT DEFAULT NULL,
    performed_by VARCHAR(255)
);

-- Tabel Kebutuhan_Tidur
CREATE TABLE Kebutuhan_Tidur (
    ID_Tidur INT AUTO_INCREMENT PRIMARY KEY,
    Durasi_Tidur DECIMAL(5,2) NOT NULL,
    Waktu_Tidur TIME NOT NULL,
    Kualitas_Tidur VARCHAR(100) NOT NULL,
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    action_type ENUM('INSERT', 'UPDATE', 'DELETE') DEFAULT NULL,
    old_data TEXT DEFAULT NULL,
    new_data TEXT DEFAULT NULL,
    performed_by VARCHAR(255)
);

-- Tabel Kebutuhan_Aktivitas
CREATE TABLE Kebutuhan_Aktivitas (
    ID_Aktivitas INT AUTO_INCREMENT PRIMARY KEY,
    Nama_Aktivitas VARCHAR(100) NOT NULL,
    Durasi_Aktivitas DECIMAL(5,2) NOT NULL,
    Kategori VARCHAR(100) NOT NULL,
    ID_Hobby INT DEFAULT NULL,
    ID_Olahraga INT DEFAULT NULL,
    FOREIGN KEY (ID_Hobby) REFERENCES Hobby(ID_Hobby),
    FOREIGN KEY (ID_Olahraga) REFERENCES Olahraga(ID_Olahraga),
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    action_type ENUM('INSERT', 'UPDATE', 'DELETE') DEFAULT NULL,
    old_data TEXT DEFAULT NULL,
    new_data TEXT DEFAULT NULL,
    performed_by VARCHAR(255)
);

-- Tabel Analisis_Kesehatan
CREATE TABLE Analisis_Kesehatan (
    ID_Kesehatan INT AUTO_INCREMENT PRIMARY KEY,
    Tanggal_Analisis DATE NOT NULL,
    Hasil_Analisis VARCHAR(100) NOT NULL,
    Keterangan TEXT DEFAULT NULL,
    ID_Makanan INT DEFAULT NULL,
    ID_Tidur INT DEFAULT NULL,
    ID_Aktivitas INT DEFAULT NULL,
    FOREIGN KEY (ID_Makanan) REFERENCES Kebutuhan_Makanan(ID_Makanan),
    FOREIGN KEY (ID_Tidur) REFERENCES Kebutuhan_Tidur(ID_Tidur),
    FOREIGN KEY (ID_Aktivitas) REFERENCES Kebutuhan_Aktivitas(ID_Aktivitas),
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    action_type ENUM('INSERT', 'UPDATE', 'DELETE') DEFAULT NULL,
    old_data TEXT DEFAULT NULL,
    new_data TEXT DEFAULT NULL,
    performed_by VARCHAR(255)
);

-- Tabel Data_Akun
CREATE TABLE Data_Akun (
    ID_Signup INT AUTO_INCREMENT PRIMARY KEY,
    Username VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Password VARCHAR(100) NOT NULL,
    Tanggal_Pendaftaran DATE NOT NULL,
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    action_type ENUM('INSERT', 'UPDATE', 'DELETE') DEFAULT NULL,
    old_data TEXT DEFAULT NULL,
    new_data TEXT DEFAULT NULL,
    performed_by VARCHAR(255)
);

-- Tabel Pengguna
CREATE TABLE Pengguna (
    ID_Pengguna INT AUTO_INCREMENT PRIMARY KEY,
    Nama VARCHAR(100) NOT NULL,
    Usia INT NOT NULL,
    Jenis_Kelamin VARCHAR(100) NOT NULL,
    Tinggi_Badan DECIMAL(5,2) NOT NULL,
    Berat_Badan DECIMAL(5,2) NOT NULL,
    Riwayat_Kesehatan VARCHAR(100),
    ID_Signup INT DEFAULT NULL,
    ID_Kesehatan INT DEFAULT NULL,
    FOREIGN KEY (ID_Signup) REFERENCES Data_Akun(ID_Signup),
    FOREIGN KEY (ID_Kesehatan) REFERENCES Analisis_Kesehatan(ID_Kesehatan),
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    action_type ENUM('INSERT', 'UPDATE', 'DELETE') DEFAULT NULL,
    old_data TEXT DEFAULT NULL,
    new_data TEXT DEFAULT NULL,
    performed_by VARCHAR(255)
);

-- Tabel Akses
CREATE TABLE vitsmart_access (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    role VARCHAR(255) NOT NULL,
    access_rights TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    action_type ENUM('INSERT', 'UPDATE', 'DELETE') DEFAULT NULL,
    old_data TEXT DEFAULT NULL,
    new_data TEXT DEFAULT NULL,
    performed_by VARCHAR(255)
);

-- Tabel Tabel_Vitsmart
CREATE TABLE Tabel_Vitsmart (
    ID_Metadata INT AUTO_INCREMENT PRIMARY KEY,
    ID_Pengguna INT NOT NULL,
    FOREIGN KEY (ID_Pengguna) REFERENCES Pengguna(ID_Pengguna),
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    action_type ENUM('INSERT', 'UPDATE', 'DELETE') DEFAULT NULL,
    old_data TEXT DEFAULT NULL,
    new_data TEXT DEFAULT NULL,
    performed_by VARCHAR(255)
);

