CREATE DATABASE airline;

USE airline;

CREATE TABLE Flights (
  FlightID INT PRIMARY KEY,
  FlightNumber VARCHAR(10) NOT NULL,
  DepartureAirport VARCHAR(3) NOT NULL,
  ArrivalAirport VARCHAR(3) NOT NULL,
  DepartureTime DATETIME NOT NULL,
  ArrivalTime DATETIME NOT NULL
);

CREATE TABLE Customers (
  CustomerID INT PRIMARY KEY,
  Name VARCHAR(100) NOT NULL,
  Email VARCHAR(100) NOT NULL
);

CREATE TABLE Bookings (
  BookingID INT PRIMARY KEY,
  FlightID INT NOT NULL,
  CustomerID INT NOT NULL,
  BookingDate DATE NOT NULL,
  SeatNumber VARCHAR(10) NOT NULL,
  FOREIGN KEY (FlightID) REFERENCES Flights(FlightID),
  FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Seats (
  SeatID INT PRIMARY KEY,
  FlightID INT NOT NULL,
  SeatNumber VARCHAR(10) NOT NULL,
  SeatType VARCHAR(10) NOT NULL,
  IsBooked BOOLEAN NOT NULL DEFAULT FALSE,
  FOREIGN KEY (FlightID) REFERENCES Flights(FlightID)
);


ALTER TABLE Flights
ADD CONSTRAINT CHK_FlightNumber CHECK (FlightNumber LIKE 'FL%');

ALTER TABLE Bookings
ADD CONSTRAINT CHK_BookingDate CHECK (BookingDate <= CURRENT_DATE);

ALTER TABLE Seats
ADD CONSTRAINT CHK_SeatType CHECK (SeatType IN ('Economy', 'Premium Economy', 'Business', 'First Class'));

INSERT INTO Flights (FlightID, FlightNumber, DepartureAirport, ArrivalAirport, DepartureTime, ArrivalTime)
VALUES
  (1, 'FL001', 'JFK', 'LAX', '2024-03-15 08:00:00', '2024-03-15 11:00:00'),
  (2, 'FL002', 'LAX', 'JFK', '2024-03-15 12:00:00', '2024-03-15 15:00:00'),
  (3, 'FL003', 'JFK', 'ORD', '2024-03-15 09:00:00', '2024-03-15 10:30:00'),
  (4, 'FL004', 'ORD', 'JFK', '2024-03-15 11:00:00', '2024-03-15 12:30:00'),
  (5, 'FL005', 'LAX', 'ORD', '2024-03-15 13:00:00', '2024-03-15 15:00:00'),
  (6, 'FL006', 'ORD', 'LAX', '2024-03-15 16:00:00', '2024-03-15 18:00:00'),
  (7, 'FL007', 'JFK', 'DFW', '2024-03-15 17:00:00', '2024-03-15 20:00:00'),
  (8, 'FL008', 'DFW', 'JFK', '2024-03-15 21:00:00', '2024-03-16 00:00:00'),
  (9, 'FL009', 'LAX', 'DFW', '2024-03-16 01:00:00', '2024-03-16 04:00:00'),
  (10, 'FL010', 'DFW', 'LAX', '2024-03-16 05:00:00', '2024-03-16 08:00:00');


INSERT INTO Customers (CustomerID, Name, Email)
VALUES
  (1, 'John Doe', 'john.doe@example.com'),
  (2, 'Jane Doe', 'jane.doe@example.com'),
  (3, 'Bob Smith', 'bob.smith@example.com'),
  (4, 'Alice Johnson', 'alice.johnson@example.com'),
  (5, 'Mike Brown', 'mike.brown@example.com'),
  (6, 'Emily Davis', 'emily.davis@example.com'),
  (7, 'Tom White', 'tom.white@example.com'),
  (8, 'Kate Martin', 'kate.martin@example.com'),
  (9, 'Sam Thompson', 'sam.thompson@example.com'),
  (10, 'Lily Garcia', 'lily.garcia@example.com');

INSERT INTO Bookings (BookingID, FlightID, CustomerID, BookingDate, SeatNumber)
VALUES
  (1, 1, 1, '2024-03-10', '1A'),
  (2, 1, 2, '2024-03-11', '1B'),
  (3, 2, 3, '2024-03-12', '2A'),
  (4, 3, 4, '2024-03-13', '3A'),
  (5, 4, 5, '2024-03-14', '4A'),
  (6, 5, 6, '2024-03-15', '5A'),
  (7, 6, 7, '2024-03-16', '6A'),
  (8, 7, 8, '2024-03-17', '7A'),
  (9, 8, 9, '2024-03-18', '8A'),
  (10, 9, 10, '2024-03-19', '9A');


INSERT INTO Seats (SeatID, FlightID, SeatNumber, SeatType, IsBooked)
VALUES
  (1, 1, '1A', 'Economy', TRUE),
  (2, 1, '1B', 'Economy', TRUE),
  (3, 1, '1C', 'Economy', FALSE),
  (4, 2, '2A', 'Economy', TRUE),
  (5, 2, '2B', 'Economy', FALSE),
  (6, 3, '3A', ' Economy', TRUE),
  (7, 3, '3B', 'Premium Economy', FALSE),
  (8, 4, '4A', 'Business', TRUE),
  (9, 4, '4B', 'Business', FALSE),
  (10, 5, '5A', 'First Class', TRUE);

-- Available seats for a flight
SELECT SeatNumber
FROM Seats
WHERE FlightID = 1 AND IsBooked = FALSE;

-- Search flights by departure and arrival airports
SELECT *
FROM Flights
WHERE DepartureAirport = 'JFK' AND ArrivalAirport = 'LAX';

DELIMITER $$

CREATE TRIGGER UpdateSeatBooking
AFTER INSERT ON Bookings
FOR EACH ROW
BEGIN
  UPDATE Seats
  SET IsBooked = TRUE
  WHERE FlightID = NEW.FlightID AND SeatNumber = NEW.SeatNumber;
END$$

CREATE TRIGGER CancelBooking
AFTER DELETE ON Bookings
FOR EACH ROW
BEGIN
  UPDATE Seats
  SET IsBooked = FALSE
  WHERE FlightID = OLD.FlightID AND SeatNumber = OLD.SeatNumber;
END$$

DELIMITER ;


SELECT 
  F.FlightNumber, 
  F.DepartureAirport, 
  F.ArrivalAirport, 
  B.SeatNumber, 
  C.Name AS CustomerName
FROM 
  Bookings B
JOIN 
  Flights F ON B.FlightID = F.FlightID
JOIN 
  Customers C ON B.CustomerID = C.CustomerID
ORDER BY 
  F.FlightNumber, 
  B.SeatNumber;