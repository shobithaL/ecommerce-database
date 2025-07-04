USE EcommerceDB;

DELIMITER //

CREATE PROCEDURE AddCustomer(
  IN p_CustomerID INT,
  IN p_Name VARCHAR(255),
  IN p_Email VARCHAR(255),
  IN p_Address VARCHAR(255)
)
BEGIN
  INSERT INTO Customers (CustomerID, Name, Email, Address)
  VALUES (p_CustomerID, p_Name, p_Email, p_Address);
END //

DELIMITER ;

DELIMITER //

CREATE FUNCTION GetCustomerOrderTotal(p_CustomerID INT)
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
  DECLARE total DECIMAL(10, 2);
  SELECT IFNULL(SUM(Total), 0) INTO total
  FROM Orders
  WHERE CustomerID = p_CustomerID;
  RETURN total;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE UpdateProductPrice(
  IN p_ProductID INT,
  IN p_NewPrice DECIMAL(10, 2)
)
BEGIN
  IF p_NewPrice < 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Price cannot be negative';
  ELSE
    UPDATE Products
    SET Price = p_NewPrice
    WHERE ProductID = p_ProductID;
  END IF;
END //

DELIMITER ;