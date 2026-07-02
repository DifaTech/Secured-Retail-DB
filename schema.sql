-- ========================================================
-- STEP 1: CORE DATABASE SCHEMA
-- Enterprise Retail Inventory & Security Audit Layout
-- ========================================================

-- 1. Create Products Table
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    model_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) DEFAULT 'Accessories', -- e.g., 'Phones', 'Accessories'
    stock_quantity INT NOT NULL DEFAULT 0,
    min_stock_level INT DEFAULT 5, -- Triggers low stock alert
    cost_price_usd DECIMAL(10, 2) NOT NULL, -- Internal financial data
    retail_price_usd DECIMAL(10, 2) NOT NULL,
    CONSTRAINT chk_stock CHECK (stock_quantity >= 0),
    CONSTRAINT chk_prices CHECK (cost_price_usd >= 0 AND retail_price_usd >= cost_price_usd)
);

-- 2. Create Exchange Rates Table (To handle dual-currency tracking)
CREATE TABLE exchange_rates (
    rate_id INT AUTO_INCREMENT PRIMARY KEY,
    rate_date DATE NOT NULL UNIQUE,
    usd_to_local_rate DECIMAL(10, 2) NOT NULL, -- e.g., Conversion multiplier
    CONSTRAINT chk_rate CHECK (usd_to_local_rate > 0)
);
