create database store;
-- drop database book_store;
use store;
CREATE TABLE BOOKS (
    BOOK_ID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(50),
    Genre varchar (100),
    Published_year INT,
    Price numeric (10,2),
    Stock INT
);

-- Book_ID,Title,Author,Genre,Published_Year,Price,Stock
CREATE TABLE CUSTOMERS (
    Customer_id INT PRIMARY KEY,
    Name  VARCHAR(100),
    Email VARCHAR(50),
    Phone VARCHAR(15),
    City varchar (100),
    Country VARCHAR(100)
);

CREATE TABLE ORDERS (
    ORDER_ID serial PRIMARY KEY,
    CUSTOMER_ID INT REFERENCES CUSTOMERS(CUSTOMER_ID)  ,
    BOOK_ID INT  REFERENCES BOOKS(BOOK_ID),
    Order_Date  DATE,
    Quantity INT,
     Total_Amount numeric (10,2)
);

select * from ORDERS;
SELECT * FROM CUSTOMERS;
SELECT * FROM BOOKS;


-- 1) Retrieve all books in the "Fiction" genre:

SELECT * FROM Books 
WHERE Genre='Fiction';

-- 2) Find books published after the year 1950:
SELECT * FROM Books 
WHERE Published_year>1950;

-- 3) List all customers from the Canada:
SELECT * FROM Customers 
WHERE country='Canada';


-- 4) Show orders placed in November 2023:

SELECT * FROM Orders 
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Retrieve the total stock of books available:

SELECT SUM(stock) AS Total_Stock
From Books;


-- 6) Find the details of the most expensive book:
SELECT * FROM Books 
ORDER BY Price DESC 
LIMIT 1;


-- 7) Show all customers who ordered more than 1 quantity of a book:
SELECT * FROM Orders 
WHERE quantity>1;



-- 8) Retrieve all orders where the total amount exceeds $20:
SELECT * FROM Orders 
WHERE total_amount>20;



-- 9) List all genres available in the Books table:
SELECT DISTINCT genre FROM Books;


-- 10) Find the book with the lowest stock:
SELECT * FROM Books 
ORDER BY stock 
LIMIT 1;


-- 11) Calculate the total revenue generated from all orders:
SELECT SUM(total_amount) As Revenue 
FROM Orders;

-- Advance Query : 

-- 1) Retrieve the total number of books sold for each genre:

SELECT * FROM ORDERS;

SELECT b.Genre, SUM(o.Quantity) AS Total_Books_sold
FROM Orders o
JOIN Books b ON o.book_id = b.book_id
GROUP BY b.Genre;

-- 2) Find the average price of books in the "Fantasy" genre:
SELECT AVG(price) AS Average_Price
FROM Books
WHERE Genre = 'Fantasy';

-- 3) List customers who have placed at least 2 orders:
SELECT o.customer_id, c.name, COUNT(o.Order_id) AS ORDER_COUNT
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY o.customer_id, c.name
HAVING COUNT(Order_id) >=2;


-- 4) Find the most frequently ordered book:
SELECT o.Book_id, b.title, COUNT(o.order_id) AS ORDER_COUNT
FROM orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY o.book_id, b.title
ORDER BY ORDER_COUNT DESC LIMIT 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
SELECT * FROM books
WHERE genre ='Fantasy'
ORDER BY price DESC LIMIT 3;


-- 6) Retrieve the total quantity of books sold by each author:

SELECT b.author, SUM(o.quantity) AS Total_Books_Sold
FROM orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY b.Author;

-- 7) List the cities where customers who spent over $30 are located:

SELECT DISTINCT c.city, total_amount
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
WHERE o.total_amount > 30;


-- 8) Find the customer who spent the most on orders:
SELECT c.customer_id, c.name, SUM(o.total_amount) AS Total_Spent
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY Total_spent Desc LIMIT 1;


-- 9) Calculate the stock remaining after fulfilling all orders:

SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,  
	b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;


-- 1. Total number of books sold for each genre
SELECT 
    B.GENRE,
    SUM(O.QUANTITY) AS TOTAL_BOOKS_SOLD
FROM BOOKS B
JOIN ORDERS O
ON B.BOOK_ID = O.BOOK_ID
GROUP BY B.GENRE
ORDER BY TOTAL_BOOKS_SOLD DESC;


-- 2. Average price of Fantasy books
SELECT 
    AVG(PRICE) AS AVG_FANTASY_PRICE
FROM BOOKS
WHERE GENRE = 'Fantasy';


-- 3. Customers who placed at least 2 orders
SELECT 
    C.CUSTOMER_ID,
    C.NAME,
    COUNT(O.ORDER_ID) AS TOTAL_ORDERS
FROM CUSTOMERS C
JOIN ORDERS O
ON C.CUSTOMER_ID = O.CUSTOMER_ID
GROUP BY C.CUSTOMER_ID, C.NAME
HAVING COUNT(O.ORDER_ID) >= 2;


-- 4. Most frequently ordered book
SELECT 
    B.BOOK_ID,
    B.TITLE,
    SUM(O.QUANTITY) AS TOTAL_QUANTITY
FROM BOOKS B
JOIN ORDERS O
ON B.BOOK_ID = O.BOOK_ID
GROUP BY B.BOOK_ID, B.TITLE
ORDER BY TOTAL_QUANTITY DESC
LIMIT 1;


-- 5. Top 3 most expensive Fantasy books
SELECT *
FROM BOOKS
WHERE GENRE = 'Fantasy'
ORDER BY PRICE DESC
LIMIT 3;


-- 6. Total quantity of books sold by each author
SELECT 
    B.AUTHOR,
    SUM(O.QUANTITY) AS TOTAL_BOOKS_SOLD
FROM BOOKS B
JOIN ORDERS O
ON B.BOOK_ID = O.BOOK_ID
GROUP BY B.AUTHOR
ORDER BY TOTAL_BOOKS_SOLD DESC;


-- 7. Cities where customers spent over $30

SELECT 
    C.CITY,
    C.NAME,
    SUM(O.TOTAL_AMOUNT) AS TOTAL_SPENT
FROM CUSTOMERS C
JOIN ORDERS O
ON C.CUSTOMER_ID = O.CUSTOMER_ID
GROUP BY C.CUSTOMER_ID, C.NAME, C.CITY
HAVING SUM(O.TOTAL_AMOUNT) > 30;


-- 8. Customer who spent the most on orders
SELECT 
    C.CUSTOMER_ID,
    C.NAME,
    SUM(O.TOTAL_AMOUNT) AS TOTAL_SPENT
FROM CUSTOMERS C
JOIN ORDERS O
ON C.CUSTOMER_ID = O.CUSTOMER_ID
GROUP BY C.CUSTOMER_ID, C.NAME
ORDER BY TOTAL_SPENT DESC
LIMIT 1;


-- 9. Calculate remaining stock after fulfilling all orders

SELECT 
    B.BOOK_ID,
    B.TITLE,
    B.STOCK AS ORIGINAL_STOCK,
    COALESCE(SUM(O.QUANTITY), 0) AS TOTAL_SOLD,
    B.STOCK - COALESCE(SUM(O.QUANTITY), 0) AS REMAINING_STOCK
FROM BOOKS B
LEFT JOIN ORDERS O
ON B.BOOK_ID = O.BOOK_ID
GROUP BY B.BOOK_ID, B.TITLE, B.STOCK
ORDER BY B.BOOK_ID;



-- 1. Find total revenue generated by each book

SELECT b.Book_ID, b.Title,
       SUM(o.Total_Amount) AS Total_Revenue
FROM Books b
JOIN Orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Book_ID, b.Title
ORDER BY Total_Revenue DESC;


-- 2. Find monthly revenue
SELECT 
    DATE_FORMAT(Order_Date, '%Y-%m') AS Order_Month,
    SUM(Total_Amount) AS Monthly_Revenue
FROM Orders
GROUP BY DATE_FORMAT(Order_Date, '%Y-%m')
ORDER BY Order_Month;


-- 3. Find yearly sales

SELECT YEAR(Order_Date) AS Sales_Year,
       SUM(Total_Amount) AS Total_Revenue
FROM Orders
GROUP BY YEAR(Order_Date)
ORDER BY Sales_Year;


-- 4. Find the average order value

SELECT AVG(Total_Amount) AS Average_Order_Value
FROM Orders;


-- 5. Find the highest revenue-generating genre

SELECT b.Genre,
       SUM(o.Total_Amount) AS Total_Revenue
FROM Books b
JOIN Orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Genre
ORDER BY Total_Revenue DESC
LIMIT 1;


-- 6. Find total orders and revenue for each month
SELECT 
    MONTHNAME(Order_Date) AS Month_Name,
    COUNT(Order_ID) AS Total_Orders,
    SUM(Total_Amount) AS Revenue
FROM Orders
GROUP BY MONTH(Order_Date), MONTHNAME(Order_Date)
ORDER BY MONTH(Order_Date);



-- 7. Find customers who have never placed an order

SELECT c.Customer_ID, c.Name
FROM Customers c
LEFT JOIN Orders o
ON c.Customer_ID = o.Customer_ID
WHERE o.Order_ID IS NULL;


-- 8. Find the top 5 highest spending customers

SELECT c.Customer_ID, c.Name,
       SUM(o.Total_Amount) AS Total_Spent
FROM Customers c
JOIN Orders o
ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Name
ORDER BY Total_Spent DESC
LIMIT 5;


-- 9. Find the number of orders placed by each customer

SELECT c.Customer_ID, c.Name,
       COUNT(o.Order_ID) AS Total_Orders
FROM Customers c
LEFT JOIN Orders o
ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Name;


-- 10. Find customers whose total spending is above average customer spending

SELECT c.Customer_ID, c.Name,
       SUM(o.Total_Amount) AS Total_Spent
FROM Customers c
JOIN Orders o
ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Name
HAVING SUM(o.Total_Amount) >
(
    SELECT AVG(Customer_Spending)
    FROM (
        SELECT SUM(Total_Amount) AS Customer_Spending
        FROM Orders
        GROUP BY Customer_ID
    ) AS Customer_Totals
);


-- 11. Find the most recent order placed by each customer

SELECT c.Customer_ID, c.Name,
       MAX(o.Order_Date) AS Last_Order_Date
FROM Customers c
JOIN Orders o
ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Name;


-- 12. Find customers who placed orders in 2024
SELECT DISTINCT c.Customer_ID, c.Name
FROM Customers c
JOIN Orders o
ON c.Customer_ID = o.Customer_ID
WHERE YEAR(o.Order_Date) = 2024;

-- 13. Find books that have never been ordered
SELECT b.Book_ID, b.Title
FROM Books b
LEFT JOIN Orders o
ON b.Book_ID = o.Book_ID
WHERE o.Order_ID IS NULL;


-- 14. Find the top 5 best-selling books
SELECT b.Book_ID, b.Title,
       SUM(o.Quantity) AS Total_Sold
FROM Books b
JOIN Orders o
ON b.Book_ID = o.Book_ID
GROUP BY b.Book_ID, b.Title
ORDER BY Total_Sold DESC
LIMIT 5;


-- 15. Find authors generating the highest revenue
SELECT b.Author,
       SUM(o.Total_Amount) AS Total_Revenue
FROM Books b
JOIN Orders o
ON b.Book_ID = o.Book_ID
GROUP BY b.Author
ORDER BY Total_Revenue DESC;


-- 16. Find books whose price is above the average book price
SELECT Title, Author, Price
FROM Books
WHERE Price > (SELECT AVG(Price) FROM Books);


-- 17. Find books with stock below 10
SELECT Book_ID, Title, Stock
FROM Books
WHERE Stock < 10
ORDER BY Stock;


-- 18. Find the total number of books in each genre
SELECT Genre,
       COUNT(Book_ID) AS Total_Books
FROM Books
GROUP BY Genre
ORDER BY Total_Books DESC;

-- 19. Categorize books based on price
SELECT Title, Price,
CASE
    WHEN Price >= 500 THEN 'Expensive'
    WHEN Price >= 200 THEN 'Medium'
    ELSE 'Affordable'
END AS Price_Category
FROM Books;


-- 20. Categorize customers based on total spending
SELECT c.Customer_ID, c.Name,
       SUM(o.Total_Amount) AS Total_Spent,
CASE
    WHEN SUM(o.Total_Amount) >= 1000 THEN 'Premium Customer'
    WHEN SUM(o.Total_Amount) >= 500 THEN 'Regular Customer'
    ELSE 'Low Spending Customer'
END AS Customer_Category
FROM Customers c
JOIN Orders o
ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Name;


-- 21. Find total revenue using CTE
WITH Revenue_CTE AS
(
    SELECT SUM(Total_Amount) AS Total_Revenue
    FROM Orders
)
SELECT * FROM Revenue_CTE;


-- 22. Find the best-selling genre using CTE
WITH Genre_Sales AS
(
    SELECT b.Genre,
           SUM(o.Quantity) AS Total_Sold
    FROM Books b
    JOIN Orders o
    ON b.Book_ID = o.Book_ID
    GROUP BY b.Genre
)
SELECT *
FROM Genre_Sales
ORDER BY Total_Sold DESC;


-- 23. Find customers with more than 2 orders using CTE

WITH Customer_Orders AS
(
    SELECT Customer_ID,
           COUNT(Order_ID) AS Total_Orders
    FROM Orders
    GROUP BY Customer_ID
)
SELECT c.Name, co.Total_Orders
FROM Customer_Orders co
JOIN Customers c
ON co.Customer_ID = c.Customer_ID
WHERE co.Total_Orders > 2;