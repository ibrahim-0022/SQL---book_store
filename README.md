# Book Store Analysis SQL Project

## Project Overview

**Project Title**: Book Store Analysis  
**Level**: Beginner  
**Database**: `Online_Bookstore`

This project focuses on analyzing a bookstore's data using SQL to extract meaningful business insights related to books, customers, orders, sales revenue, inventory, and purchasing patterns.

The project uses three CSV datasets — Books, Customers, and Orders — to explore real-world business scenarios and solve analytical questions using SQL queries.

The objective is to strengthen SQL querying skills, understand relationships between multiple tables, and analyze sales performance and inventory management through data-driven insights.

## Dataset Description

The project consists of three CSV files:

- Books.csv — Contains information about books, including book id, book titles, authors, genres, publication years, prices, and available stock.
- Customers.csv — Contains customer information, including names, locations, and other customer-related details.
- Orders.csv — Contains order transaction details, including books purchased, quantities, order dates, and total amounts.

These datasets are connected through relevant identifiers to analyze relationships between books, customers, and orders.

## Project Objectives

- Analyze book inventory, genres, authors, and pricing.
- Explore customer locations and purchasing behavior.
- Examine order history and sales transactions.
- Calculate total revenue and quantities sold.
- Identify popular books and customer spending patterns.
- Evaluate remaining inventory after fulfilling orders.
- Practice basic and advanced SQL queries on a relational dataset.

## SQL Concepts Covers

The project covers the following SQL concepts:

- "SELECT" and "DISTINCT"
- "WHERE" and filtering conditions
- "ORDER BY"
- Aggregate functions such as "SUM()", "AVG()", "COUNT()", "MIN()", and "MAX()"
- "GROUP BY" and "HAVING"
- "INNER JOIN" and table relationships
- Subqueries
- Common Table Expressions (CTEs), where applicable
- Sorting and ranking records
- Calculations using arithmetic expressions
- Sales and inventory analysis

## Analysis & Business Questions

### Database Setup
```sql
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
```

## Basic SQL Queries

These questions focus on retrieving, filtering, and summarizing bookstore data.

1. **Retrieve all books in the "Fiction" genre**
```sql
select * 
from books
where genre = 'Fiction'
```

2. **Find books published after the year 1950**
```sql
select * 
from books 
where published_year > 1950
order by published_year asc
```

3. **List all customers from Canada**
```sql
select * 
from customers
where country = 'Canada'
```

4. **Show orders placed in November 2023**
```sql
select * 
from orders 
where extract(year from order_date) = 2023 
and extract(month from order_date) = 11
``` 

5. **Retrieve the total stock of books available**
```sql
select sum(stock) as "Total Stock" 
from books
```

6. **Find the details of the most expensive book**
```sql
select *
from books
order by price desc
limit 1
```

7. **Show all customers who ordered more than 5 quantity of a book**
```sql
select * 
from orders 
where quantity > 5
order by customer_id
```

8. **show all customers who orderes over all more than 20**
```sql
select o.customer_id, name, email, sum(quantity) as "Quantity"
from orders o
join customers c on o.customer_id = c.customer_id
group by o.customer_id, name, email
having sum(quantity) > 20
order by 2
```

9. **Retrieve all orders where the total amount exceeds $200**
```sql
select * 
from orders
where total_amount > 200
```

10. **List all genres available in the Books table**
```sql
select distinct genre
from books
```

11. **Find the book with the lowest stock**
```sql
select * 
from books
order by stock asc
limit 1
```

12. **Calculate the total revenue generated from all orders**
```sql
select sum(total_amount) as "Total Revenue" 
from orders
```

## Advanced SQL Queries

These questions focus on aggregations, multi-table analysis, customer behavior, sales performance, and inventory calculations.

1. **Retrieve the total number of books sold for each genre**
```sql
select b.genre, sum(quantity) as "Books Sold"
from books b
join orders o on b.book_id = o.book_id
group by b.genre
```

2. **Find the average price of books in the "Fantasy" genre**
```sql
select avg(price) as "Avrage price", genre
from books
where genre = 'Fantasy'
group by genre
```

3. **List customers who have placed at least 2 orders**
```sql
select o.customer_id, name, count(order_id) as "Orders"
from orders o
join customers c on o.customer_id = c.customer_id
group by o.customer_id, name
having count(order_id) >= 2
```

4. **Find the most frequently ordered book**
```sql
select title, o.book_id, count(order_id) as "Frequently"
from orders o
join books b on o.book_id = b.book_id
group by o.book_id, title
having count(order_id) > 1
order by 2 desc
```

5. **Show the top 3 most expensive books in the "Fantasy" genre**
```sql
select *
from books
where genre = 'Fantasy'
order by price desc
limit 3
```

6. **Retrieve the total quantity of books sold by each author**
```sql
select author, sum(quantity) as "Total Sold"
from orders o
join books b on o.book_id = b.book_id
group by author
```

7. **List the cities where the total amount spent on orders exceeds $500**:
```sql
select city, sum(total_amount)
from customers c
join orders o on c.customer_id = o.customer_id
group by city
having sum(total_amount) > 500
order by city 
```

8. **List the cities where customers who placed individual orders worth more than $200**:
```sql
select city, total_amount
from customers c
join orders o on c.customer_id = o.customer_id
where total_amount > 200
order by city

```

9. **Find the customer who spent the most on orders**:
```sql
select o.customer_id, sum(total_amount) as "Total Amount", name
from orders o
join customers c on o.customer_id = c.customer_id
group by o.customer_id, name
order by "Total Amount" desc
```

10) **Calculate the stock remaining after fulfilling all orders**:
```sql
select b.book_id, b.title, b.stock, coalesce(sum(quantity),0) as "Quantity",
                           b.stock - coalesce(sum(quantity),0) as "Remaining quantity"
from books b
left join orders o on b.book_id = o.book_id
group by b.book_id
```

## Key Learning Outcomes

Through this project, I practiced writing SQL queries to answer business-related questions and analyze structured data.

The project helped me develop practical experience in:

- Retrieving and filtering relevant records.
- Summarizing data using aggregate functions.
- Combining information from related tables.
- Analyzing sales, revenue, and customer purchasing behavior.
- Evaluating inventory levels and book demand.
- Translating business questions into SQL queries.

## Author - Ibrahim

This project is part of my practical learning journey in SQL and data analytics.