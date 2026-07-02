-- ========================================================
-- STEP 1: CORE DATABASE SCHEMA
-- Enterprise Retail Inventory & Security Audit Layout
-- ========================================================

-- 1. Products Table
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

-- 2. Exchange Rates Table (To handle dual-currency tracking)
CREATE TABLE exchange_rates (
    rate_id INT AUTO_INCREMENT PRIMARY KEY,
    rate_date DATE NOT NULL UNIQUE,
    usd_to_local_rate DECIMAL(10, 2) NOT NULL, -- e.g., Conversion multiplier
    CONSTRAINT chk_rate CHECK (usd_to_local_rate > 0)
);

-- 3. Sales Transactions Table (The live sales ledger)
CREATE TABLE sales_transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    transaction_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    quantity_sold INT NOT NULL,
    payment_method VARCHAR(30) NOT NULL, -- e.g., 'Cash-USD', 'Cash-Local', 'Bank Transfer', 'Mobile Money'
    amount_paid_usd DECIMAL(10, 2) NOT NULL,
    exchange_rate_used INT NOT NULL, -- Links back to the exact conversion day
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (exchange_rate_used) REFERENCES exchange_rates(rate_id),
    CONSTRAINT chk_qty_sold CHECK (quantity_sold > 0),
    CONSTRAINT chk_amt_paid CHECK (amount_paid_usd >= 0)
);

-- 4. Daily Reconciliation Table (The Security Audit Ledger)
CREATE TABLE daily_reconciliation (
    reconciliation_id INT AUTO_INCREMENT PRIMARY KEY,
    reconciliation_date DATE NOT NULL UNIQUE,
    expected_sales_usd DECIMAL(10, 2) NOT NULL DEFAULT 0.00, -- System generated sum
    actual_physical_cash_usd DECIMAL(10, 2) NOT NULL DEFAULT 0.00, -- Physical vault count
    net_reconciliation_variance DECIMAL(10, 2) NOT NULL DEFAULT 0.00, -- Discrepancy (Expected vs Actual)
    verified_by_user VARCHAR(50) NOT NULL, -- Audit trail tracking who did the count
    audit_status VARCHAR(20) DEFAULT 'PENDING', -- 'CLEARED' or 'INVESTIGATE'
    CONSTRAINT chk_variance_logic CHECK (net_reconciliation_variance = (actual_physical_cash_usd - expected_sales_usd))
);
