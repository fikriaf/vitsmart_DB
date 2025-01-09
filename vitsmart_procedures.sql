DELIMITER $$

-- -----------------------------------------------------------------------------------------------------------------------------
-- Procedure untuk menampilkan semua isi tabel
-- -----------------------------------------------------------------------------------------------------------------------------

-- Prosedur untuk menampilkan semua data dari tabel Pengguna
CREATE PROCEDURE GetAllPengguna()
BEGIN
    SELECT * FROM Pengguna;
END$$

-- Prosedur untuk menampilkan semua data dari tabel Data_Akun
CREATE PROCEDURE GetAllDataAkun()
BEGIN
    SELECT * FROM Data_Akun;
END$$

-- Prosedur untuk menampilkan semua data dari tabel Analisis_Kesehatan
CREATE PROCEDURE GetAllAnalisisKesehatan()
BEGIN
    SELECT * FROM Analisis_Kesehatan;
END$$

-- Prosedur untuk menampilkan semua data dari tabel Kebutuhan_Makanan
CREATE PROCEDURE GetAllKebutuhanMakanan()
BEGIN
    SELECT * FROM Kebutuhan_Makanan;
END$$

-- Prosedur untuk menampilkan semua data dari tabel Kebutuhan_Tidur
CREATE PROCEDURE GetAllKebutuhanTidur()
BEGIN
    SELECT * FROM Kebutuhan_Tidur;
END$$

-- Prosedur untuk menampilkan semua data dari tabel Kebutuhan_Aktivitas
CREATE PROCEDURE GetAllKebutuhanAktivitas()
BEGIN
    SELECT * FROM Kebutuhan_Aktivitas;
END$$

-- Prosedur untuk menampilkan semua data dari tabel Hobby
CREATE PROCEDURE GetAllHobby()
BEGIN
    SELECT * FROM Hobby;
END$$

-- Prosedur untuk menampilkan semua data dari tabel Olahraga
CREATE PROCEDURE GetAllOlahraga()
BEGIN
    SELECT * FROM Olahraga;
END$$

-- Prosedur untuk menampilkan semua data dari tabel Tabel_Vitsmart
CREATE PROCEDURE GetAllTabelVitsmart()
BEGIN
    SELECT * FROM Tabel_Vitsmart;
END$$

-- --------------------------------------------------------------- -----------------------------------------------------------------------------------------------------------------------------
-- Procedure untuk Tabel Data_Akun
-- -----------------------------------------------------------------------------------------------------------------------------

-- Insert Data_Akun --
CREATE PROCEDURE InsertDataAkun(
    IN p_Username VARCHAR(100),
    IN p_Email VARCHAR(100),
    IN p_Password VARCHAR(100),
    IN p_Tanggal_Pendaftaran DATE
)
BEGIN
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

-- Update Data_Akun --
CREATE PROCEDURE UpdateDataAkun(
    IN p_ID_Signup INT,
    IN p_Username VARCHAR(100),
    IN p_Email VARCHAR(100),
    IN p_Password VARCHAR(100),
    IN p_Tanggal_Pendaftaran DATE
)
BEGIN
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

-- Delete Data_Akun
CREATE PROCEDURE DeleteDataAkun(
    IN p_ID_Signup INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Data_Akun WHERE ID_Signup = p_ID_Signup) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Signup tidak ditemukan';
    END IF;

    DELETE FROM Data_Akun WHERE ID_Signup = p_ID_Signup;

    SELECT 'Data akun berhasil dihapus' AS success_message;

END$$

-- -----------------------------------------------------------------------------------------------------------------------------
-- Procedure untuk Tabel Pengguna
-- -----------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE InsertPengguna(
    IN p_Nama VARCHAR(100),
    IN p_Usia INT,
    IN p_Jenis_Kelamin VARCHAR(100),
    IN p_Tinggi_Badan DECIMAL(5,2),
    IN p_Berat_Badan DECIMAL(5,2),
    IN p_Riwayat_Kesehatan VARCHAR(100),
    IN p_ID_Signup INT,
    IN p_ID_Kesehatan INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Data_Akun WHERE ID_Signup = p_ID_Signup) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Signup tidak valid';
    END IF;

    IF p_ID_Kesehatan IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Analisis_Kesehatan WHERE ID_Kesehatan = p_ID_Kesehatan) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Kesehatan tidak valid';
    END IF;

    INSERT INTO Pengguna (Nama, Usia, Jenis_Kelamin, Tinggi_Badan, Berat_Badan, Riwayat_Kesehatan, ID_Signup, ID_Kesehatan)
    VALUES (p_Nama, p_Usia, p_Jenis_Kelamin, p_Tinggi_Badan, p_Berat_Badan, p_Riwayat_Kesehatan, p_ID_Signup, p_ID_Kesehatan);

    SELECT 'Data pengguna berhasil ditambahkan' AS success_message;

END$$

-- Procedure untuk memperbarui data pengguna berdasarkan ID_Pengguna
CREATE PROCEDURE UpdatePengguna(
    IN p_ID_Pengguna INT,
    IN p_Nama VARCHAR(100),
    IN p_Usia INT,
    IN p_Jenis_Kelamin VARCHAR(100),
    IN p_Tinggi_Badan DECIMAL(5,2),
    IN p_Berat_Badan DECIMAL(5,2),
    IN p_Riwayat_Kesehatan VARCHAR(100),
    IN p_ID_Signup INT,
    IN p_ID_Kesehatan INT
)
BEGIN
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

-- Procedure untuk menghapus data pengguna berdasarkan ID_Pengguna
CREATE PROCEDURE DeletePengguna(
    IN p_ID_Pengguna INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Pengguna WHERE ID_Pengguna = p_ID_Pengguna) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Pengguna tidak ditemukan';
    END IF;

    DELETE FROM Pengguna WHERE ID_Pengguna = p_ID_Pengguna;

    SELECT 'Data pengguna berhasil dihapus' AS success_message;

END$$

-- --------------------------------------------------------------- -----------------------------------------------------------------------------------------------------------------------------
-- Procedure untuk Tabel Analisis_Kesehatan
-- -----------------------------------------------------------------------------------------------------------------------------

-- Insert Analisis Kesehatan --
CREATE PROCEDURE InsertAnalisisKesehatan(
    IN p_Tanggal_Analisis DATE,
    IN p_Hasil_Analisis VARCHAR(100),
    IN p_Keterangan TEXT,
    IN p_ID_Makanan INT,
    IN p_ID_Tidur INT,
    IN p_ID_Aktivitas INT
)
BEGIN
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

-- Update Analisis Kesehatan --
CREATE PROCEDURE UpdateAnalisisKesehatan(
    IN p_ID_Kesehatan INT,
    IN p_Tanggal_Analisis DATE,
    IN p_Hasil_Analisis VARCHAR(100),
    IN p_Keterangan TEXT,
    IN p_ID_Makanan INT,
    IN p_ID_Tidur INT,
    IN p_ID_Aktivitas INT
)
BEGIN
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

-- Delete Analisis Kesehatan --
CREATE PROCEDURE DeleteAnalisisKesehatan(
    IN p_ID_Kesehatan INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Analisis_Kesehatan WHERE ID_Kesehatan = p_ID_Kesehatan) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Kesehatan tidak ditemukan';
    END IF;

    DELETE FROM Analisis_Kesehatan WHERE ID_Kesehatan = p_ID_Kesehatan;

    SELECT 'Analisis Kesehatan berhasil dihapus' AS success_message;

END$$

-- --------------------------------------------------------------- -----------------------------------------------------------------------------------------------------------------------------
-- Procedure untuk Tabel Kebutuhan_Makanan
-- -----------------------------------------------------------------------------------------------------------------------------

-- Insert Kebutuhan Makanan --
CREATE PROCEDURE InsertKebutuhanMakanan(
    IN p_Nama_Makanan VARCHAR(100),
    IN p_Kalori DECIMAL(10,2),
    IN p_Nutrisi VARCHAR(100),
    IN p_Kategori VARCHAR(100)
)
BEGIN
    INSERT INTO Kebutuhan_Makanan (Nama_Makanan, Kalori, Nutrisi, Kategori)
    VALUES (p_Nama_Makanan, p_Kalori, p_Nutrisi, p_Kategori);

    SELECT 'Kebutuhan Makanan berhasil ditambahkan' AS success_message;

END$$

-- Update Kebutuhan Makanan --
CREATE PROCEDURE UpdateKebutuhanMakanan(
    IN p_ID_Makanan INT,
    IN p_Nama_Makanan VARCHAR(100),
    IN p_Kalori DECIMAL(10,2),
    IN p_Nutrisi VARCHAR(100),
    IN p_Kategori VARCHAR(100)
)
BEGIN
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

-- Delete Kebutuhan Makanan --
CREATE PROCEDURE DeleteKebutuhanMakanan(
    IN p_ID_Makanan INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Kebutuhan_Makanan WHERE ID_Makanan = p_ID_Makanan) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Makanan tidak ditemukan';
    END IF;

    DELETE FROM Kebutuhan_Makanan WHERE ID_Makanan = p_ID_Makanan;

    SELECT 'Kebutuhan Makanan berhasil dihapus' AS success_message;

END$$

-- --------------------------------------------------------------- -----------------------------------------------------------------------------------------------------------------------------
-- Procedure untuk Tabel Kebutuhan_Tidur
-- -----------------------------------------------------------------------------------------------------------------------------

-- Insert Kebutuhan Tidur --
CREATE PROCEDURE InsertKebutuhanTidur(
    IN p_Durasi_Tidur DECIMAL(5,2),
    IN p_Waktu_Tidur TIME,
    IN p_Kualitas_Tidur VARCHAR(100)
)
BEGIN
    INSERT INTO Kebutuhan_Tidur (Durasi_Tidur, Waktu_Tidur, Kualitas_Tidur)
    VALUES (p_Durasi_Tidur, p_Waktu_Tidur, p_Kualitas_Tidur);

    SELECT 'Kebutuhan Tidur berhasil ditambahkan' AS success_message;

END$$

-- Update Kebutuhan Tidur --
CREATE PROCEDURE UpdateKebutuhanTidur(
    IN p_ID_Tidur INT,
    IN p_Durasi_Tidur DECIMAL(5,2),
    IN p_Waktu_Tidur TIME,
    IN p_Kualitas_Tidur VARCHAR(100)
)
BEGIN
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

-- Delete Kebutuhan Tidur --
CREATE PROCEDURE DeleteKebutuhanTidur(
    IN p_ID_Tidur INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Kebutuhan_Tidur WHERE ID_Tidur = p_ID_Tidur) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Tidur tidak ditemukan';
    END IF;

    DELETE FROM Kebutuhan_Tidur WHERE ID_Tidur = p_ID_Tidur;

    SELECT 'Kebutuhan Tidur berhasil dihapus' AS success_message;

END$$
-- --------------------------------------------------------------- -----------------------------------------------------------------------------------------------------------------------------
-- Procedure untuk Tabel Kebutuhan_Aktivitas
-- -----------------------------------------------------------------------------------------------------------------------------
-- Insert Kebutuhan Aktivitas --
CREATE PROCEDURE InsertKebutuhanAktivitas(
    IN p_Nama_Aktivitas VARCHAR(100),
    IN p_Durasi_Aktivitas DECIMAL(5,2),
    IN p_Kategori VARCHAR(100),
    IN p_ID_Hobby INT,
    IN p_ID_Olahraga INT
)
BEGIN
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

-- Update Kebutuhan Aktivitas --
CREATE PROCEDURE UpdateKebutuhanAktivitas(
    IN p_ID_Aktivitas INT,
    IN p_Nama_Aktivitas VARCHAR(100),
    IN p_Durasi_Aktivitas DECIMAL(5,2),
    IN p_Kategori VARCHAR(100),
    IN p_ID_Hobby INT,
    IN p_ID_Olahraga INT
)
BEGIN
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

-- Delete Kebutuhan Aktivitas --
CREATE PROCEDURE DeleteKebutuhanAktivitas(
    IN p_ID_Aktivitas INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Kebutuhan_Aktivitas WHERE ID_Aktivitas = p_ID_Aktivitas) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Aktivitas tidak ditemukan';
    END IF;

    DELETE FROM Kebutuhan_Aktivitas WHERE ID_Aktivitas = p_ID_Aktivitas;

    SELECT 'Kebutuhan Aktivitas berhasil dihapus' AS success_message;

END$$

-- --------------------------------------------------------------- -----------------------------------------------------------------------------------------------------------------------------
-- Procedure untuk Tabel Hobby
-- -----------------------------------------------------------------------------------------------------------------------------
-- Insert Hobby --
CREATE PROCEDURE InsertHobby(
    IN p_Nama_Hobby VARCHAR(100),
    IN p_Durasi_Hobby DECIMAL(5,2),
    IN p_Frekuensi_Hobby VARCHAR(100)
)
BEGIN
    INSERT INTO Hobby (Nama_Hobby, Durasi_Hobby, Frekuensi_Hobby)
    VALUES (p_Nama_Hobby, p_Durasi_Hobby, p_Frekuensi_Hobby);

    SELECT 'Hobby berhasil ditambahkan' AS success_message;

END$$

-- Update Hobby --
CREATE PROCEDURE UpdateHobby(
    IN p_ID_Hobby INT,
    IN p_Nama_Hobby VARCHAR(100),
    IN p_Durasi_Hobby DECIMAL(5,2),
    IN p_Frekuensi_Hobby VARCHAR(100)
)
BEGIN
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

-- Delete Hobby --
CREATE PROCEDURE DeleteHobby(
    IN p_ID_Hobby INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Hobby WHERE ID_Hobby = p_ID_Hobby) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Hobby tidak ditemukan';
    END IF;

    DELETE FROM Hobby WHERE ID_Hobby = p_ID_Hobby;

    SELECT 'Hobby berhasil dihapus' AS success_message;

END$$

-- --------------------------------------------------------------- -----------------------------------------------------------------------------------------------------------------------------
-- Procedure untuk Tabel Olahraga
-- -----------------------------------------------------------------------------------------------------------------------------
-- Insert Olahraga --
CREATE PROCEDURE InsertOlahraga(
    IN p_Nama_Olahraga VARCHAR(100),
    IN p_Durasi_Olahraga DECIMAL(5,2),
    IN p_Intensitas_Olahraga VARCHAR(100)
)
BEGIN
    INSERT INTO Olahraga (Nama_Olahraga, Durasi_Olahraga, Intensitas_Olahraga)
    VALUES (p_Nama_Olahraga, p_Durasi_Olahraga, p_Intensitas_Olahraga);

    SELECT 'Olahraga berhasil ditambahkan' AS success_message;

END$$

-- Update Olahraga --
CREATE PROCEDURE UpdateOlahraga(
    IN p_ID_Olahraga INT,
    IN p_Nama_Olahraga VARCHAR(100),
    IN p_Durasi_Olahraga DECIMAL(5,2),
    IN p_Intensitas_Olahraga VARCHAR(100)
)
BEGIN
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

-- Delete Olahraga --
CREATE PROCEDURE DeleteOlahraga(
    IN p_ID_Olahraga INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Olahraga WHERE ID_Olahraga = p_ID_Olahraga) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Olahraga tidak ditemukan';
    END IF;

    DELETE FROM Olahraga WHERE ID_Olahraga = p_ID_Olahraga;

    SELECT 'Olahraga berhasil dihapus' AS success_message;

END$$

-- --------------------------------------------------------------- -----------------------------------------------------------------------------------------------------------------------------
-- Procedure untuk Tabel Vitsmart_Access
-- -----------------------------------------------------------------------------------------------------------------------------
-- Insert Vitsmart_Access --
CREATE PROCEDURE InsertAccess(
    IN p_Username VARCHAR(255),
    IN p_Role VARCHAR(255),
    IN p_Access_Rights TEXT
)
BEGIN
    INSERT INTO vitsmart_access (username, role, access_rights)
    VALUES (p_Username, p_Role, p_Access_Rights);

    SELECT 'Akses berhasil ditambahkan' AS success_message;

END$$

-- Update Vitsmart_Access --
CREATE PROCEDURE UpdateAccess(
    IN p_ID INT,
    IN p_Username VARCHAR(255),
    IN p_Role VARCHAR(255),
    IN p_Access_Rights TEXT
)
BEGIN
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

-- Delete Vitsmart_Access --
CREATE PROCEDURE DeleteAccess(
    IN p_ID INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM vitsmart_access WHERE id = p_ID) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID akses tidak ditemukan';
    END IF;

    DELETE FROM vitsmart_access WHERE id = p_ID;

    SELECT 'Akses berhasil dihapus' AS success_message;

END$$

-- --------------------------------------------------------------- -----------------------------------------------------------------------------------------------------------------------------
-- Procedure untuk Tabel Table_Vitsmart
-- -----------------------------------------------------------------------------------------------------------------------------
-- Insert Table_Vitsmart --
CREATE PROCEDURE InsertTabelVitsmart(
    IN p_ID_Pengguna INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Pengguna WHERE ID_Pengguna = p_ID_Pengguna) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Pengguna tidak ditemukan';
    END IF;

    INSERT INTO Tabel_Vitsmart (ID_Pengguna)
    VALUES (p_ID_Pengguna);

    SELECT 'Data Tabel_Vitsmart berhasil ditambahkan' AS success_message;

END$$

-- Update Table_Vitsmart --
CREATE PROCEDURE UpdateTabelVitsmart(
    IN p_ID_Metadata INT,
    IN p_ID_Pengguna INT
)
BEGIN
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

-- Delete Table_Vitsmart --
CREATE PROCEDURE DeleteTabelVitsmart(
    IN p_ID_Metadata INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Tabel_Vitsmart WHERE ID_Metadata = p_ID_Metadata) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: ID_Metadata tidak ditemukan';
    END IF;

    DELETE FROM Tabel_Vitsmart WHERE ID_Metadata = p_ID_Metadata;

    SELECT 'Data Tabel_Vitsmart berhasil dihapus' AS success_message;

END$$
