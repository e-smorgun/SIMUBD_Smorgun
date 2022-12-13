CREATE DATABASE Lab2
GO

CREATE TABLE Libraries (
    LibraryID int IDENTITY(1,1) PRIMARY KEY,
    LibraryName varchar(255) NOT NULL,
    LibraryAddress varchar(255) NOT NULL,
    City varchar(255)
);
GO

INSERT Libraries
(LibraryName, LibraryAddress, City)
VALUES
('���������� ����� ������', '��. �����������������, 24', '�����'),
('������������ ���������� ��������', '��. ����������, 86', '�����'),
('������������� ���������� ���������� ��������', '��. ���������, 11', '�����')
GO

SELECT * FROM Libraries


CREATE TABLE ReadingRooms (
    ReadingRoomID int IDENTITY(1,1) PRIMARY KEY,
    ReadingRoomName varchar(255) NOT NULL,
    LibraryID int DEFAULT 0 FOREIGN KEY REFERENCES Libraries(LibraryID),
    BooksQuantity int NOT NULL,
	SeatsQuantity int NOT NULL,
	WorkTime varchar(50) NOT NULL,
	ReadingRoomFloor int NOT NULL,
	EmployeesQuantity int NOT NULL
);
GO

INSERT ReadingRooms
(ReadingRoomName, LibraryID, BooksQuantity, SeatsQuantity, WorkTime, ReadingRoomFloor, EmployeesQuantity)
VALUES
('��� ������� ����������', 1, 58167, 170, '(09:00-21:00)', 2, 6),
('��� �������������� ����������', 1, 44305, 85, '(09:00-20:00)', 1, 4),
('��� ����������� ����������', 2, 32658, 240, '(09:00-22:00)', 7, 10)
GO

-- �����������, �������� �������� ���� BooksQuantity �� ����� ���� �������������
ALTER TABLE ReadingRooms
ADD 
CHECK (BooksQuantity > 0)
GO

-- �����������, �������� �������� ���� SeatsQuantity �� ����� ���� �������������
ALTER TABLE ReadingRooms
ADD 
CHECK (SeatsQuantity > 0)
GO

-- ����������� �� ������������ ����� ������� ������
ALTER TABLE ReadingRooms
ADD 
CHECK (WorkTime LIKE '([0-9][0-9]:[0-9][0-9]-[0-9][0-9]:[0-9][0-9])')
GO






CREATE TABLE Readers (
    ReaderID int IDENTITY(1,1) PRIMARY KEY,
    RSurname varchar(50) NOT NULL,
	RName varchar(50) NOT NULL,
	RPatronymic varchar(50) NOT NULL,
	ReaderCategory varchar(50) NOT NULL,
	PlaceOfWork varchar(255) NOT NULL,
	Age int NOT NULL,
	RegistrationDate date NOT NULL
);
GO

INSERT Readers
(RSurname, RName, RPatronymic, ReaderCategory, PlaceOfWork, Age, RegistrationDate)
VALUES
('������', '����', '��������', '�������', '-', 17, '2022-09-21'),
('������', '����', '��������', '��������� ����������', '���������� ����� ������', 42, '2022-09-21'),
('������', '����', '��������', '���������', '�������� ����', 58, '2022-09-21')
GO

-- �����������, �������� �������� ���� Age �� ����� ���� ������ 6
ALTER TABLE Readers
ADD 
CHECK (Age >= 6)
GO



CREATE TABLE Literature (
    BookID int IDENTITY(1,1) PRIMARY KEY,
    BookName varchar(255) NOT NULL,
	BookCategory varchar(50) NOT NULL,
	Authors varchar(255) NOT NULL,
	PublishingHouse varchar(255) NOT NULL,
	PublicationDate date NOT NULL,
	PagesQuantity int NOT NULL,
	ReadingRoom int DEFAULT 0 FOREIGN KEY REFERENCES ReadingRooms(ReadingRoomID),
);
GO

INSERT Literature
(BookName, BookCategory, Authors, PublishingHouse, PublicationDate, PagesQuantity, ReadingRoom)
VALUES
('����������� �����', '��������������', '������ �.�.', '�������', '1999-02-13', 164, 2),
('����� � ���. ��� 1', '��������������', '������� �.�.', '�������', '1989-10-31', 326, 2),
('��������� �����', '��������������', '������ �� ����-��������', '�������', '2015-04-18', 144, 2)
GO


CREATE TABLE LiteratureRental (
    RentalID int IDENTITY(1,1) PRIMARY KEY,
	ReaderID int DEFAULT 0 FOREIGN KEY REFERENCES Readers(ReaderID),
	BookID int DEFAULT 0 FOREIGN KEY REFERENCES Literature(BookID),
	IssueDate date NOT NULL,
	RentalPeriod varchar(50) NOT NULL,
	RentalType varchar(50) NOT NULL,
	CollateralAvailability varchar(10) NOT NULL
);
GO

INSERT LiteratureRental
(ReaderID, BookID, IssueDate, RentalPeriod, RentalType, CollateralAvailability)
VALUES
( 1, 3, '2022-09-21', '14 ����', '�� ����', '��'),
( 2, 1, '2022-09-21', '-', '� ��������� ���', '���'),
( 3, 2, '2022-09-21', '7 ����', '�� ����', '��')
GO

-- �����������, �������� �������� � ���� CollateralAvailability ����� ��������� ������ �������� "��" ���� "���"
ALTER TABLE LiteratureRental
ADD 
CHECK (CollateralAvailability IN ('��', '���'))
GO

-- �����������, �������� ��������  � ���� IssueDate ����� ���� ������� ������ ������� ����
ALTER TABLE LiteratureRental
ADD 
CHECK (IssueDate = GETDATE())
GO


SELECT * FROM Libraries
SELECT * FROM Literature
SELECT * FROM LiteratureRental
SELECT * FROM Readers
SELECT * FROM ReadingRooms




--����� 2 ������������ ������

USE Lab2

CREATE LOGIN Employee WITH PASSWORD='EMPL1111'

CREATE LOGIN  Head WITH PASSWORD='HEAD1111'

CREATE USER ENatallia FOR LOGIN Employee

CREATE USER HSvetlana FOR LOGIN Head

-- ������������� ������������ ENatallia ����� �������� ������ �� ������� dbo.Literature
GRANT SELECT ON dbo.Literature TO ENatallia
-- ��������� ������������ ENatallia �������� ������ �� ������� dbo.�Readers
DENY SELECT ON dbo.Readers TO ENatallia

-- ���� ���������� �� �������� ������ ������������ HSvetlana
USE Lab2;
GRANT CREATE TABLE TO HSvetlana;
--����������� �� ������� � �������
USE Lab2;
GRANT INSERT TO HSvetlana;
--��������� ������ � �������
USE Lab2;
GRANT UPDATE TO HSvetlana;
--���������� �� ���������
USE Lab2;
GRANT ALTER TO HSvetlana;
--���������� �� ��������
USE Lab2;
GRANT DELETE TO HSvetlana;



