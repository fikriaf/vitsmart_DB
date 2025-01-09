DELIMITER $$

CREATE PROCEDURE CalculateBMI()
BEGIN
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

DELIMITER ;

