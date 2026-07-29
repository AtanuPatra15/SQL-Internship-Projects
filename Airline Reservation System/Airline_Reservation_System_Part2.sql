USE AirlineReservationSystem;

-- View 1: Passenger Booking Details
CREATE VIEW PassengerBookingDetails AS
SELECT
    b.BookingID,
    CONCAT(p.FirstName, ' ', p.LastName) AS PassengerName,
    f.FlightNumber,
    s.SeatNumber,
    b.BookingDate,
    b.BookingStatus
FROM Booking b
JOIN Passenger p
    ON b.PassengerID = p.PassengerID
JOIN Flight f
    ON b.FlightID = f.FlightID
JOIN Seat s
    ON b.SeatID = s.SeatID;
    SELECT * FROM PassengerBookingDetails;
    
    -- View 2: Flight Details
    CREATE VIEW FlightDetails AS
SELECT
    f.FlightID,
    f.FlightNumber,
    f.AirlineName,
    a1.AirportName AS SourceAirport,
    a2.AirportName AS DestinationAirport,
    f.DepartureTime,
    f.ArrivalTime,
    f.TicketPrice
FROM Flight f
JOIN Airport a1
    ON f.SourceAirportID = a1.AirportID
JOIN Airport a2
    ON f.DestinationAirportID = a2.AirportID;
    SELECT * FROM FlightDetails;
    
    -- View 3: Payment Details
    CREATE VIEW PaymentDetails AS
SELECT
    p.PaymentID,
    b.BookingID,
    CONCAT(ps.FirstName, ' ', ps.LastName) AS PassengerName,
    p.Amount,
    p.PaymentMethod,
    p.PaymentStatus,
    p.PaymentDate
FROM Payment p
JOIN Booking b
    ON p.BookingID = b.BookingID
JOIN Passenger ps
    ON b.PassengerID = ps.PassengerID;
    SELECT * FROM PaymentDetails;
    
    -- View 4: Flight Schedule Details
    CREATE VIEW FlightScheduleDetails AS
SELECT
    fs.ScheduleID,
    f.FlightNumber,
    f.AirlineName,
    fs.FlightDate,
    fs.FlightStatus
FROM FlightSchedule fs
JOIN Flight f
    ON fs.FlightID = f.FlightID;
    SELECT * FROM FlightScheduleDetails;
    
    -- View 5: Cancellation Details
    CREATE VIEW CancellationDetails AS
SELECT
    c.CancellationID,
    b.BookingID,
    CONCAT(p.FirstName, ' ', p.LastName) AS PassengerName,
    c.CancellationDate,
    c.RefundAmount,
    c.Reason
FROM Cancellation c
JOIN Booking b
    ON c.BookingID = b.BookingID
JOIN Passenger p
    ON b.PassengerID = p.PassengerID;
    SELECT * FROM CancellationDetails;
    
    -- Procedure 1: Search Flight by Flight Number
    DELIMITER //

CREATE PROCEDURE SearchFlight(IN flight_no VARCHAR(10))
BEGIN
    SELECT *
    FROM Flight
    WHERE FlightNumber = flight_no;
END //

DELIMITER ;
CALL SearchFlight('AI101');

-- Procedure 2: Get Passenger Details
 DELIMITER //

CREATE PROCEDURE GetPassengerDetails(IN passenger_id INT)
BEGIN
    SELECT *
    FROM Passenger
    WHERE PassengerID = passenger_id;
END //

DELIMITER ;
CALL GetPassengerDetails(1);

-- Procedure 3: Get Booking Details
DELIMITER //

CREATE PROCEDURE GetBookingDetails(IN booking_id INT)
BEGIN
    SELECT
        b.BookingID,
        CONCAT(p.FirstName,' ',p.LastName) AS PassengerName,
        f.FlightNumber,
        s.SeatNumber,
        b.BookingStatus
    FROM Booking b
    JOIN Passenger p ON b.PassengerID = p.PassengerID
    JOIN Flight f ON b.FlightID = f.FlightID
    JOIN Seat s ON b.SeatID = s.SeatID
    WHERE b.BookingID = booking_id;
END //

DELIMITER ;
CALL GetBookingDetails(1);

-- Procedure 4: Show Flights by Airline
DELIMITER //

CREATE PROCEDURE FlightsByAirline(IN airline VARCHAR(50))
BEGIN
    SELECT *
    FROM Flight
    WHERE AirlineName = airline;
END //

DELIMITER ;
CALL FlightsByAirline('Air India');

-- Procedure 5: Show Successful Payments
DELIMITER //

CREATE PROCEDURE SuccessfulPayments()
BEGIN
    SELECT *
    FROM Payment
    WHERE PaymentStatus = 'Success';
END //

DELIMITER ;
CALL SuccessfulPayments();

-- Function 1: Calculate Passenger Age
DELIMITER //

CREATE FUNCTION GetPassengerAge(dob DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN TIMESTAMPDIFF(YEAR, dob, CURDATE());
END //

DELIMITER ;

SELECT
    PassengerID,
    FirstName,
    LastName,
    GetPassengerAge(DateOfBirth) AS Age
FROM Passenger;

-- Function 2: Get Ticket Price
DELIMITER //

CREATE FUNCTION GetTicketPrice(flight_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE price DECIMAL(10,2);

    SELECT TicketPrice
    INTO price
    FROM Flight
    WHERE FlightID = flight_id;

    RETURN price;
END //

DELIMITER ;

SELECT GetTicketPrice(1) AS TicketPrice;

-- Function 3: Count Bookings for a Flight
DELIMITER //

CREATE FUNCTION TotalBookings(flight_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;

    SELECT COUNT(*)
    INTO total
    FROM Booking
    WHERE FlightID = flight_id;

    RETURN total;
END //

DELIMITER ;

SELECT TotalBookings(1) AS TotalBookings;

-- Function 4: Count Available Seats 
DELIMITER //

CREATE FUNCTION AvailableSeats(flight_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE seats INT;

    SELECT COUNT(*)
    INTO seats
    FROM Seat
    WHERE FlightID = flight_id
      AND SeatStatus = 'Available';

    RETURN seats;
END //

DELIMITER ;

SELECT AvailableSeats(1) AS AvailableSeats;

-- Function 5: Count Successful Payments
DELIMITER //

CREATE FUNCTION SuccessfulPaymentCount()
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;

    SELECT COUNT(*)
    INTO total
    FROM Payment
    WHERE PaymentStatus = 'Success';

    RETURN total;
END //

DELIMITER ;

SELECT SuccessfulPaymentCount() AS SuccessfulPayments;

-- Trigger 1: Automatically Book the Seat
DELIMITER //

CREATE TRIGGER trg_BookSeat
AFTER INSERT ON Booking
FOR EACH ROW
BEGIN
    UPDATE Seat
    SET SeatStatus = 'Booked'
    WHERE SeatID = NEW.SeatID;
END //

DELIMITER ; 
INSERT INTO Booking (PassengerID, FlightID, SeatID, BookingStatus)
VALUES (1, 1, 2, 'Confirmed');
SELECT SeatID, SeatNumber, SeatStatus
FROM Seat
WHERE SeatID = 2;

-- Trigger 2: Automatically Free the Seat When a Booking is Cancelled
DELIMITER //

CREATE TRIGGER trg_FreeSeat
AFTER UPDATE ON Booking
FOR EACH ROW
BEGIN
    IF NEW.BookingStatus = 'Cancelled' THEN
        UPDATE Seat
        SET SeatStatus = 'Available'
        WHERE SeatID = NEW.SeatID;
    END IF;
END //

DELIMITER ;
UPDATE Booking
SET BookingStatus = 'Cancelled'
WHERE BookingID = 1;
SELECT SeatID, SeatNumber, SeatStatus
FROM Seat
WHERE SeatID = 1;

-- Trigger 3: Automatically Generate a Ticket
DELIMITER //

CREATE TRIGGER trg_GenerateTicket
AFTER INSERT ON Booking
FOR EACH ROW
BEGIN
    IF NEW.BookingStatus = 'Confirmed' THEN
        INSERT INTO Ticket (BookingID, TicketNumber)
        VALUES (
            NEW.BookingID,
            CONCAT('TKT', LPAD(NEW.BookingID, 6, '0'))
        );
    END IF;
END //

DELIMITER ;
INSERT INTO Booking (PassengerID, FlightID, SeatID, BookingStatus)
VALUES (2, 1, 2, 'Confirmed');
SELECT * FROM Ticket
ORDER BY TicketID DESC;

-- Trigger 4: Automatically Log Successful Payments
CREATE TABLE PaymentLog (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    PaymentID INT,
    BookingID INT,
    LogMessage VARCHAR(255),
    LogDate DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //

CREATE TRIGGER trg_PaymentLog
AFTER INSERT ON Payment
FOR EACH ROW
BEGIN
    IF NEW.PaymentStatus = 'Success' THEN
        INSERT INTO PaymentLog
        (PaymentID, BookingID, LogMessage)
        VALUES
        (
            NEW.PaymentID,
            NEW.BookingID,
            'Payment completed successfully'
        );
    END IF;
END //

DELIMITER ;
INSERT INTO Payment
(BookingID, Amount, PaymentMethod, PaymentStatus)
VALUES
(3, 5800.00, 'UPI', 'Success');
SELECT * FROM PaymentLog;


