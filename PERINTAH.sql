-- Memanggil procedure untuk menampilkan semua isi tabel
CALL GetAllDataAkun();
CALL GetAllPengguna();
CALL GetAllAnalisisKesehatan();
CALL GetAllKebutuhanMakanan();
CALL GetAllKebutuhanTidur();
CALL GetAllKebutuhanAktivitas();
CALL GetAllHobby();
CALL GetAllOlahraga();
CALL GetAllTabelVitsmart();

CALL InsertDataAkun('Fikri123', 'fikrfi@example.com', 'password123', '2024-12-31');
CALL InsertDataAkun('Fikri12sd3', 'fiekri@example.com', 'password123', '2024-12-31');
CALL InsertDataAkun('Dava298', 'dava@example.com', 'passworddava123', '2024-12-31');

CALL InsertPengguna(
    'Fikri Armia Fahmi',
    30,
    'Laki-laki',
    175.50,
    70.00,
    'Sehat',
    1,
    NULL
);

CALL InsertPengguna(
    'Dava Ferdian Hadiputra',
    31,
    'Laki-laki',
    176.00,
    72.00,
    'Sehat',
    2,
    null
);

CALL CalculateBMI();
SELECT * FROM Analisis_Kesehatan;
TRUNCATE TABLE Analisis_Kesehatan;


