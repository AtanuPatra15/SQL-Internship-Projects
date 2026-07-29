USE AirlineReservationSystem;

-- Query 1 – Display All Flights
SELECT * FROM Flight;

-- Query 2 – Display All Passengers Sorted by Last Name
SELECT *
FROM Passenger
ORDER BY LastName ASC;

-- Query 3 – Display Flights Departing from a Specific Airport1
SELECT F.*
FROM Flight F
JOIN Airport A
ON F.SourceAirportID = A.AirportID
WHERE A.AirportName = 'Kolkata';
SELECT * FROM Airport;
SELECT F.*
FROM Flight F
JOIN Airport A
ON F.SourceAirportID = A.AirportID
WHERE A.AirportName = 'Netaji Subhas Chandra Bose International Airport';

-- Query 4 – Show Passengers Older Than 30
SELECT *
FROM Passenger
WHERE TIMESTAMPDIFF(YEAR, DateOfBirth, CURDATE()) > 30;
SHOW COLUMNS FROM Passenger;

-- Query 5 – Display All Confirmed Bookings
SELECT *
FROM Booking
WHERE BookingStatus = 'Confirmed';
 
 -- Query 6 – Count Total Passengers
 SELECT COUNT(*) AS TotalPassengers
FROM Passenger;

-- Query 7 – Find Highest Ticket Price
SELECT MAX(TicketPrice) AS HighestTicketPrice
FROM Flight;

-- Query 8 – Find Lowest Ticket Price
SELECT MIN(TicketPrice) AS LowestTicketPrice
FROM Flight;

-- Query 9 – Display Flights Costing More Than ₹10,000
SELECT *
FROM Flight
WHERE TicketPrice > 10000;

-- Query 10 – Display Flights Sorted by Ticket Price
SELECT *
FROM Flight
ORDER BY TicketPrice DESC;

-- Query 11 – Display Passenger and Booking Details
SELECT P.PassengerID,
       P.FirstName,
       P.LastName,
       B.BookingID
FROM Passenger P
JOIN Booking B
ON P.PassengerID = B.PassengerID;

-- Query 12 – Display Booking with Flight Details
SELECT B.BookingID,
       F.FlightNumber,
       F.AirlineName
FROM Booking B
JOIN Flight F
ON B.FlightID = F.FlightID;

-- Query 13 – Display All Passengers with Their Bookings (LEFT JOIN)
SELECT P.FirstName,
       P.LastName,
       B.BookingID
FROM Passenger P
LEFT JOIN Booking B
ON P.PassengerID = B.PassengerID;

-- Query 14 – Count Bookings for Each Flight
SELECT FlightID,
       COUNT(*) AS TotalBookings
FROM Booking
GROUP BY FlightID;

-- Query 15 – Total Revenue by Flight
SELECT B.FlightID,
       SUM(P.Amount) AS TotalRevenue
FROM Booking B
JOIN Payment P
ON B.BookingID = P.BookingID
GROUP BY B.FlightID;

-- Query 16 – Average Ticket Price
SELECT AVG(TicketPrice) AS AverageTicketPrice
FROM Flight;

-- Query 17 – Flights Having More Than One Booking
SELECT FlightID,
       COUNT(*) AS TotalBookings
FROM Booking
GROUP BY FlightID
HAVING COUNT(*) > 1;

-- Query 18 – Display All Payments
SELECT *
FROM Payment;

-- Query 19 – Latest Booking
SELECT *
FROM Booking
ORDER BY BookingDate DESC
LIMIT 1;

-- Query 20 – Passenger with Highest Booking Amount
SELECT B.PassengerID,
       SUM(P.Amount) AS TotalSpent
FROM Booking B
JOIN Payment P
ON B.BookingID = P.BookingID
GROUP BY B.PassengerID
ORDER BY TotalSpent DESC
LIMIT 1;

-- Query 21 – Display Flights with Ticket Price Above Average
SELECT *
FROM Flight
WHERE TicketPrice > (
    SELECT AVG(TicketPrice)
    FROM Flight
);

-- Query 22 – Top 3 Most Expensive Flights
SELECT *
FROM Flight
ORDER BY TicketPrice DESC
LIMIT 3;

-- Query 23 – Count Flights by Airline
SELECT AirlineName,
       COUNT(*) AS TotalFlights
FROM Flight
GROUP BY AirlineName;

-- Query 24 – Display Earliest Departure Flight
SELECT *
FROM Flight
ORDER BY DepartureTime ASC
LIMIT 1;

-- Query 25 – Display Latest Arrival Flight
SELECT *
FROM Flight
ORDER BY ArrivalTime DESC
LIMIT 1;

-- Query 26 – Display Flights Between ₹5000 and ₹10000
SELECT *
FROM Flight
WHERE TicketPrice BETWEEN 5000 AND 10000;

-- Query 27 – Display Flights in Ascending Price Order
SELECT *
FROM Flight
ORDER BY TicketPrice ASC;

-- Query 28 – Display Distinct Airlines
SELECT DISTINCT AirlineName
FROM Flight;

-- Query 29 – Display Total Number of Flights
SELECT COUNT(*) AS TotalFlights
FROM Flight;

-- Query 30 – Flight Report
SELECT FlightID,
       FlightNumber,
       AirlineName,
       DepartureTime,
       ArrivalTime,
       TicketPrice
FROM Flight
ORDER BY TicketPrice DESC;