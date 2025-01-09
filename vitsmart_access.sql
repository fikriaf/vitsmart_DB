SELECT user, host FROM mysql.user;
SELECT * FROM vitsmart_access;

INSERT INTO vitsmart_access (username, role, access_rights)
VALUES 
('vitsmart_admin', 'Admin', 'ALL PRIVILEGES ON Vitsmart.*'),
('vitsmart_master', 'User Master', 'SELECT, INSERT, UPDATE, DELETE ON Vitsmart.analisis_kesehatan'),
('vitsmart_user', 'User Standar', 'SELECT, INSERT, UPDATE ON Vitsmart.pengguna'),
('vitsmart_analyst', 'Analyst', 'SELECT ON Vitsmart.*'),
('vitsmart_logger', 'Log Manager', 'SELECT, INSERT ON Vitsmart.analisis_kesehatan, Vitsmart.olahraga');

INSERT INTO vitsmart_access (username, role, access_rights)
VALUES 
('vitsmart_dava', 'AdminDava', 'ALL PRIVILEGES ON Vitsmart.*'),
('vitsmart_fikri', 'AdminFikri', 'ALL PRIVILEGES ON Vitsmart.*');

-- Buat user Admin
CREATE USER 'vitsmart_admin'@'localhost' IDENTIFIED BY 'AdminPass123';
GRANT ALL PRIVILEGES ON Vitsmart.* TO 'vitsmart_admin'@'localhost' WITH GRANT OPTION;

CREATE USER 'vitsmart_admindava'@'localhost' IDENTIFIED BY 'AdminDava';
GRANT ALL PRIVILEGES ON Vitsmart.* TO 'vitsmart_admindava'@'localhost' WITH GRANT OPTION;

CREATE USER 'vitsmart_adminfikri'@'localhost' IDENTIFIED BY 'AdminFikri';
GRANT ALL PRIVILEGES ON Vitsmart.* TO 'vitsmart_adminfikri'@'localhost' WITH GRANT OPTION;

SHOW GRANTS FOR 'vitsmart_adminfikri'@'localhost';


-- Buat user untuk User Master
CREATE USER 'vitsmart_master'@'localhost' IDENTIFIED BY 'MasterPass123';
GRANT SELECT, INSERT, UPDATE, DELETE ON Vitsmart.analisis_kesehatan TO 'vitsmart_master'@'localhost';

-- Buat user untuk User Standar
CREATE USER 'vitsmart_user'@'localhost' IDENTIFIED BY 'UserPass123';
GRANT SELECT, INSERT, UPDATE ON Vitsmart.pengguna TO 'vitsmart_user'@'localhost';

-- Buat user untuk Analyst
CREATE USER 'vitsmart_analyst'@'localhost' IDENTIFIED BY 'AnalystPass123';
GRANT SELECT ON Vitsmart.* TO 'vitsmart_analyst'@'localhost';

-- Buat user untuk Log Manager
CREATE USER 'vitsmart_logger'@'localhost' IDENTIFIED BY 'LoggerPass123';
GRANT SELECT, INSERT ON Vitsmart.analisis_kesehatan TO 'vitsmart_logger'@'localhost';
GRANT SELECT, INSERT ON Vitsmart.olahraga TO 'vitsmart_logger'@'localhost';

-- Refresh privileges
FLUSH PRIVILEGES;