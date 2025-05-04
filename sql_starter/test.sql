-- Test Schema (test.sql)

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(50) NOT NULL,
  email VARCHAR(100),
  email_verified BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  total DECIMAL(10, 2),
  status VARCHAR(20),
  shipped_at TIMESTAMP
);

CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  price DECIMAL(10, 2),
  in_stock BOOLEAN DEFAULT TRUE,
  weight FLOAT
);

CREATE TABLE categories (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50),
  description TEXT
);

CREATE TABLE product_categories (
  product_id INTEGER REFERENCES products(id),
  category_id INTEGER REFERENCES categories(id),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (product_id, category_id)
);

CREATE TABLE payments (
  id SERIAL PRIMARY KEY,
  order_id INTEGER REFERENCES orders(id),
  amount DECIMAL(10, 2),
  method VARCHAR(20),
  paid_at TIMESTAMP,
  refunded BOOLEAN DEFAULT FALSE
);

CREATE TABLE reviews (
  id SERIAL PRIMARY KEY,
  product_id INTEGER REFERENCES products(id),
  user_id INTEGER REFERENCES users(id),
  rating INTEGER CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  review_date DATE
);

CREATE TABLE shipping_addresses (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  address TEXT,
  city VARCHAR(100),
  state VARCHAR(100),
  zip_code VARCHAR(20)
);

CREATE TABLE inventory_logs (
  id SERIAL PRIMARY KEY,
  product_id INTEGER REFERENCES products(id),
  change INTEGER,
  reason TEXT,
  changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE discounts (
  id SERIAL PRIMARY KEY,
  code VARCHAR(50) UNIQUE,
  percentage INTEGER CHECK (percentage >= 0 AND percentage <= 100),
  valid_until DATE,
  is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE audit_logs (
  id SERIAL PRIMARY KEY,
  action VARCHAR(100),
  user_id INTEGER,
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
