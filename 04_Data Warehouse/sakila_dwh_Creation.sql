USE master 
GO
CREATE DATABASE sakila_DWH
GO
USE sakila_DWH
GO
CREATE TABLE dimDate (
    DateKey int PRIMARY KEY,
    [Date] date,
    Year smallint,
    Month tinyint,
    MonthName varchar(20),
    DayOfMonth tinyint,
    DayOfWeek tinyint,
    DayOfWeekName varchar(20),
    DayOfYear smallint,
    WeekOfYear tinyint,
    IsWeekend bit
)

GO

DECLARE @StartDate date = '2005-01-01';
DECLARE @EndDate date = '2030-12-31';
DECLARE @CurrentDate date = @StartDate;

WHILE @CurrentDate <= @EndDate
BEGIN
    INSERT INTO dimDate (DateKey, [Date], Year, Month, MonthName, DayOfMonth, DayOfWeek, DayOfWeekName, DayOfYear, WeekOfYear, IsWeekend)
    VALUES (
        CONVERT(int, CONVERT(varchar(8), @CurrentDate, 112)),
        @CurrentDate,
        YEAR(@CurrentDate),
        MONTH(@CurrentDate),
        DATENAME(MONTH, @CurrentDate),
        DAY(@CurrentDate),
        DATEPART(WEEKDAY, @CurrentDate),
        DATENAME(WEEKDAY, @CurrentDate),
        DATEPART(DAYOFYEAR, @CurrentDate),
        DATEPART(WEEK, @CurrentDate),
        CASE WHEN DATEPART(WEEKDAY, @CurrentDate) IN (1, 7) THEN 1 ELSE 0 END
    );
    
    SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
END

GO
CREATE TABLE dimFilm (
	filmKey int IDENTITY(1, 1) PRIMARY KEY,
	filmBK int NOT NULL,
	filmTitle VARCHAR(64),
	filmDescription VARCHAR(255),
	filmReleaseYear CHAR(4),
	lnaguageBK INT NOT NULL,
	filmLanguage VARCHAR(16),
	rentalDuration TINYINT,
	rentalRate DECIMAL(4, 2),
	filmLength int,
	replacmentCost DECIMAL(5, 2),
	rating VARCHAR(35),
	hasDeletedScenes bit,
	hasBehindTheScenes bit,
	hasTrilers bit,
	hasCommentaries bit,
	isCategoryAction bit,
	isCategoryAnimation bit,
	isCategoryChildren bit,
	isCategoryClassics bit,
	isCategoryComedy bit,
	isCategoryDocumentary bit,
	isCategoryDrama bit,
	isCategoryFamily bit,
	isCategoryForeign bit,
	isCategoryGames bit,
	isCategoryHorror bit,
	isCategoryMusic bit,
	isCategoryNew bit,
	isCategorySciFi bit,
	isCategorySports bit,
	isCategoryTravel bit,
	startDate DATETIME,
	endDate DATETIME,
	isCurrent bit,
	sourceSystemCode TINYINT
)
GO 

CREATE TABLE dimCustomer (
	customerKey INT IDENTITY(1, 1) PRIMARY KEY,
	customerBK INT NOT NULL,
	customerFirstName VARCHAR(45),
	customerLastName VARCHAR(45),
	customerIsActive bit,
	createDate DATE,
	customerAddressBK INT,
	customerAddress VARCHAR(400),
	customerPhone VARCHAR(32),
	postalCode VARCHAR(32),
	customerCity VARCHAR(32),
	customerCountry VARCHAR(64),
	customerContinent VARCHAR(32),
	startDate DATETIME,
	endDate DATETIME,
	IsCurrent bit,
	sourceSystemCode TINYINT
)
GO
CREATE TABLE dimActor (
	actorKey INT IDENTITY(1, 1) PRIMARY KEY,
	actorBK INT NOT NULL,
	actorFirstName VARCHAR(50) NOT NULL,
	actorLastName VARCHAR(50) NOT NULL,
	lastUpdate DATETIME,
	sourceSystemCode TINYINT
	
)
GO
CREATE TABLE bridgeFilmActor (
	 filmKey INT,
	 actorKey INT,
	 filmBK INT,
	 actorBK INT,
	 lastUpdate DATETIME,
	 FOREIGN KEY (filmKey) REFERENCES dimFilm(filmKey),
	 FOREIGN KEY (actorKey) REFERENCES dimActor(actorKey)
)
GO
CREATE TABLE dimStaff (
	staffKey INT IDENTITY(1, 1) PRIMARY KEY,
	staffBK INT NOT NULL,
	staffFirstName VARCHAR(45),
	staffLastName VARCHAR(45),
	staffIsActive bit,
	staffEmail VARCHAR(100),
	staffUserName VARCHAR(400),
	staffAddressBK INT,
	staffStoreBK INT,
	staffPhone VARCHAR(32),
	postalCode VARCHAR(32),
	staffCity VARCHAR(32),
	staffCountry VARCHAR(64),
	staffContinent VARCHAR(32),
	startDate DATETIME,
	endDate DATETIME,
	isCurrent bit,
	sourceSystemCode TINYINT
)
GO
CREATE TABLE dimStore (
	storeKey INT IDENTITY(1, 1) PRIMARY KEY,
	storeBK INT NOT NULL, 
	storeAddressBK INT NOT NULL,
	storeAddress VARCHAR(100),
	storePhone VARCHAR(32),
	postalCode VARCHAR(32),
	storeCity VARCHAR(32),
	storeCountry VARCHAR(64),
	storeContinent VARCHAR(32),
	storeManagerBK INT,
	storeManagerFirstName VARCHAR(50),
	storemManagerLastName VARCHAR(50),
	startDate DATETIME,
	endDate DATETIME,
	IsCurrent bit,
	sourceSystemCode TINYINT 
)
GO 
CREATE TABLE factRental (
	factRentalKey INT IDENTITY(1, 1) PRIMARY KEY,
	rentalBK INT ,
	customerKey INT,
	customerBK INT,
	rentalSTAFFKey INT,
	rentalSTAFFBK INT,
	filmKey INT,
	filmBK INT,
	storeKey INT,
	storeBK INT,
	isReturned bit,
	isPaied bit,
	rentalDateKey INT,
	returnDateKey INT ,
	paymentStaffKey INT,
	paymentStaffBK INT,
	paymentDateKEY INT,
	paymentAmount FLOAT,
	FOREIGN KEY (customerKey) REFERENCES dimCustomer(customerKey),
	FOREIGN KEY (rentalStaffKey) REFERENCES dimStaff(staffKey),
	FOREIGN KEY (filmKey) REFERENCES dimFilm(filmKey),
	FOREIGN KEY (storeKey) REFERENCES dimstore(storeKey),
	FOREIGN KEY (paymentStaffKey) REFERENCES dimStaff(staffKey),
	FOREIGN KEY (rentalDateKey) REFERENCES dimDate(DateKey),
	FOREIGN KEY (returnDateKey) REFERENCES dimDate(DateKey),
	FOREIGN KEY (paymentDateKey) REFERENCES dimDate(DateKey)

)

