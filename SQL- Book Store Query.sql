-- Create Database
CREATE DATABASE OnlineBookstore;

-- Create Tables
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);

CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);

CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);


-- 1) Retrieve all books in the "Fiction" genre:
select * 
from books
where genre = 'Fiction'

-- 2) Find books published after the year 1950:
select * 
from books 
where published_year > 1950
order by published_year asc

-- 3) List all customers from the Canada:
select * 
from customers
where country = 'Canada'

-- 4) Show orders placed in November 2023:      --There are 3 methods:-
    --1.
select * 
from orders 
where order_date >= '2023-11-01' 
and order_date <='2023-11-30'
    --2.
select * 
from orders 
where order_date between '2023-11-01' 
and '2023-11-30'
    --3.
select * 
from orders 
where extract(year from order_date) = 2023 
and extract(month from order_date) = 11

-- 5) Retrieve the total stock of books available:
select sum(stock) as "Total Stock" 
from books 

-- 6) Find the details of the most expensive book:
select *
from books
order by price desc
limit 1

-- 7) Show all customers who ordered more than 5 quantity of a book:
select * 
from orders 
where quantity > 5
order by customer_id

-- 8) show all customers who orderes over all more than 20 
select o.customer_id, name, email, sum(quantity) as "Quantity"
from orders o
join customers c on o.customer_id = c.customer_id
group by o.customer_id, name, email
having sum(quantity) > 20
order by 2

-- 9) Retrieve all orders where the total amount exceeds $200:
select * 
from orders
where total_amount > 200

-- 10) List all genres available in the Books table:
select genre from books
group by genre

      --or--
	  
select distinct genre
from books

-- 11) Find the book with the lowest stock:
select * 
from books
order by stock asc
limit 1

-- 12) Calculate the total revenue generated from all orders:
select sum(total_amount) as "Total Revenue" 
from orders

               -- Advance Questions --

-- 1) Retrieve the total number of books sold for each genre:
select b.genre, sum(quantity) as "Books Sold"
from books b
join orders o on b.book_id = o.book_id
group by b.genre

-- 2) Find the average price of books in the "Fantasy" genre:
select avg(price) as "Avrage price", genre
from books
where genre = 'Fantasy'
group by genre

-- 3) List customers who have placed at least 2 orders:
select o.customer_id, name, count(order_id) as "Orders"
from orders o
join customers c on o.customer_id = c.customer_id
group by o.customer_id, name
having count(order_id) >= 2

-- 4) Find the most frequently ordered book:
select title, o.book_id, count(order_id) as "Frequently"
from orders o
join books b on o.book_id = b.book_id
group by o.book_id, title
having count(order_id) > 1
order by 2 desc

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
select *
from books
where genre = 'Fantasy'
order by price desc
limit 3

-- 6) Retrieve the total quantity of books sold by each author:
select author, sum(quantity) as "Total Sold"
from orders o
join books b on o.book_id = b.book_id
group by author

-- 7) List the cities where the total amount spent on orders exceeds $500:
select city, sum(total_amount)
from customers c
join orders o on c.customer_id = o.customer_id
group by city
having sum(total_amount) > 500
order by city 

-- 8) List the cities where customers who placed individual orders worth more than $200:
select city, total_amount
from customers c
join orders o on c.customer_id = o.customer_id
where total_amount > 200
order by city

-- 9) Find the customer who spent the most on orders:
select o.customer_id, sum(total_amount) as "Total Amount", name
from orders o
join customers c on o.customer_id = c.customer_id
group by o.customer_id, name
order by "Total Amount" desc

-- 10) Calculate the stock remaining after fulfilling all orders:
select b.book_id, b.title, b.stock, coalesce(sum(quantity),0) as "Quantity",
                           b.stock - coalesce(sum(quantity),0) as "Remaining quantity"
from books b
left join orders o on b.book_id = o.book_id
group by b.book_id