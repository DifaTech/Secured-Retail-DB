-- ========================================================
-- STEP 2: EXPANDED TESTING DATASET (20 RECORDS)
-- Safe, non-sensitive enterprise testing data
-- ========================================================

-- 1. Populate Mock Products (Phones and Accessories)
INSERT INTO products (model_name, category, stock_quantity, min_stock_level, cost_price_usd, retail_price_usd) VALUES
('Tecno POP 9', 'Phones', 88, 10, 80.00, 110.00),
('Infinix Smart 8', 'Phones', 45, 8, 90.00, 125.00),
('Oraimo Powerbank 20k', 'Accessories', 120, 15, 12.00, 22.00),
('Type-C Fast Charging Cable', 'Accessories', 200, 20, 2.50, 6.00),
('Samsung Galaxy A15', 'Phones', 30, 5, 140.00, 185.00),
('Wireless Bluetooth Earbuds', 'Accessories', 75, 12, 15.00, 30.00);

-- 2. Populate Exchange Rates for the Audit Period
INSERT INTO exchange_rates (rate_date, usd_to_local_rate) VALUES
('2026-06-28', 1500.00),
('2026-06-29', 1510.00),
('2026-06-30', 1505.00),
('2026-07-01', 1515.00);

-- 3. Live Ledger Transactions (16 Mock Sales Entries)

-- Day 1: June 28, 2026 (Total Expected: $340.00)
INSERT INTO sales_transactions (product_id, transaction_timestamp, quantity_sold, payment_method, amount_paid_usd, exchange_rate_used) VALUES
(1, '2026-06-28 09:15:00', 1, 'Cash-USD', 110.00, 1),
(3, '2026-06-28 10:30:00', 2, 'Cash-Local', 44.00, 1),
(4, '2026-06-28 11:45:00', 5, 'Mobile Money', 30.00, 1),
(2, '2026-06-28 14:20:00', 1, 'Cash-USD', 125.00, 1),
(6, '2026-06-28 16:05:00', 1, 'Bank Transfer', 31.00, 1);

-- Day 2: June 29, 2026 (Total Expected: $464.00)
INSERT INTO sales_transactions (product_id, transaction_timestamp, quantity_sold, payment_method, amount_paid_usd, exchange_rate_used) VALUES
(5, '2026-06-29 09:40:00', 1, 'Cash-USD', 185.00, 2),
(4, '2026-06-29 11:10:00', 4, 'Cash-Local', 24.00, 2),
(1, '2026-06-29 13:15:00', 1, 'Cash-USD', 110.00, 2),
(3, '2026-06-29 15:00:00', 5, 'Cash-USD', 110.00, 2),
(6, '2026-06-29 16:45:00', 1, 'Mobile Money', 35.00, 2);

-- Day 3: June 30, 2026 (Total Expected: $416.00)
INSERT INTO sales_transactions (product_id, transaction_timestamp, quantity_sold, payment_method, amount_paid_usd, exchange_rate_used) VALUES
(2, '2026-06-30 10:00:00', 2, 'Cash-USD', 250.00, 3),
(4, '2026-06-30 12:30:00', 10, 'Cash-Local', 60.00, 3),
(6, '2026-06-30 14:15:00', 2, 'Bank Transfer', 62.00, 3),
(3, '2026-06-30 15:50:00', 2, 'Cash-USD', 44.00, 3);

-- Day 4: July 01, 2026 (Total Expected: $295.00)
INSERT INTO sales_transactions (product_id, transaction_timestamp, quantity_sold, payment_method, amount_paid_usd, exchange_rate_used) VALUES
(1, '2026-07-01 11:00:00', 1, 'Cash-USD', 110.00, 4),
(5, '2026-07-01 14:30:00', 1, 'Cash-USD', 185.00, 4);


-- 4. Security Audit Ledger (4 End-of-Day Reconciliation Records)

-- June 28: Balanced Day
INSERT INTO daily_reconciliation (reconciliation_date, expected_sales_usd, actual_physical_cash_usd, net_reconciliation_variance, verified_by_user, audit_status) VALUES
('2026-06-28', 340.00, 340.00, 0.00, 'Favour_Manager', 'CLEARED');

-- June 29: ANOMALY! Vault count is short by $15.00
INSERT INTO daily_reconciliation (reconciliation_date, expected_sales_usd, actual_physical_cash_usd, net_reconciliation_variance, verified_by_user, audit_status) VALUES
('2026-06-29', 464.00, 449.00, -15.00, 'Favour_Manager', 'INVESTIGATE');

-- June 30: Balanced Day
INSERT INTO daily_reconciliation (reconciliation_date, expected_sales_usd, actual_physical_cash_usd, net_reconciliation_variance, verified_by_user, audit_status) VALUES
('2026-06-30', 416.00, 416.00, 0.00, 'Favour_Manager', 'CLEARED');

-- July 01: ANOMALY! Vault has an unexplained overage of $20.00
INSERT INTO daily_reconciliation (reconciliation_date, expected_sales_usd, actual_physical_cash_usd, net_reconciliation_variance, verified_by_user, audit_status) VALUES
('2026-07-01', 295.00, 315.00, 20.00, 'Favour_Manager', 'INVESTIGATE');
