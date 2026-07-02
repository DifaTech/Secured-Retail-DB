-- ========================================================
-- STEP 3: ROLE-BASED ACCESS CONTROL (RBAC) & PERMISSIONS
-- Implementing Least Privilege to Prevent Retail Fraud
-- ========================================================

-- 1. Database Roles/Users
-- (In a live system, these would have strong, encrypted passwords)
CREATE USER 'sales_clerk'@'localhost' IDENTIFIED BY 'ClerkPass123!';
CREATE USER 'ceo_auditor'@'localhost' IDENTIFIED BY 'AuditorPass789!';

-- 2. Grant Limited Permissions to the Sales Clerk
-- A clerk must input sales, but must NEVER edit data or view profit margins.
GRANT SELECT ON retail_security_db.products TO 'sales_clerk'@'localhost';
GRANT INSERT ON retail_security_db.sales_transactions TO 'sales_clerk'@'localhost';

-- Explicit Restriction Context: 
-- The clerk cannot UPDATE or DELETE any transaction.
-- The clerk cannot view or touch the 'daily_reconciliation' audit ledger.
-- The clerk cannot view 'cost_price_usd' inside the products table.

-- 3. Grant Full Administrative/Audit Permissions to the CEO/Auditor
GRANT ALL PRIVILEGES ON retail_security_db.* TO 'ceo_auditor'@'localhost';

-- 4. Apply and Refresh Permissions
FLUSH PRIVILEGES;
