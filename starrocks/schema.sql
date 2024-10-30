-- retail_transactions.sql


CREATE SCHEMA retail;

USE retail;


-- ====================================
-- Step 1: Create the Tables
-- ====================================

-- Create Users Table
CREATE TABLE IF NOT EXISTS users (
    user_id INT NOT NULL,
    user_name VARCHAR(100),
    email VARCHAR(100),
    created_at DATE
) ENGINE=OLAP
DUPLICATE KEY(user_id)
COMMENT "Users Table"
DISTRIBUTED BY HASH(user_id) BUCKETS 4
PROPERTIES (
    "storage_format" = "V2"
);

-- Create Items Table
CREATE TABLE IF NOT EXISTS items (
    item_id INT NOT NULL,
    item_name VARCHAR(100),
    price DECIMAL(10, 2)
) ENGINE=OLAP
DUPLICATE KEY(item_id)
COMMENT "Items Table"
DISTRIBUTED BY HASH(item_id) BUCKETS 4
PROPERTIES (
    "storage_format" = "V2"
);

-- Create Stores Table
CREATE TABLE IF NOT EXISTS stores (
    store_id INT NOT NULL,
    store_name VARCHAR(100),
    location VARCHAR(100)
) ENGINE=OLAP
DUPLICATE KEY(store_id)
COMMENT "Stores Table"
DISTRIBUTED BY HASH(store_id) BUCKETS 4
PROPERTIES (
    "storage_format" = "V2"
);

-- Create Transactions Table
CREATE TABLE IF NOT EXISTS transactions (
    transaction_id INT NOT NULL,
    user_id INT,
    item_id INT,
    store_id INT,
    transaction_date DATE,
    quantity INT,
    total_amount DECIMAL(10, 2)
) ENGINE=OLAP
DUPLICATE KEY(transaction_id)
COMMENT "Transactions Table"
DISTRIBUTED BY HASH(transaction_id) BUCKETS 4
PROPERTIES (
    "storage_format" = "V2"
);

-- ====================================
-- Step 2: Insert Sample Data
-- ====================================

-- Insert Data into Users Table
INSERT INTO users (user_id, user_name, email, created_at) VALUES 
(1, 'John Doe', 'john@example.com', '2023-10-01'),
(2, 'Jane Smith', 'jane@example.com', '2023-10-02'),
(3, 'Alice Johnson', 'alice@example.com', '2023-10-03');

-- Insert Data into Items Table
INSERT INTO items (item_id, item_name, price) VALUES 
(1, 'Laptop', 999.99),
(2, 'Smartphone', 499.99),
(3, 'Headphones', 199.99);

-- Insert Data into Stores Table
INSERT INTO stores (store_id, store_name, location) VALUES 
(1, 'Electronics Hub', 'New York'),
(2, 'Gadget World', 'San Francisco'),
(3, 'Tech Bazaar', 'Los Angeles');

-- Insert Data into Transactions Table
INSERT INTO transactions (transaction_id, user_id, item_id, store_id, transaction_date, quantity, total_amount) VALUES 
(1, 1, 1, 1, '2024-10-10', 1, 999.99),
(2, 2, 2, 2, '2024-10-11', 1, 499.99),
(3, 3, 3, 3, '2024-10-12', 2, 399.98);

-- ====================================
-- Step 3: Sample JOIN Queries
-- ====================================

-- 1. Join Users and Transactions to get details of users who made transactions
SELECT 
    u.user_name, 
    t.transaction_id, 
    t.transaction_date, 
    t.total_amount 
FROM 
    users u
JOIN 
    transactions t 
ON 
    u.user_id = t.user_id;

-- 2. Join Transactions, Items, and Stores to get details of transactions, items, and stores
SELECT 
    t.transaction_id, 
    i.item_name, 
    s.store_name, 
    t.quantity, 
    t.total_amount 
FROM 
    transactions t
JOIN 
    items i 
ON 
    t.item_id = i.item_id
JOIN 
    stores s 
ON 
    t.store_id = s.store_id;

-- 3. Join all tables to get full transaction details including user, item, and store information
SELECT 
    t.transaction_id
  , 
    u.user_name
  , 
    i.item_name
  , 
    s.store_name
  , 
    t.quantity
  , 
    t.total_amount
  , 
    t.transaction_date
FROM 
    transactions t
JOIN 
    users u 
ON 
    t.user_id = u.user_id
JOIN 
    items i 
ON 
    t.item_id = i.item_id
JOIN 
    stores s 
ON 
    t.store_id = s.store_id;

ADMIN SHOW FRONTEND CONFIG LIKE "%default_replication_num%";


explain analyze SELECT 
    t.transaction_id
  , 
    u.user_name
  , 
    i.item_name
  , 
    s.store_name
  , 
    t.quantity
  , 
    t.total_amount
  , 
    t.transaction_date
FROM 
    transactions t
JOIN 
    users u 
ON 
    t.user_id = u.user_id
JOIN 
    items i 
ON 
    t.item_id = i.item_id
JOIN 
    stores s 
ON 
    t.store_id = s.store_id;
    
explain analyze SELECT 
    t.transaction_id
  , 
    u.user_name
  , 
    i.item_name
  , 
    s.store_name
  , 
    t.quantity
  , 
    t.total_amount
  , 
    t.transaction_date
FROM 
    users u
JOIN 
    transactions t
ON 
    u.user_id = t.user_id
JOIN 
    items i 
ON 
    t.item_id = i.item_id
JOIN 
    stores s 
ON 
    t.store_id = s.store_id;