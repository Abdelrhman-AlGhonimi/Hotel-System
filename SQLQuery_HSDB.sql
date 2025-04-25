---------------------Create Database Of Hotel Managment System -----------------

Create database HSDB
on (
name = 'HSDBdata' , --mdf file
filename = 'D:\HSDBdata.mdf'
)
log on (
name ='HSDBLog', --ldf file
filename ='D:\HSDBLog.ldf'
)

use HSDB


backup database HSDB
to disk  ='D:\HSDB.bak'
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------



--====================
-- MAIN ENTITIES
--====================

CREATE TABLE Admin (
    admin_id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE Staff (
    staff_id INT PRIMARY KEY,
    name VARCHAR(100),
    role VARCHAR(20) CHECK (role IN ('manager', 'receptionist')),
    admin_id INT,
    FOREIGN KEY (admin_id) REFERENCES Admin(admin_id)
);

CREATE TABLE Guest (
    guest_id INT PRIMARY KEY,
    f_name VARCHAR(50),
    l_name VARCHAR(50),
	
);

CREATE TABLE Room (
    room_id INT PRIMARY KEY,
    room_number VARCHAR(10),
    room_price DECIMAL(10, 2),
    room_status VARCHAR(20) CHECK (room_status IN ('available', 'under_maintenance', 'occupied')),
    admin_id INT,
    FOREIGN KEY (admin_id) REFERENCES Admin(admin_id)
);

--====================
-- MULTI-VALUED ATTRIBUTES
--====================

CREATE TABLE AdminPhone (
    phone_id INT PRIMARY KEY IDENTITY,
    admin_id INT,
    phone INT,
    FOREIGN KEY (admin_id) REFERENCES Admin(admin_id)
);

CREATE TABLE AdminEmail (
    email_id INT PRIMARY KEY IDENTITY,
    admin_id INT,
    email VARCHAR(100),
    FOREIGN KEY (admin_id) REFERENCES Admin(admin_id)
);

CREATE TABLE StaffPhone (
    phone_id INT PRIMARY KEY IDENTITY,
    staff_id INT,
    phone INT,
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
);

CREATE TABLE StaffEmail (
    email_id INT PRIMARY KEY IDENTITY,
    staff_id INT,
    email VARCHAR(100),
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
);

CREATE TABLE GuestPhone (
    phone_id INT PRIMARY KEY IDENTITY,
    guest_id INT,
    phone INT,
    FOREIGN KEY (guest_id) REFERENCES Guest(guest_id)
);

CREATE TABLE GuestEmail (
    email_id INT PRIMARY KEY IDENTITY,
    guest_id INT,
    email VARCHAR(100),
    FOREIGN KEY (guest_id) REFERENCES Guest(guest_id)
);

--====================
-- MAIN RELATIONS
--====================

CREATE TABLE Booking (
    booking_id INT PRIMARY KEY,
    room_id INT,
    guest_id INT,
    total_price DECIMAL(10,2),
    booking_status VARCHAR(20) CHECK (booking_status IN ('confirmed', 'cancelled')),
    check_in_date DATE DEFAULT GETDATE(),
    check_out_date DATE DEFAULT GETDATE(),
    staff_id INT,
	admin_id INT ,
    FOREIGN KEY (room_id) REFERENCES Room(room_id),
    FOREIGN KEY (guest_id) REFERENCES Guest(guest_id),
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id),
	FOREIGN KEY (admin_id) REFERENCES Admin(admin_id)

);

CREATE TABLE Payment (
    payment_id INT PRIMARY KEY,
    booking_id INT,
    guest_id INT,
    payment_date DATE DEFAULT GETDATE(),
    payment_amount DECIMAL(10, 2),
    payment_status VARCHAR(20) CHECK (payment_status IN ('paid', 'pending')),
    admin_id INT,
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id),
    FOREIGN KEY (guest_id) REFERENCES Guest(guest_id),
    FOREIGN KEY (admin_id) REFERENCES Admin(admin_id)
);

CREATE TABLE Review (
    review_id INT PRIMARY KEY,
    comment TEXT,
    rating INT,
    guest_id INT,
    room_id INT,
    review_date DATE DEFAULT GETDATE(),
    admin_id INT,
    FOREIGN KEY (guest_id) REFERENCES Guest(guest_id),
    FOREIGN KEY (room_id) REFERENCES Room(room_id),
    FOREIGN KEY (admin_id) REFERENCES Admin(admin_id)
);

-- تعديل جدول Guest لإضافة كلمة المرور
ALTER TABLE Guest ADD password VARCHAR(50) NOT NULL DEFAULT '';

-- تعديل جدول Staff
ALTER TABLE Staff ADD password VARCHAR(50) NOT NULL DEFAULT '';

-- تعديل جدول Admin
ALTER TABLE Admin ADD password VARCHAR(50) NOT NULL DEFAULT ''; 


alter table review ADD booking_id int 
alter table review ADD foreign key (booking_id) references booking(booking_id)


ALTER TABLE Room ADD CONSTRAINT UQ_RoomNumber UNIQUE (room_number);


INSERT INTO Room (room_id, room_number, room_price, room_status, admin_id) VALUES (1, '101', 150.00, 'available', 1);

INSERT INTO Booking (booking_id, room_id, guest_id, total_price, booking_status, check_in_date, check_out_date, staff_id, admin_id)
VALUES (1, 1, 1, 300.00, 'confirmed', '2023-10-01', '2023-10-05', 1, 1);

UPDATE Room SET room_status = 'occupied' WHERE room_id = 1;

SELECT * FROM Room WHERE room_status NOT IN ('available', 'under_maintenance', 'occupied');

SELECT * FROM Booking WHERE booking_status NOT IN ('confirmed', 'cancelled');


UPDATE Room SET room_price = 100.00 WHERE room_id = 1;
UPDATE Room SET room_price = 150.00 WHERE room_id = 2;

SELECT * FROM Payment;









-------------------------------------




INSERT INTO Guest (guest_id, f_name, l_name, password)
VALUES
 (1, 'Ahmed', 'Mohamed', 'pass123'),
 (2, 'Mohamed', 'Khaled',  'pass123'),
 (3, 'Salah',   'Abed',   'pass123'),
 (4, 'Hatem',   'Adel',   'pass123'),
 (5, 'Alaa',    'Mohamed','pass123'),
 (6, 'Reda',    'Mohamed','pass123'),
 (7, 'Shahd',   'Gehad',  'pass123'),
 (8, 'Mena',    'Salah',  'pass123'),
 (9, 'Salma',   'Amr',    'pass123'),
 (10,'Fouad',   'Amr',    'pass123');



INSERT INTO GuestPhone (guest_id, phone)
VALUES
 (1, 01023456789),
 (2, 01034567890),
 (3, 01045678901),
 (4, 01056789012),
 (5, 01067890123),
 (6, 01078901234),
 (7, 01089012345),
 (8, 01090123456),
 (9, 01001234567),
 (10,01012345678);


INSERT INTO GuestEmail (guest_id, email)
VALUES
 (1, 'Ahmed@gmail.com'),
 (2, 'Mohamed@gmail.com'),
 (3, 'Salah@gmail.com'),
 (4, 'Hatem@gmail.com'),
 (5, 'Alaa@gmail.com'),
 (6, 'Reda@gmail.com'),
 (7, 'Shahd@gmail.com'),
 (8, 'Mena@gmail.com'),
 (9, 'Salma@gmail.com'),
 (10,'Fouad@gmail.com');










 SELECT 
    f.name AS ForeignKey,
    OBJECT_NAME(f.parent_object_id) AS TableName,
    COL_NAME(fc.parent_object_id, fc.parent_column_id) AS ColumnName,
    OBJECT_NAME(f.referenced_object_id) AS ReferencedTable,
    COL_NAME(fc.referenced_object_id, fc.referenced_column_id) AS ReferencedColumn
FROM 
    sys.foreign_keys AS f
INNER JOIN 
    sys.foreign_key_columns AS fc 
    ON f.object_id = fc.constraint_object_id
ORDER BY 
    TableName;





INSERT INTO Staff (staff_id, name, role, admin_id, password)
VALUES
 (1, 'Omar',      'manager',       1, 'pass123'),
 (2, 'Youssef',   'receptionist',  1, 'pass123'),
 (3, 'Laila',     'receptionist',  1, 'pass123'),
 (4, 'Hassan',    'manager',       1, 'pass123'),
 (5, 'Reem',      'receptionist',  1, 'pass123'),
 (6, 'Adel',      'manager',       1, 'pass123'),
 (7, 'Mariam',    'receptionist',  1, 'pass123'),
 (8, 'Nour',      'manager',       1, 'pass123'),
 (9, 'Sami',      'receptionist',  1, 'pass123'),
 (10,'Dina',      'manager',       1, 'pass123');


INSERT INTO StaffPhone (staff_id, phone)
VALUES
 (1, 01023456700),
 (2, 01034567801),
 (3, 01045678902),
 (4, 01056789003),
 (5, 01067890104),
 (6, 01078901205),
 (7, 01089012306),
 (8, 01090123407),
 (9, 01001234508),
 (10,01012345609);

INSERT INTO StaffEmail (staff_id, email)
VALUES
 (1, 'Omar@gmail.com'),
 (2, 'Youssef@gmail.com'),
 (3, 'Laila@gmail.com'),
 (4, 'Hassan@gmail.com'),
 (5, 'Reem@gmail.com'),
 (6, 'Adel@gmail.com'),
 (7, 'Mariam@gmail.com'),
 (8, 'Nour@gmail.com'),
 (9, 'Sami@gmail.com'),
 (10,'Dina@gmail.com');





 INSERT INTO Room (room_id, room_number, room_price, room_status, admin_id)
VALUES
 (2, '102', 200.00, 'available', 1),
 (3, '103', 180.00, 'available', 1),
 (4, '104', 250.00, 'under_maintenance', 1),
 (5, '105', 300.00, 'occupied', 1),
 (6, '106', 220.00, 'available', 1),
 (7, '107', 190.00, 'under_maintenance', 1),
 (8, '108', 210.00, 'available', 1),
 (9, '109', 275.00, 'occupied', 1),
 (10,'110', 230.00, 'available', 1);


 SELECT * FROM Guest;
SELECT * FROM GuestPhone;
SELECT * FROM GuestEmail;