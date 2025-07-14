CREATE DATABASE employee_management;

USE employee_management;

CREATE TABLE Departments (
  DepartmentID INT PRIMARY KEY,
  DepartmentName VARCHAR(255) NOT NULL
);

CREATE TABLE Roles (
  RoleID INT PRIMARY KEY,
  RoleName VARCHAR(255) NOT NULL
);

CREATE TABLE Employees (
  EmployeeID INT PRIMARY KEY,
  Name VARCHAR(255) NOT NULL,
  Email VARCHAR(255) UNIQUE NOT NULL,
  DepartmentID INT,
  RoleID INT,
  FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID),
  FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
);

CREATE TABLE Attendance (
  AttendanceID INT PRIMARY KEY,
  EmployeeID INT,
  AttendanceDate DATE NOT NULL,
  ClockIn TIME NOT NULL,
  ClockOut TIME,
  Status VARCHAR(255) NOT NULL DEFAULT 'Present',
  FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);


INSERT INTO Departments (DepartmentID, DepartmentName)
VALUES
  (1, 'HR'),
  (2, 'Marketing'),
  (3, 'Sales'),
  (4, 'IT'),
  (5, 'Finance'),
  (6, 'Oparations');



INSERT INTO Roles (RoleID, RoleName)
VALUES
  (1, 'Manager'),
  (2, 'Executive'),
  (3, 'Developer'),
  (4, 'HR Specialist'),
  (5, 'Finacial Analyst'),
  (6, 'Oparations Manager');
  
  
  

INSERT INTO Employees (EmployeeID, Name, Email, DepartmentID, RoleID)
VALUES 
  (1, 'John Doe', 'john.doe@example.com', 1, 1),
  (2, 'Jane Doe', 'jane.doe@example.com', 2, 2),
  (3, 'Bob Smith', 'bob.smith@example.com', 3, 3),
  (4, 'Alice Johnson', 'alice.johnson@example.com', 4, 4),
  (5, 'Mike Brown', 'mike.brown@example.com', 5, 5),
  (6, 'Emily Davis', 'emily.davis@example.com', 6, 6),
  (7, 'Tom White', 'tom.white@example.com', 1, 1),
  (8, 'Linda Black', 'linda.black@example.com', 2, 2),
  (9, 'Kevin Lee', 'kevin.lee@example.com', 3, 3),
  (10, 'Sarah Taylor', 'sarah.taylor@example.com', 4, 4),
  (11, 'David Hall', 'david.hall@example.com', 5, 5),
  (12, 'Jessica Martin', 'jessica.martin@example.com', 6, 6),
  (13, 'Peter Thompson', 'peter.thompson@example.com', 1, 1),
  (14, 'Amy Garcia', 'amy.garcia@example.com', 2, 2),
  (15, 'Brian Lewis', 'brian.lewis@example.com', 3, 3),
  (16, 'Lisa Nguyen', 'lisa.nguyen@example.com', 4, 4),
  (17, 'Matthew Walker', 'matthew.walker@example.com', 5, 5),
  (18, 'Heather Jenkins', 'heather.jenkins@example.com', 6, 6),
  (19, 'William Scott', 'william.scott@example.com', 1, 1),
  (20, 'Olivia Russell', 'olivia.russell@example.com', 2, 2);

INSERT INTO Attendance (AttendanceID, EmployeeID, AttendanceDate, ClockIn, ClockOut, Status)
VALUES
  (1, 1, '2024-01-01', '08:00:00', '17:00:00', 'Present'),
  (2, 2, '2024-01-01', '09:00:00', '18:00:00', 'Present'),
  (3, 3, '2024-01-01', '08:30:00', '17:30:00', 'Present'),
  (4, 4, '2024-01-01', '09:30:00', '18:30:00', 'Present'),
  (5, 5, '2024-01-01', '08:00:00', '17:00:00', 'Present'),
  (6, 6, '2024-01-01', '09:00:00', '18:00:00', 'Present'),
  (7, 7, '2024-01-01', '08:30:00', '17:30:00', 'Present'),
  (8, 8, '2024-01-01', '09:30:00', '18:30:00', 'Present'),
  (9, 9, '2024-01-01', '08:00:00', '17:00:00', 'Present'),
  (10, 10, '2024-01-01', '09:00:00', '18:00:00', 'Present'),
  (11, 11, '2024-01-01', '08:30:00', '17:30:00', 'Present'),
  (12, 12, '2024-01-01', '09:30:00', '18:30:00', 'Present'),
  (13, 13, '2024-01-01', '08:00:00', '17:00:00', 'Present'),
  (14, 14, '2024-01-01', '09:00:00', '18:00:00', 'Present'),
  (15, 15, '2024-01-01', '08:30:00', '17:30:00', 'Present'),
  (16, 16, '2024-01-01', '08:20:00', '17:30:00', 'Present'),
  (17, 17, '2024-01-01', '00:00:00', '00:00:00', 'Absent'),
  (18, 18, '2024-01-01', '08:40:00', '17:30:00', 'Present'),
  (19, 19, '2024-01-01', '08:45:00', '17:30:00', 'Present'),
  (20, 20, '2024-01-01', '00:00:00', '00:00:00', 'Absent');
 


-- Monthly Attendance
SELECT EmployeeID, COUNT(*) AS AttendanceCount
FROM Attendance
WHERE MONTH(AttendanceDate) = 1
GROUP BY EmployeeID;



-- Late Arrivals
SELECT EmployeeID, AttendanceDate, ClockIn
FROM Attendance
WHERE ClockIn >= '09:30:00';

-- Timestamp Trigger
DELIMITER //
CREATE TRIGGER trg_attendance_timestamp
BEFORE INSERT ON Attendance
FOR EACH ROW
BEGIN
  SET NEW.AttendanceDate = CURRENT_DATE;
END;//
DELIMITER ;

-- Status Trigger
DELIMITER //
CREATE TRIGGER trg_attendance_status
BEFORE INSERT ON Attendance
FOR EACH ROW
BEGIN
  IF NEW.ClockIn IS NOT NULL AND NEW.ClockOut IS NULL THEN
    SET NEW.Status = 'Present';
  ELSEIF NEW.ClockIn IS NOT NULL AND NEW.ClockOut IS NOT NULL THEN
    SET NEW.Status = 'Absent';
  END IF;
END;//
DELIMITER ;


-- Calculate Total Work Hours

DELIMITER //
CREATE FUNCTION calculate_work_hours(EmployeeID INT) 
RETURNS DECIMAL(10, 2)
READS SQL DATA
BEGIN 
  DECLARE total_hours DECIMAL(10, 2); 
  SELECT SUM(TIMEDIFF(ClockOut, ClockIn)) AS total_hours 
  INTO total_hours 
  FROM Attendance 
  WHERE Attendance.EmployeeID = calculate_work_hours.EmployeeID; 
  RETURN total_hours; 
END;// 
DELIMITER ;

-- Attendance Report

SELECT DepartmentName, COUNT(*) AS AttendanceCount 
FROM Attendance 
JOIN Employees ON Attendance.EmployeeID = Employees.EmployeeID 
JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID 
GROUP BY DepartmentName;





