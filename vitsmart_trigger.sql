DELIMITER $$

-- Trigger untuk mencatat log setelah data pengguna ditambahkan
CREATE TRIGGER AfterInsertPengguna
AFTER INSERT ON Pengguna
FOR EACH ROW
BEGIN
    INSERT INTO LogTable (Action, TableName, TimeStamp, Details)
    VALUES ('INSERT', 'Pengguna', NOW(), CONCAT('Pengguna baru ID: ', NEW.ID_Pengguna));
END$$

-- Trigger untuk memvalidasi data sebelum diinsert ke tabel Kebutuhan_Makanan
CREATE TRIGGER BeforeInsertKebutuhanMakanan
BEFORE INSERT ON Kebutuhan_Makanan
FOR EACH ROW
BEGIN
    IF NEW.Kalori < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Kalori tidak boleh bernilai negatif!';
    END IF;
END$$

-- Trigger untuk mencatat log setelah data diupdate pada tabel Pengguna
CREATE TRIGGER update_pengguna
AFTER UPDATE ON Pengguna
FOR EACH ROW
BEGIN
    INSERT INTO LogTable (Action, TableName, TimeStamp, Details)
    VALUES ('UPDATE', 'Pengguna', NOW(), CONCAT('Pengguna ID: ', OLD.ID_Pengguna, ' diubah.'));
END$$

-- Trigger untuk mencatat log setelah data dihapus dari tabel Pengguna
CREATE TRIGGER delete_pengguna
AFTER DELETE ON Pengguna
FOR EACH ROW
BEGIN
    INSERT INTO LogTable (Action, TableName, TimeStamp, Details)
    VALUES ('DELETE', 'Pengguna', NOW(), CONCAT('Pengguna ID: ', OLD.ID_Pengguna, ' dihapus.'));
END$$

-- Trigger untuk mencatat log setelah data ditambahkan ke tabel Analisis_Kesehatan
CREATE TRIGGER AfterInsertAnalisisKesehatan
AFTER INSERT ON Analisis_Kesehatan
FOR EACH ROW
BEGIN
    INSERT INTO LogTable (Action, TableName, TimeStamp, Details)
    VALUES ('INSERT', 'Analisis_Kesehatan', NOW(), CONCAT('Analisis kesehatan baru ID: ', NEW.ID_Kesehatan));
END$$

-- Trigger untuk memvalidasi data sebelum diinsert ke tabel Kebutuhan_Tidur
CREATE TRIGGER BeforeInsertKebutuhanTidur
BEFORE INSERT ON Kebutuhan_Tidur
FOR EACH ROW
BEGIN
    IF NEW.Durasi_Tidur <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Durasi tidur harus lebih dari 0!';
    END IF;
END$$

-- Trigger untuk mencatat log setelah data olahraga ditambahkan
CREATE TRIGGER AfterInsertOlahraga
AFTER INSERT ON Olahraga
FOR EACH ROW
BEGIN
    INSERT INTO LogTable (Action, TableName, TimeStamp, Details)
    VALUES ('INSERT', 'Olahraga', NOW(), CONCAT('Olahraga baru ID: ', NEW.ID_Olahraga));
END$$

-- Trigger untuk mencatat log setelah data dihapus dari tabel Olahraga
CREATE TRIGGER AfterDeleteOlahraga
AFTER DELETE ON Olahraga
FOR EACH ROW
BEGIN
    INSERT INTO LogTable (Action, TableName, TimeStamp, Details)
    VALUES ('DELETE', 'Olahraga', NOW(), CONCAT('Olahraga ID: ', OLD.ID_Olahraga, ' dihapus.'));
END$$

-- Trigger untuk mencatat log setelah data aktivitas ditambahkan
CREATE TRIGGER AfterInsertKebutuhanAktivitas
AFTER INSERT ON Kebutuhan_Aktivitas
FOR EACH ROW
BEGIN
    INSERT INTO LogTable (Action, TableName, TimeStamp, Details)
    VALUES ('INSERT', 'Kebutuhan_Aktivitas', NOW(), CONCAT('Aktivitas baru ID: ', NEW.ID_Aktivitas));
END$$

-- Trigger untuk mencatat log setelah data dihapus dari tabel Kebutuhan_Aktivitas
CREATE TRIGGER AfterDeleteKebutuhanAktivitas
AFTER DELETE ON Kebutuhan_Aktivitas
FOR EACH ROW
BEGIN
    INSERT INTO LogTable (Action, TableName, TimeStamp, Details)
    VALUES ('DELETE', 'Kebutuhan_Aktivitas', NOW(), CONCAT('Aktivitas ID: ', OLD.ID_Aktivitas, ' dihapus.'));
END$$

DELIMITER ;
