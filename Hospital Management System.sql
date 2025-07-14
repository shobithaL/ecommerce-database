CREATE DATABASE hospital;

USE hospital;

CREATE TABLE Patients (
  PatientID INT PRIMARY KEY,
  Name VARCHAR(100) NOT NULL,
  Email VARCHAR(100) NOT NULL,
  Phone VARCHAR(20) NOT NULL,
  Address VARCHAR(200) NOT NULL
);

CREATE TABLE Doctors (
  DoctorID INT PRIMARY KEY,
  Name VARCHAR(100) NOT NULL,
  Specialty VARCHAR(100) NOT NULL
);

CREATE TABLE Visits (
  VisitID INT PRIMARY KEY,
  PatientID INT NOT NULL,
  DoctorID INT NOT NULL,
  VisitDate DATE NOT NULL,
  Symptoms TEXT NOT NULL,
  Diagnosis TEXT NOT NULL,
  Treatment TEXT NOT NULL,
  FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
  FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

CREATE TABLE Bills (
  BillID INT PRIMARY KEY,
  VisitID INT NOT NULL,
  BillDate DATE NOT NULL,
  Amount DECIMAL(10, 2) NOT NULL,
  Status VARCHAR(50) NOT NULL,
  FOREIGN KEY (VisitID) REFERENCES Visits(VisitID)
);

INSERT INTO Patients (PatientID, Name, Email, Phone, Address)
VALUES
  (1, 'John Doe', 'john.doe@example.com', '123-456-7890', '123 Main St'),
  (2, 'Jane Doe', 'jane.doe@example.com', '987-654-3210', '456 Elm St'),
  (3, 'Bob Smith', 'bob.smith@example.com', '555-123-4567', '789 Oak St'),
  (4, 'Alice Johnson', 'alice.johnson@example.com', '901-234-5678', '321 Maple St'),
  (5, 'Mike Brown', 'mike.brown@example.com', '111-222-3333', '456 Pine St'),
  (6, 'Emily Davis', 'emily.davis@example.com', '444-555-6666', '789 Cedar St'),
  (7, 'Tom Harris', 'tom.harris@example.com', '777-888-9999', '123 Spruce St'),
  (8, 'Lily Martin', 'lily.martin@example.com', '333-444-5555', '456 Fir St'),
  (9, 'David Lee', 'david.lee@example.com', '666-777-8888', '789 Ash St'),
  (10, 'Sophia Kim', 'sophia.kim@example.com', '999-000-1111', '123 Beech St');

INSERT INTO Doctors (DoctorID, Name, Specialty)
VALUES
  (1, 'Dr. Smith', 'Cardiology'),
  (2, 'Dr. Johnson', 'Neurology'),
  (3, 'Dr. Williams', 'Oncology'),
  (4, 'Dr. Brown', 'Pediatrics'),
  (5, 'Dr. Davis', 'Dermatology'),
  (6, 'Dr. Miller', 'Gastroenterology'),
  (7, 'Dr. Wilson', 'Orthopedics'),
  (8, 'Dr. Anderson', 'Psychiatry'),
  (9, 'Dr. Thomas', 'Urology'),
  (10, 'Dr. Jackson', 'Nephrology');

INSERT INTO Visits (VisitID, PatientID, DoctorID, VisitDate, Symptoms, Diagnosis, Treatment)
VALUES
  (1, 1, 1, '2022-01-01', 'Chest pain', 'Heart attack', 'Medication'),
  (2, 2, 2, '2022-01-15', 'Headache', 'Migraine', 'Rest'),
  (3, 3, 3, '2022-02-01', 'Fatigue', 'Anemia', 'Iron supplements'),
  (4, 4, 4, '2022-02-15', 'Fever', 'Infection', 'Antibiotics'),
  (5, 5, 5, '2022-03-01', 'Rash', 'Allergic reaction', 'Antihistamines'),
  (6, 6, 6, '2022-03-15', 'Abdominal pain', 'Appendicitis', 'Surgery'),
  (7, 7, 7, '2022-04-01', 'Back pain', 'Muscle strain', 'Physical therapy'),
  (8, 8, 8, '2022-04-15', 'Anxiety', 'Anxiety disorder', 'Counseling'),
  (9, 9, 9, '2022-05-01', 'Urinary issues', 'UTI', 'Antibiotics'),
  (10, 10, 10, '2022-05-15', 'Kidney issues', 'Kidney disease', 'Medication');

INSERT INTO Bills (BillID, VisitID, BillDate, Amount, Status)
VALUES
  (1, 1, '2022-01-01', 100.00, 'Pending'),
  (2, 2, '2022-01-22', 50.00, 'Paid'),
  (3, 3, '2022-02-02', 200.00, 'Pending'),
  (4, 4, '2022-02-15', 150.00, 'Paid'),
  (5, 5, '2022-03-11', 75.00, 'Pending'),
  (6, 6, '2022-03-15', 500.00, 'Paid'),
  (7, 7, '2022-04-21', 100.00, 'Pending'),
  (8, 8, '2022-04-15', 200.00, 'Paid'),
  (9, 9, '2022-04-05', 200.00, 'Paid'),
  (10, 10, '2022-04-08', 200.00, 'Paid');


-- Get all appointments for a patient
SELECT v.VisitID, v.VisitDate, d.Name AS DoctorName
FROM Visits v
JOIN Doctors d ON v.DoctorID = d.DoctorID
WHERE v.PatientID = 1;

-- Get all payments for a patient
SELECT b.BillID, b.BillDate, b.Amount, b.Status
FROM Bills b
JOIN Visits v ON b.VisitID = v.VisitID
WHERE v.PatientID = 1;


DELIMITER $$

CREATE PROCEDURE CalculateBillAmount(IN visitID INT)
BEGIN
  DECLARE billAmount DECIMAL(10, 2);
  SET billAmount = (SELECT Amount FROM Bills WHERE VisitID = visitID);
  SELECT billAmount;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER UpdateBillStatus
AFTER UPDATE ON Bills
FOR EACH ROW
BEGIN
  IF NEW.Status = 'Paid' THEN
    UPDATE Visits
    SET DischargeDate = CURRENT_DATE
    WHERE VisitID = NEW.VisitID;
  END IF;
END$$

DELIMITER ;

ALTER TABLE Visits
ADD COLUMN DischargeDate DATE;

-- Get visit report for a patient
SELECT v.VisitID, v.VisitDate, d.Name AS DoctorName, v.Symptoms, v.Diagnosis, v.Treatment
FROM Visits v
JOIN Doctors d ON v.DoctorID = d.DoctorID
WHERE v.PatientID = 1;

-- Get visit report for a doctor
SELECT v.VisitID, v.VisitDate, p.Name AS PatientName, v.Symptoms, v.Diagnosis, v.Treatment
FROM Visits v
JOIN Patients p ON v.PatientID = p.PatientID
WHERE v.DoctorID = 1;