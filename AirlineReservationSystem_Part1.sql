CREATE DATABASE AirlineReservationSystem;
USE AirlineReservationSystem;

-- Airport 
CREATE TABLE Airport (
    AirportID INT AUTO_INCREMENT PRIMARY KEY,
    AirportCode CHAR(3) NOT NULL UNIQUE,
    AirportName VARCHAR(100) NOT NULL,
    City VARCHAR(50) NOT NULL,
    State VARCHAR(50),
    Country VARCHAR(50) NOT NULL
);

-- Aircraft Table
CREATE TABLE Aircraft (
    AircraftID INT AUTO_INCREMENT PRIMARY KEY,
    AircraftModel VARCHAR(50) NOT NULL,
    Manufacturer VARCHAR(50) NOT NULL,
    TotalSeats INT NOT NULL CHECK (TotalSeats > 0)
);

-- Flight Table
CREATE TABLE Flight (
    FlightID INT AUTO_INCREMENT PRIMARY KEY,
    FlightNumber VARCHAR(10) NOT NULL UNIQUE,
    AirlineName VARCHAR(50) NOT NULL,
    SourceAirportID INT NOT NULL,
    DestinationAirportID INT NOT NULL,
    AircraftID INT NOT NULL,
    DepartureTime DATETIME NOT NULL,
    ArrivalTime DATETIME NOT NULL,
    TicketPrice DECIMAL(10,2) NOT NULL CHECK (TicketPrice > 0),

    FOREIGN KEY (SourceAirportID)
        REFERENCES Airport(AirportID),

    FOREIGN KEY (DestinationAirportID)
        REFERENCES Airport(AirportID),

    FOREIGN KEY (AircraftID)
        REFERENCES Aircraft(AircraftID)
);

-- Passenger Table
CREATE TABLE Passenger (
    PassengerID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Gender ENUM('Male','Female','Other'),
    DateOfBirth DATE,
    Phone VARCHAR(15) UNIQUE,
    Email VARCHAR(100) UNIQUE,
    PassportNumber VARCHAR(20) UNIQUE,
    Nationality VARCHAR(50)
);

-- Seat Table
CREATE TABLE Seat (
    SeatID INT AUTO_INCREMENT PRIMARY KEY,
    FlightID INT NOT NULL,
    SeatNumber VARCHAR(5) NOT NULL,
    SeatClass ENUM('Economy','Business','First') NOT NULL,
    SeatStatus ENUM('Available','Booked') DEFAULT 'Available',

    FOREIGN KEY (FlightID)
        REFERENCES Flight(FlightID),

    UNIQUE (FlightID, SeatNumber)
);

-- Booking Table
CREATE TABLE Booking (
    BookingID INT AUTO_INCREMENT PRIMARY KEY,
    PassengerID INT NOT NULL,
    FlightID INT NOT NULL,
    SeatID INT NOT NULL,
    BookingDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    BookingStatus ENUM('Confirmed','Cancelled','Pending')
        DEFAULT 'Pending',

    FOREIGN KEY (PassengerID)
        REFERENCES Passenger(PassengerID),

    FOREIGN KEY (FlightID)
        REFERENCES Flight(FlightID),

    FOREIGN KEY (SeatID)
        REFERENCES Seat(SeatID)
);

-- Ticket Table
CREATE TABLE Ticket (
    TicketID INT AUTO_INCREMENT PRIMARY KEY,
    BookingID INT NOT NULL UNIQUE,
    TicketNumber VARCHAR(20) NOT NULL UNIQUE,
    IssueDate DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (BookingID)
        REFERENCES Booking(BookingID)
);

-- Payment Table
CREATE TABLE Payment (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    BookingID INT NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    PaymentMethod ENUM('UPI','Card','Net Banking','Cash'),
    PaymentStatus ENUM('Success','Failed','Pending')
        DEFAULT 'Pending',
    PaymentDate DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (BookingID)
        REFERENCES Booking(BookingID)
);

-- FlightSchedule Table
CREATE TABLE FlightSchedule (
    ScheduleID INT AUTO_INCREMENT PRIMARY KEY,
    FlightID INT NOT NULL,
    FlightDate DATE NOT NULL,
    FlightStatus ENUM('Scheduled','Delayed','Cancelled','Completed')
        DEFAULT 'Scheduled',

    FOREIGN KEY (FlightID)
        REFERENCES Flight(FlightID)
);

-- Cancellation Table
CREATE TABLE Cancellation (
    CancellationID INT AUTO_INCREMENT PRIMARY KEY,
    BookingID INT NOT NULL,
    CancellationDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    RefundAmount DECIMAL(10,2),
    Reason VARCHAR(255),

    FOREIGN KEY (BookingID)
        REFERENCES Booking(BookingID)
);

-- 1. Airport
INSERT INTO Airport (AirportCode, AirportName, City, State, Country)
VALUES
('CCU', 'Netaji Subhas Chandra Bose International Airport', 'Kolkata', 'West Bengal', 'India'),
('DEL', 'Indira Gandhi International Airport', 'New Delhi', 'Delhi', 'India'),
('BOM', 'Chhatrapati Shivaji Maharaj International Airport', 'Mumbai', 'Maharashtra', 'India'),
('BLR', 'Kempegowda International Airport', 'Bengaluru', 'Karnataka', 'India'),
('HYD', 'Rajiv Gandhi International Airport', 'Hyderabad', 'Telangana', 'India');

-- 2. Aircraft
INSERT INTO Aircraft (AircraftModel, Manufacturer, TotalSeats)
VALUES
('A320', 'Airbus', 180),
('A321', 'Airbus', 220),
('B737-800', 'Boeing', 189),
('B787 Dreamliner', 'Boeing', 296),
('ATR 72', 'ATR', 70);

-- 3. Flight
INSERT INTO Flight
(FlightNumber, AirlineName, SourceAirportID, DestinationAirportID, AircraftID,
DepartureTime, ArrivalTime, TicketPrice)
VALUES
('AI101', 'Air India', 1, 2, 1,
'2026-07-20 08:00:00', '2026-07-20 10:15:00', 6500),

('6E205', 'IndiGo', 2, 3, 2,
'2026-07-21 09:30:00', '2026-07-21 11:45:00', 7200),

('SG310', 'SpiceJet', 3, 4, 3,
'2026-07-22 07:15:00', '2026-07-22 09:45:00', 5800),

('UK450', 'Vistara', 4, 5, 4,
'2026-07-23 12:00:00', '2026-07-23 14:30:00', 8900),

('AI550', 'Air India', 5, 1, 5,
'2026-07-24 15:00:00', '2026-07-24 17:30:00', 6100);

-- 4. Passenger
INSERT INTO Passenger
(FirstName, LastName, Gender, DateOfBirth, Phone, Email, PassportNumber, Nationality)
VALUES
('Rahul', 'Sharma', 'Male', '1998-03-15',
'9876543210', 'rahul@gmail.com', 'P1234567', 'Indian'),

('Priya', 'Das', 'Female', '2000-06-22',
'9876543211', 'priya@gmail.com', 'P1234568', 'Indian'),

('Amit', 'Verma', 'Male', '1997-12-10',
'9876543212', 'amit@gmail.com', 'P1234569', 'Indian'),

('Sneha', 'Roy', 'Female', '1999-09-05',
'9876543213', 'sneha@gmail.com', 'P1234570', 'Indian'),

('Arjun', 'Patel', 'Male', '1996-01-18',
'9876543214', 'arjun@gmail.com', 'P1234571', 'Indian');

-- 5. Seat
INSERT INTO Seat
(FlightID, SeatNumber, SeatClass, SeatStatus)
VALUES
(1, '1A', 'Business', 'Available'),
(1, '2A', 'Economy', 'Available'),
(2, '1B', 'Business', 'Available'),
(3, '3C', 'Economy', 'Available'),
(4, '2D', 'First', 'Available'),
(5, '5A', 'Economy', 'Available');

-- 6. Booking
INSERT INTO Booking (PassengerID, FlightID, SeatID, BookingStatus)
VALUES
(1, 1, 1, 'Confirmed'),
(2, 2, 3, 'Confirmed'),
(3, 3, 4, 'Pending'),
(4, 4, 5, 'Confirmed'),
(5, 5, 6, 'Cancelled');

-- 7. Ticket
INSERT INTO Ticket (BookingID, TicketNumber)
VALUES
(1, 'TKT100001'),
(2, 'TKT100002'),
(3, 'TKT100003'),
(4, 'TKT100004'),
(5, 'TKT100005');

-- 8. Payment
INSERT INTO Payment (BookingID, Amount, PaymentMethod, PaymentStatus)
VALUES
(1, 6500.00, 'UPI', 'Success'),
(2, 7200.00, 'Card', 'Success'),
(3, 5800.00, 'Net Banking', 'Pending'),
(4, 8900.00, 'Card', 'Success'),
(5, 6100.00, 'UPI', 'Failed');

-- 9. FlightSchedule
INSERT INTO FlightSchedule (FlightID, FlightDate, FlightStatus)
VALUES
(1, '2026-07-20', 'Scheduled'),
(2, '2026-07-21', 'Scheduled'),
(3, '2026-07-22', 'Delayed'),
(4, '2026-07-23', 'Scheduled'),
(5, '2026-07-24', 'Cancelled');

-- 10. Cancellation
INSERT INTO Cancellation (BookingID, RefundAmount, Reason)
VALUES
(5, 5500.00, 'Passenger cancelled due to personal reasons');

SELECT * FROM Airport;
SELECT * FROM Aircraft;
SELECT * FROM Flight;
SELECT * FROM Passenger;
SELECT * FROM Seat;
SELECT * FROM Booking;

SELECT * FROM Ticket;

SELECT * FROM Payment;

SELECT * FROM FlightSchedule;

SELECT * FROM Cancellation;