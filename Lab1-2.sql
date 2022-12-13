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
('Библиотека имени Ленина', 'ул. Интернациональная, 24', 'Минск'),
('Национальная библиотека Беларуси', 'ул. Мстиславца, 86', 'Минск'),
('Президентская библиотека Республики беларусь', 'ул. Советская, 11', 'Минск')
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
('Зал научной литературы', 1, 58167, 170, '(09:00-21:00)', 2, 6),
('Зал художественной литературы', 1, 44305, 85, '(09:00-20:00)', 1, 4),
('Зал технической литературы', 2, 32658, 240, '(09:00-22:00)', 7, 10)
GO

-- ограничение, согласно которому поле BooksQuantity не может быть отрицательным
ALTER TABLE ReadingRooms
ADD 
CHECK (BooksQuantity > 0)
GO

-- ограничение, согласно которому поле SeatsQuantity не может быть отрицательным
ALTER TABLE ReadingRooms
ADD 
CHECK (SeatsQuantity > 0)
GO

-- ограничение на корректность ввода Времени работы
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
('Иванов', 'Иван', 'Иванович', 'студент', '-', 17, '2022-09-21'),
('Петров', 'Иван', 'Иванович', 'сотрудник библиотеки', 'Библиотека имени Ленина', 42, '2022-09-21'),
('Иванов', 'Петр', 'Иванович', 'профессор', 'Академия Наук', 58, '2022-09-21')
GO

-- ограничение, согласно которому поле Age не может быть меньше 6
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
('Капитанская дочка', 'Художественная', 'Пушкин А.С.', 'Аверсэв', '1999-02-13', 164, 2),
('Война и мир. Том 1', 'Художественная', 'Толстой Л.Н.', 'Аверсэв', '1989-10-31', 326, 2),
('Маленький принц', 'Художественная', 'Антуан де Сент-Экзюпери', 'Аверсэв', '2015-04-18', 144, 2)
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
( 1, 3, '2022-09-21', '14 дней', 'На руки', 'Да'),
( 2, 1, '2022-09-21', '-', 'В читальный зал', 'Нет'),
( 3, 2, '2022-09-21', '7 дней', 'На руки', 'Да')
GO

-- ограничение, согласно которому в поле CollateralAvailability могут вводиться только значения "Да" либо "Нет"
ALTER TABLE LiteratureRental
ADD 
CHECK (CollateralAvailability IN ('Да', 'Нет'))
GO

-- ограничение, согласно которому  в поле IssueDate может быть внесена только текущая дата
ALTER TABLE LiteratureRental
ADD 
CHECK (IssueDate = GETDATE())
GO


SELECT * FROM Libraries
SELECT * FROM Literature
SELECT * FROM LiteratureRental
SELECT * FROM Readers
SELECT * FROM ReadingRooms




--ЧАСТЬ 2 лабораторной работы

USE Lab2

CREATE LOGIN Employee WITH PASSWORD='EMPL1111'

CREATE LOGIN  Head WITH PASSWORD='HEAD1111'

CREATE USER ENatallia FOR LOGIN Employee

CREATE USER HSvetlana FOR LOGIN Head

-- предоставляем пользователю ENatallia право получать данные из таблицы dbo.Literature
GRANT SELECT ON dbo.Literature TO ENatallia
-- запрещаем пользователю ENatallia получать данные из таблицы dbo.СReaders
DENY SELECT ON dbo.Readers TO ENatallia

-- даем разрешение на создание таблиц пользователю HSvetlana
USE Lab2;
GRANT CREATE TABLE TO HSvetlana;
--разрешенние на вставку в таблицу
USE Lab2;
GRANT INSERT TO HSvetlana;
--изменение данных в таблице
USE Lab2;
GRANT UPDATE TO HSvetlana;
--разрешение на изменение
USE Lab2;
GRANT ALTER TO HSvetlana;
--разрешение на удаление
USE Lab2;
GRANT DELETE TO HSvetlana;



