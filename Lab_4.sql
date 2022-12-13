
---- 4 ������������


--1 ������ ��� �������� ��������� ������� ����� ���������� ���� TABLE;

DECLARE @mytable TABLE (id INT, myname CHAR(20) DEFAULT '������ ����')
INSERT INTO @mytable(id) VALUES (1)
INSERT INTO @mytable(id, myname) VALUES (2,'����� �������') 
SELECT * FROM @mytable


--2 ������� � �������������� �������� ����������� IF;

DECLARE @a INT 
DECLARE @str CHAR(50)
SET @a = (SELECT COUNT(*) FROM Customers) 
IF @a > 5 BEGIN
SET @str = '��������� ���������� �������� ������ 5' SELECT @str
END ELSE BEGIN
SET @str = '��������� ���������� �������� = ' + str(@a) SELECT @str
END


DECLARE @b INT 
DECLARE @string CHAR(80)
SET @b = (SELECT COUNT(*) FROM Tours) 
IF @b < 1 BEGIN
SET @string = '� ������� ��� �� ��������������� �� ���� ���' SELECT @string
END ELSE BEGIN
SET @string = '� ������� ����������������  ='+str(@b)+' �����' SELECT @string
END

--2 ������� � �������������� ����� WHILE;

DECLARE @� INT SET @� = 1 WHILE @� <100
BEGIN
PRINT @� -- ����� �� ����� �������� ���������� I
IF (@�>40) AND (@�<50)
BREAK --����� � ���������� 1-� ������� �� ������
ELSE
SET @� = @�+rand()*10 
CONTINUE
END
PRINT @�


DECLARE @number INT, @factorial INT
SET @factorial = 1;
SET @number = (SELECT COUNT(*) FROM Customers);

WHILE @number > 0
    BEGIN
        SET @factorial = @factorial * @number
        SET @number = @number - 1
    END;
PRINT @factorial
GO


--1 ������ ��� �������� ��������� �������;

	CREATE FUNCTION GetSumm
	 (@name varchar(50))
	RETURNS numeric(10,2)
	 BEGIN
	  DECLARE @PricePerPerson numeric(10,2)
	  SELECT @PricePerPerson = Price/PersonsQuantity
	  FROM TravelPackages
	  ---WHERE [PricePerPerson]=@name
	  RETURN @PricePerPerson
	 END
	 GO


--1 ������ ��� �������� �������, ������� ���������� ��������� ��������;


   CREATE FUNCTION [dbo].[test_tabl]  
   ( @id INT)
   RETURNS TABLE
   AS
   RETURN 
   ( SELECT * FROM HouseType WHERE HouseCategory = '����')
   GO
   SELECT * FROM dbo.test_tabl (1)
   GO


--2 ������� ��� �������� ��������� ��� ����������;

	CREATE PROCEDURE Count_Customers AS
	SELECT COUNT(*) FROM Customers
	GO
	EXEC Count_Customers
	GO

	CREATE PROCEDURE Count_Tours AS
	SELECT COUNT(*) FROM Tours
	GO
	EXEC Count_Tours
	GO



--2 ������� ��� �������� ��������� c ������� ����������;
	

	CREATE PROCEDURE Count_PricePerDay_Breakfast @Day_price INT 
	AS
	BEGIN
	SELECT count(FoodType) FROM Tours
	WHERE FoodType='��������' and PricePerDay>=@Day_price 
	END
	GO
	EXEC Count_PricePerDay_Breakfast 1000
	GO

	CREATE PROCEDURE House_level @House_level AS INT
	AS
	SELECT COUNT(*) FROM BoardingHouses WHERE BoardingHouseLevel>=@House_level
	GO
	EXEC House_level 2
	GO


--2 ������� ��� �������� ��������� c �������� ����������� � RETURN;

	CREATE PROCEDURE checkname @param INT
	AS
	IF (SELECT CName FROM Customers WHERE CName = @param) =
	'����'
	RETURN 1
	ELSE
	RETURN 2

	DECLARE @return_status INT
	EXEC @return_status = checkname 1
	SELECT 'Return Status' = @return_status
	GO


	CREATE PROCEDURE checknametour @param INT
	AS
	IF (SELECT * FROM Tours WHERE TourName = @param) =
	'�����'
	RETURN 1
	ELSE
	RETURN 2

	DECLARE @return_status INT
	EXEC @return_status = checkname 1
	SELECT 'Return Status' = @return_status
	GO

--2 ������� ��� �������� ��������� ���������� ������ � ������� ���� ������ UPDATE;

	CREATE PROC update_proc AS
    UPDATE Tours SET PricePerDay = PricePerDay-50
	GO

	CREATE PROC update_house_category AS
    UPDATE HouseType SET HouseCategory = '����'
	GO


--2 ������� ��� �������� ��������� ���������� ������ �� ������ ���� ������ SELECT;

	CREATE PROCEDURE CityCustomers
	AS
	BEGIN
		SELECT * FROM Customers 
		WHERE City ='�����'
	END
	GO

	CREATE PROCEDURE SPAvailable
	AS
	BEGIN
		SELECT * FROM BoardingHouses 
		WHERE SwimmingPoolAvailability ='��'
	END
	GO


	--����� 2

	-- task 1

	CREATE FUNCTION Calculator(@oprd_1 bigint,@oprd_2 bigint,@operator char(1)) 
	RETURNS bigint
	BEGIN

	DECLARE @result bigint
	SET @result = 
	CASE @operator
		WHEN '+' THEN @oprd_1 + @oprd_2
		WHEN '-' THEN @oprd_1 - @oprd_2
		WHEN '*' THEN @oprd_1 * @oprd_2
		WHEN '/' THEN @oprd_1 / @oprd_2
		ELSE 0
	END 
	Return @result
	END

	GO

	-- testing
	SELECT dbo.Calculator(10,5, '/') as result

	-- task 2

	GO

	CREATE FUNCTION DYNTAB (@tour_name char(50))  
	RETURNS TABLE  
	AS  
	RETURN (SELECT TourName FROM Tours WHERE TourName = @tour_name)
	
	GO

	-- testing

	SELECT * FROM DYNTAB ('�����')

	GO

	-- task 3

	CREATE FUNCTION parse_string (@input_string nvarchar(500))
	RETURNS @tabl TABLE 
		(Number int IDENTITY (1,1) NOT NULL,
		Substr nvarchar (30)) 
	AS
	BEGIN
		DECLARE @str_1 nvarchar(500), @pos int 
		WHILE CHARINDEX(' ', @input_string) > 0
		 BEGIN
			SET @pos  = CHARINDEX(' ', @input_string)  
			SET @str_1 = SUBSTRING(@input_string, 1, @pos-1)

			INSERT INTO @tabl VALUES(@str_1)

			SET @input_string = SUBSTRING(@input_string, @pos+1, LEN(@input_string) - @pos)
		 END
		INSERT INTO @tabl VALUES(@input_string)
		RETURN 
	END

	GO

	-- testing

	SELECT * FROM dbo.parse_string('����� ������ � ���� !')

	GO

	-- task 4






