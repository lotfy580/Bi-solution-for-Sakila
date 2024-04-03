ALTER TABLE Country
ADD FOREIGN KEY (continentId) REFERENCES Continent(continentId)
GO
ALTER TABLE city
ADD FOREIGN KEY (countryID) REFERENCES Country(countryId)
GO
ALTER TABLE Address
ADD FOREIGN KEY (cityId) REFERENCES City(cityId)
GO
ALTER TABLE Staff
ADD FOREIGN KEY (addressId) REFERENCES Address(addressId)
GO
ALTER TABLE Store
ADD FOREIGN KEY (managerStaffId) REFERENCES Staff(staffId)
GO
ALTER TABLE Store
ADD FOREIGN KEY (addressId) REFERENCES Address(addressId)
GO
ALTER TABLE Staff
ADD FOREIGN KEY (storeId) REFERENCES Store(storeId)
GO
ALTER TABLE Customer
ADD FOREIGN KEY (storeId) REFERENCES Store(storeId)
GO
ALTER TABLE Film
ADD FOREIGN KEY (languageId) REFERENCES Language(languageId)
GO
ALTER TABLE FilmActor
ADD FOREIGN KEY (filmId) REFERENCES Film(filmId)
GO
ALTER TABLE FilmActor
ADD FOREIGN KEY (actorId) REFERENCES Actor(actorId)
GO
ALTER TABLE filmCategory
ADD FOREIGN KEY (categoryId) REFERENCES Category(categoryId)
GO
ALTER TABLE filmCategory
ADD FOREIGN KEY (filmId) REFERENCES Film(filmId)
GO
ALTER TABLE Inventory
ADD FOREIGN KEY (storeId) REFERENCES Store(storeId)
GO
ALTER TABLE Inventory
ADD FOREIGN KEY (filmId) REFERENCES Film(filmId)
GO
ALTER TABLE Rental
ADD FOREIGN KEY (inventoryId) REFERENCES inventory(inventoryId)
GO
ALTER TABLE Rental
ADD FOREIGN KEY (customerId) REFERENCES Customer(customerId)
GO
ALTER TABLE Rental
ADD FOREIGN KEY (staffId) REFERENCES Staff(staffId)
GO
ALTER TABLE Payment
ADD FOREIGN KEY (rentalId) REFERENCES Rental(rentalId)
GO
ALTER TABLE Payment
ADD FOREIGN KEY (customerId) REFERENCES Customer(customerId)
GO
ALTER TABLE Payment
ADD FOREIGN KEY (staffId) REFERENCES Staff(staffId)
GO