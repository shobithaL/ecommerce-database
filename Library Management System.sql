CREATE DATABASE Library;

USE library;

CREATE TABLE Books (
  BookID INT PRIMARY KEY,
  Title VARCHAR(255) NOT NULL,
  ISBN VARCHAR(20) NOT NULL,
  PublicationDate DATE,
  Publisher VARCHAR(100)
);

CREATE TABLE Authors (
  AuthorID INT PRIMARY KEY,
  Name VARCHAR(100) NOT NULL,
  Bio TEXT
);

CREATE TABLE Members (
  MemberID INT PRIMARY KEY,
  Name VARCHAR(100) NOT NULL,
  Email VARCHAR(100) NOT NULL,
  Phone VARCHAR(20)
);

CREATE TABLE Loans (
  LoanID INT PRIMARY KEY,
  BookID INT NOT NULL,
  MemberID INT NOT NULL,
  LoanDate DATE NOT NULL,
  DueDate DATE NOT NULL,
  ReturnDate DATE,
  FOREIGN KEY (BookID) REFERENCES Books(BookID),
  FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);

CREATE TABLE BookAuthors (
  BookID INT NOT NULL,
  AuthorID INT NOT NULL,
  FOREIGN KEY (BookID) REFERENCES Books(BookID),
  FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
);

-- Insert test data
INSERT INTO Books (BookID, Title, ISBN, PublicationDate, Publisher)
VALUES
  (1, 'Book 1', '1234567890', '2020-01-01', 'Publisher 1'),
  (2, 'Book 2', '2345678901', '2020-02-01', 'Publisher 2'),
  (3, 'Book 3', '3456789012', '2020-03-01', 'Publisher 3'),
  (4, 'Book 4', '4567890123', '2020-04-01', 'Publisher 4'),
  (5, 'Book 5', '5678901234', '2020-05-01', 'Publisher 5'),
  (6, 'Book 6', '6789012345', '2020-06-01', 'Publisher 6'),
  (7, 'Book 7', '7890123456', '2020-07-01', 'Publisher 7'),
  (8, 'Book 8', '8901234567', '2020-08-01', 'Publisher 8'),
  (9, 'Book 9', '9012345678', '2020-09-01', 'Publisher 9'),
  (10, 'Book 10', '0123456789', '2020-10-01', 'Publisher 10');

INSERT INTO Authors (AuthorID, Name, Bio)
VALUES
  (1, 'Author 1', 'Bio 1'),
  (2, 'Author 2', 'Bio 2'),
  (3, 'Author 3', 'Bio 3'),
  (4, 'Author 4', 'Bio 4'),
  (5, 'Author 5', 'Bio 5'),
  (6, 'Author 6', 'Bio 6'),
  (7, 'Author 7', 'Bio 7'),
  (8, 'Author 8', 'Bio 8'),
  (9, 'Author 9', 'Bio 9'),
  (10, 'Author 10', 'Bio 10');

INSERT INTO Members (MemberID, Name, Email, Phone)
VALUES
  (1, 'Emily Chen', 'emily.chen@example.com', '1234567890'),
  (2, 'Liam Brown', 'liam.brown@example.com', '2345678901'),
  (3, 'Ava Lee', 'ava.lee@example.com', '3456789012'),
  (4, 'Noah Kim', 'noah.kim@example.com', '4567890123'),
  (5, 'Sophia Patel', 'sophia.patel@example.com', '5678901234'),
  (6, 'Ethan Hall', 'ethan.hall@example.com', '6789012345'),
  (7, 'Mia Garcia', 'mia.garcia@example.com', '7890123456'),
  (8, 'Logan Martin', 'logan.martin@example.com', '8901234567'),
  (9, 'Isabella Harris', 'isabella.harris@example.com', '9012345678'),
  (10, 'William Davis', 'william.davis@example.com', '0123456789');

INSERT INTO BookAuthors (BookID, AuthorID)
VALUES
  (1, 1),
  (2, 2),
  (3, 3),
  (4, 4),
  (5, 5),
  (6, 6),
  (7, 7),
  (8, 8),
  (9, 9),
  (10, 10);

CREATE VIEW BorrowedBooks AS
SELECT b.Title, m.Name AS Borrower, l.LoanDate, l.DueDate
FROM Loans l
JOIN Books b ON l.BookID = b.BookID
JOIN Members m ON l.MemberID = m.MemberID
WHERE l.ReturnDate IS NULL;

CREATE VIEW OverdueBooks AS
SELECT b.Title, m.Name AS Borrower, l.DueDate
FROM Loans l
JOIN Books b ON l.BookID = b.BookID
JOIN Members m ON l.MemberID = m.MemberID
WHERE l.DueDate < CURDATE() AND l.ReturnDate IS NULL;

-- Report 1: Number of books borrowed by each member
SELECT m.Name, COUNT(l.LoanID) AS NumberOfBooksBorrowed
FROM Members m
JOIN Loans l ON m.MemberID = l.MemberID
GROUP BY m.Name;

-- Report 2: Number of books borrowed by each author
SELECT a.Name, COUNT(l.LoanID) AS NumberOfBooksBorrowed
FROM Authors a
JOIN BookAuthors ba ON a.AuthorID = ba.AuthorID
JOIN Books b ON ba.BookID = b.BookID
JOIN Loans l ON b.BookID = l.BookID
GROUP BY a.Name;

-- Report 3: Overdue books
SELECT b.Title, m.Name AS Borrower, l.DueDate
FROM Loans l
JOIN Books b ON l.BookID = b.BookID
JOIN Members m ON l.MemberID = m.MemberID
WHERE l.DueDate < CURDATE() AND l.ReturnDate IS NULL;