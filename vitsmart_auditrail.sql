DELIMITER $$

-- ------------------------------------------------------------------------------------------------------------
-- Triggers untuk Tabel Pengguna
-- ------------------------------------------------------------------------------------------------------------
CREATE TRIGGER AuditTrail_BeforeInsertPengguna
BEFORE INSERT ON Pengguna
FOR EACH ROW
BEGIN
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
END$$

CREATE TRIGGER AuditTrail_BeforeUpdatePengguna
BEFORE UPDATE ON Pengguna
FOR EACH ROW
BEGIN
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
END$$

-- ------------------------------------------------------------------------------------------------------------
-- Triggers untuk Tabel Data_Akun
-- ------------------------------------------------------------------------------------------------------------
CREATE TRIGGER AuditTrail_BeforeInsertDataAkun
BEFORE INSERT ON Data_Akun
FOR EACH ROW
BEGIN
    SET NEW.performed_by = USER();
    SET NEW.action_type = 'INSERT';
    SET NEW.new_data = CONCAT('Username = ', NEW.Username, ', Email = ', NEW.Email, ', Password = ', NEW.Password);
END$$

CREATE TRIGGER AuditTrail_BeforeUpdateDataAkun
BEFORE UPDATE ON Data_Akun
FOR EACH ROW
BEGIN
    SET NEW.performed_by = USER();
    SET NEW.action_type = 'UPDATE';
    SET NEW.old_data = CONCAT(
        'Username = ', OLD.Username, ', Email = ', OLD.Email, ', Password = ', OLD.Password
    );
    SET NEW.new_data = CONCAT(
        'Username = ', NEW.Username, ', Email = ', NEW.Email, ', Password = ', NEW.Password
    );
END$$

-- ------------------------------------------------------------------------------------------------------------
-- Triggers untuk Tabel Analisis_Kesehatan
-- ------------------------------------------------------------------------------------------------------------
CREATE TRIGGER AuditTrail_BeforeInsertAnalisisKesehatan
BEFORE INSERT ON Analisis_Kesehatan
FOR EACH ROW
BEGIN
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
END$$

CREATE TRIGGER AuditTrail_BeforeUpdateAnalisisKesehatan
BEFORE UPDATE ON Analisis_Kesehatan
FOR EACH ROW
BEGIN
    SET NEW.performed_by = USER();
    SET NEW.action_type = 'UPDATE';
	SET NEW.old_data = CONCAT('Tanggal_Analisis = ', OLD.Tanggal_Analisis, ', Hasil_Analisis = ', OLD.Hasil_Analisis, ', Keterangan = ', OLD.Keterangan, ', ID_Makanan = ', OLD.ID_Makanan, ', ID_Tidur = ', OLD.ID_Tidur, ', ID_Aktivitas = ', OLD.ID_Aktivitas);
	SET NEW.new_data = CONCAT('Tanggal_Analisis = ', NEW.Tanggal_Analisis, ', Hasil_Analisis = ', NEW.Hasil_Analisis, ', Keterangan = ', NEW.Keterangan, ', ID_Makanan = ', NEW.ID_Makanan, ', ID_Tidur = ', NEW.ID_Tidur, ', ID_Aktivitas = ', NEW.ID_Aktivitas);
END$$

-- ------------------------------------------------------------------------------------------------------------
-- Triggers untuk Tabel Kebutuhan_Makanan
-- ------------------------------------------------------------------------------------------------------------
CREATE TRIGGER AuditTrail_BeforeInsertKebutuhanMakanan
BEFORE INSERT ON Kebutuhan_Makanan
FOR EACH ROW
BEGIN
    SET NEW.performed_by = USER();
    SET NEW.action_type = 'INSERT';
    SET NEW.new_data = CONCAT(
		'Nama Makanan = ', NEW.Nama_Makanan,
		', Kalori = ', NEW.Kalori,
		', Nutrisi = ', NEW.Nutrisi,
		', Kategori = ', NEW.Kategori
    );
END$$

CREATE TRIGGER AuditTrail_BeforeUpdateKebutuhanMakanan
BEFORE UPDATE ON Kebutuhan_Makanan
FOR EACH ROW
BEGIN
    SET NEW.performed_by = USER();
    SET NEW.action_type = 'UPDATE';
	SET NEW.old_data = CONCAT('Nama Makanan = ', OLD.Nama_Makanan, ', Kalori = ', OLD.Kalori, ', Nutrisi = ', OLD.Nutrisi, ', Kategori = ', OLD.Kategori);
	SET NEW.new_data = CONCAT('Nama Makanan = ', NEW.Nama_Makanan, ', Kalori = ', NEW.Kalori, ', Nutrisi = ', NEW.Nutrisi, ', Kategori = ', NEW.Kategori);
END$$

-- ------------------------------------------------------------------------------------------------------------
-- Triggers untuk Tabel Kebutuhan_Tidur
-- ------------------------------------------------------------------------------------------------------------
CREATE TRIGGER AuditTrail_BeforeInsertKebutuhanTidur
BEFORE INSERT ON Kebutuhan_Tidur
FOR EACH ROW
BEGIN
    SET NEW.performed_by = USER();
    SET NEW.action_type = 'INSERT';
    SET NEW.new_data = CONCAT(
		'ID_Tidur = ', NEW.ID_Tidur, ', ',
		'Durasi_Tidur = ', NEW.Durasi_Tidur, ', ',
		'Waktu_Tidur = ', NEW.Waktu_Tidur, ', ',
		'Kualitas_Tidur = ', NEW.Kualitas_Tidur
	);
END$$

CREATE TRIGGER AuditTrail_BeforeUpdateKebutuhanTidur
BEFORE UPDATE ON Kebutuhan_Tidur
FOR EACH ROW
BEGIN
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
END$$

-- ------------------------------------------------------------------------------------------------------------
-- Triggers untuk Tabel Kebutuhan_Aktivitas
-- ------------------------------------------------------------------------------------------------------------
CREATE TRIGGER AuditTrail_BeforeInsertKebutuhanAktivitas
BEFORE INSERT ON Kebutuhan_Aktivitas
FOR EACH ROW
BEGIN
    SET NEW.performed_by = USER();
    SET NEW.action_type = 'INSERT';
    SET NEW.new_data = CONCAT(
		'Nama_Aktivitas = ', NEW.Nama_Aktivitas, ', ',
		'Durasi_Aktivitas = ', NEW.Durasi_Aktivitas, ', ',
		'Kategori = ', NEW.Kategori
	);
END$$

CREATE TRIGGER AuditTrail_BeforeUpdateKebutuhanAktivitas
BEFORE UPDATE ON Kebutuhan_Aktivitas
FOR EACH ROW
BEGIN
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
END$$

-- ------------------------------------------------------------------------------------------------------------
-- Triggers untuk Tabel Olahraga
-- ------------------------------------------------------------------------------------------------------------
CREATE TRIGGER AuditTrail_BeforeInsertOlahraga
BEFORE INSERT ON Olahraga
FOR EACH ROW
BEGIN
    SET NEW.performed_by = USER();
    SET NEW.action_type = 'INSERT';
    SET NEW.new_data = CONCAT(
		'Nama_Olahraga = ', NEW.Nama_Olahraga, 
		', Durasi_Olahraga = ', NEW.Durasi_Olahraga, 
		', Intensitas_Olahraga = ', NEW.Intensitas_Olahraga
    );
END$$

CREATE TRIGGER AuditTrail_BeforeUpdateOlahraga
BEFORE UPDATE ON Olahraga
FOR EACH ROW
BEGIN
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
END$$

-- ------------------------------------------------------------------------------------------------------------
-- Triggers untuk Tabel Hobby
-- ------------------------------------------------------------------------------------------------------------
CREATE TRIGGER AuditTrail_BeforeInsertHobby
BEFORE INSERT ON Hobby
FOR EACH ROW
BEGIN
    SET NEW.performed_by = USER();
    SET NEW.action_type = 'INSERT';
    SET NEW.new_data = CONCAT('Nama_Hobby = ', NEW.Nama_Hobby, ', Durasi_Hobby = ', NEW.Durasi_Hobby, ', Frekuensi_Hobby = ', NEW.Frekuensi_Hobby);
END$$

CREATE TRIGGER AuditTrail_BeforeUpdateHobby
BEFORE UPDATE ON Hobby
FOR EACH ROW
BEGIN
    SET NEW.performed_by = USER();
    SET NEW.action_type = 'UPDATE';
    SET NEW.old_data = CONCAT('Nama_Hobby = ', OLD.Nama_Hobby, ', Durasi_Hobby = ', OLD.Durasi_Hobby, ', Frekuensi_Hobby = ', OLD.Frekuensi_Hobby);
	SET NEW.new_data = CONCAT('Nama_Hobby = ', NEW.Nama_Hobby, ', Durasi_Hobby = ', NEW.Durasi_Hobby, ', Frekuensi_Hobby = ', NEW.Frekuensi_Hobby);
END$$

-- ------------------------------------------------------------------------------------------------------------
-- Triggers untuk tabel vitsmart_access
-- ------------------------------------------------------------------------------------------------------------
CREATE TRIGGER AuditTrail_BeforeInsertVitsmartAccess
BEFORE INSERT ON vitsmart_access
FOR EACH ROW
BEGIN
    SET NEW.performed_by = USER();
    SET NEW.performed_by = USER();
    SET NEW.action_type = 'INSERT';
    SET NEW.new_data = CONCAT('Username = ', NEW.username, ', Role = ', NEW.role, ', Access_Rights = ', NEW.access_rights);
END$$

CREATE TRIGGER AuditTrail_BeforeUpdateVitsmartAccess
BEFORE UPDATE ON vitsmart_access
FOR EACH ROW
BEGIN
    SET NEW.performed_by = USER();
    SET NEW.action_type = 'UPDATE';
    SET NEW.old_data = CONCAT('Username = ', OLD.username, ', Role = ', OLD.role, ', Access_Rights = ', OLD.access_rights);
	SET NEW.new_data = CONCAT('Username = ', NEW.username, ', Role = ', NEW.role, ', Access_Rights = ', NEW.access_rights);
END$$

DELIMITER ;
