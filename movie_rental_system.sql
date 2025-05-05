-- Create a database for the movie rental system
CREATE DATABASE MovieRental;

-- Use the created database
USE MovieRental;

-- Create a table for storing movie information
CREATE TABLE Movies (
    MovieID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(255) NOT NULL,
    Genre VARCHAR(100),
    Director VARCHAR(255),
    ReleaseYear INT,
    RentalPrice DECIMAL(10, 2),
    AvailableCopies INT
);

-- Create a table for storing customer information
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    PhoneNumber VARCHAR(15),
    DateOfMembership DATE
);

-- Create a table for storing rental transaction details
CREATE TABLE Rentals (
    RentalID INT PRIMARY KEY AUTO_INCREMENT,
    MovieID INT,
    CustomerID INT,
    RentalDate DATE,
    ReturnDate DATE,
    RentalStatus VARCHAR(20), -- 'Rented' or 'Returned'
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Insert sample data into the Movies table
INSERT INTO Movies (Title, Genre, Director, ReleaseYear, RentalPrice, AvailableCopies)
VALUES
    ('The Shawshank Redemption', 'Drama', 'Frank Darabont', 1994, 2.99, 5),
    ('The Dark Knight', 'Action', 'Christopher Nolan', 2008, 3.99, 3),
    ('Forrest Gump', 'Drama', 'Robert Zemeckis', 1994, 2.49, 4),
    ('Inception', 'Sci-Fi', 'Christopher Nolan', 2010, 4.49, 2);

-- Insert sample data into the Customers table
INSERT INTO Customers (FirstName, LastName, Email, PhoneNumber, DateOfMembership)
VALUES
    ('Alice', 'Johnson', 'alice@email.com', '1234567890', '2023-01-01'),
    ('Bob', 'Smith', 'bob@email.com', '0987654321', '2023-02-15');

-- Rent a movie to a customer (Rental transaction)
INSERT INTO Rentals (MovieID, CustomerID, RentalDate, RentalStatus)
VALUES
    (1, 1, '2025-05-01', 'Rented'),  -- Movie ID 1 rented to Customer ID 1
    (2, 2, '2025-05-02', 'Rented');  -- Movie ID 2 rented to Customer ID 2

-- Update AvailableCopies after movie is rented
UPDATE Movies
SET AvailableCopies = AvailableCopies - 1
WHERE MovieID = 1;

UPDATE Movies
SET AvailableCopies = AvailableCopies - 1
WHERE MovieID = 2;

-- Example: Query to check all movies and their availability
SELECT Title, Genre, AvailableCopies
FROM Movies;

-- Example: Query to check all rental transactions and their details
SELECT r.RentalID, m.Title, c.FirstName, c.LastName, r.RentalDate, r.ReturnDate, r.RentalStatus
FROM Rentals r
JOIN Movies m ON r.MovieID = m.MovieID
JOIN Customers c ON r.CustomerID = c.CustomerID;

-- Example: Return a movie (update AvailableCopies and set ReturnDate)
UPDATE Movies
SET AvailableCopies = AvailableCopies + 1
WHERE MovieID = 1;

UPDATE Rentals
SET ReturnDate = '2025-05-10', RentalStatus = 'Returned'
WHERE RentalID = 1;
