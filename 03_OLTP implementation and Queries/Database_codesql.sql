CREATE DATABASE sakila
GO;
USE sakila;

CREATE TABLE Actor (
	actorId INT PRIMARY KEY,
	firstName VARCHAR(50) NOT NULL,
	lastName VARCHAR(50) NOT NULL,
	lastUpdate datetime
	);

CREATE TABLE Continent (
	continentId INT PRIMARY KEY,
	continentName VARCHAR(50) NOT NULL
	);

CREATE TABLE Country (
	countryId INT PRIMARY KEY,
	country VARCHAR(255) NOT NULL,
	continentId INT NULL,
	lastUpdate datetime NULL,
	FOREIGN KEY (continentId) REFERENCES Continent(continentId) 
	);

CREATE TABLE City (
	cityId INT PRIMARY KEY,
	cityName VARCHAR(255) NOT NULL,
	countryId INT NULL,
	lastUpdate datetime NULL,
	FOREIGN KEY (countryID) REFERENCES Country(countryId)
	);

CREATE TABLE Address (
	addressId INT PRIMARY KEY,
	address VARCHAR(400) NOT NULL,
	phone varchar(255) NOT NULL,
	postalCode varchar(255) NULL,
	cityId INT NULL,
	lastUpdate datetime
	FOREIGN KEY (cityId) REFERENCES City(cityId)
	);

CREATE TABLE Staff (
	staffId INT PRIMARY KEY,
	firstName VARCHAR(100) NOT NULL,
	lastName VARCHAR(100) NOT NULL,
	addressId INT,
	storeId INT,
	email varchar(255) NULL,
	active BIT DEFAULT 0,
	username VARCHAR(255) NULL,
	password VARCHAR(800) NULL,
	lastUpdate datetime,
	FOREIGN KEY (addressId) REFERENCES Address(addressId)
);
CREATE TABLE Store (
	storeId INT PRIMARY KEY,
	managerStaffId INT NOT NULL,
	addressId INT NOT NULL,
	lastUpdate datetime,
	FOREIGN KEY (managerStaffId) REFERENCES Staff(staffId),
	FOREIGN KEY (addressId) REFERENCES Address(addressId)
	);

ALTER TABLE Staff
ADD FOREIGN KEY (storeId) REFERENCES Store(storeId);

CREATE TABLE Customer (
	customerId INT PRIMARY KEY,
	firstName VARCHAR(50) NOT NULL,
	lastName VARCHAR(50) NOT NULL,
	active BIT DEFAULT 0,
	storeId INT NOT NULL,
	addressId INT NULL,
	createDate datetime,
	updateDate date
	FOREIGN KEY (storeId) REFERENCES Store(storeId),
	FOREIGN KEY (addressId) REFERENCES address(addressId)
);
CREATE TABLE Language (
	languageId INT PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	lastUpdate DATE
);
CREATE TABLE Film (
	filmId INT PRIMARY KEY,
	title VARCHAR(400) NOT NULL,
	description VARCHAR(2000) NULL,
	releaseYear varchar(50) NOT NULL,
	languageId INT NOT NULL,
	rentalDuration INT NOT NULL,
	length INT NOT NULL,
	replacementCost FLOAT NOT NULL,
	rating varchar(50) NULL,
	rentalRate float,
	specialFeatures varchar(255),
	lastUpdate datetime 
	FOREIGN KEY (languageId) REFERENCES Language(languageId)
);
CREATE TABLE filmActor (
	actorId INT,
	filmId INT,
	lastUpdate datetime,
	PRIMARY KEY (actorId, filmId),
	FOREIGN KEY (actorId) REFERENCES Actor(actorId),
	FOREIGN KEY (filmId) REFERENCES Film(filmId)
);
CREATE TABLE Category (
	categoryId INT PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	lastUpdate datetime
);
CREATE TABLE filmCategory (
	categoryId INT,
	filmId INT,
	lastUpdate datetime
	PRIMARY KEY (categoryId, filmId),
	FOREIGN KEY (categoryId) REFERENCES Category(categoryId),
	FOREIGN KEY (filmId) REFERENCES Film(filmId)
);
CREATE TABLE Inventory (
	inventoryId INT PRIMARY KEY,
	filmId INT NOT NULL,
	storeId INT NOT NULL,
	lastUpdate datetime,
	FOREIGN KEY (storeId) REFERENCES Store(storeId),
	FOREIGN KEY (filmId) REFERENCES Film(filmId)
);
CREATE TABLE Rental (
	rentalId int primary key,
	rentalDate datetime not null,
	inventoryId int not null,
	customerId int not null,
	returnDate datetime,
	staffId int not null,
	lastUpdate datetime,
	FOREIGN KEY (inventoryId) REFERENCES inventory(inventoryId),
	FOREIGN KEY (customerId) REFERENCES Customer(customerId),
	FOREIGN KEY (staffId) REFERENCES Staff(staffId)

);
CREATE TABLE Payment (
	paymentId int primary key,
	rentalId int not null,
	customerId int not null,
	staffId int not null,
	amount float not null,
	paymentDate datetime not null,
	lastUpdate datetime,
	FOREIGN KEY (rentalId) REFERENCES Rental(rentalId),
	FOREIGN KEY (customerId) REFERENCES Customer(customerId),
	FOREIGN KEY (staffId) REFERENCES Staff(staffId)

);
