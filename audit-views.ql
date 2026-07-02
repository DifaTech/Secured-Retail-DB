-- ========================================================
-- STEP 4: AUTOMATED AUDIT VIEWS & DISCREPANCY DETECTION
-- Providing Actionable Threat & Inventory Intelligence
-- ========================================================

-- 1. Inventory View: Real-Time Low Stock Alert System
-- Filters products to instantly show items needing immediate reorder.
CREATE VIEW v_low_stock_alerts AS
SELECT 
    product_id,
    model_name,
    category,
    stock_quantity,
    min_stock_level
FROM products
WHERE stock_quantity <= min_stock_level;


-- 2. Security & Fraud View: Discrepancy & Variance Tracker
-- Isolates daily entries where physical cash does not balance with system sales.
CREATE VIEW v_fraud_and_variance_tracker AS
SELECT 
    reconciliation_date,
    expected_sales_usd,
    actual_physical_cash_usd,
    net_reconciliation_variance,
    CASE 
        WHEN net_reconciliation_variance < 0 THEN 'CASH SHORTAGE / POSSIBLE FRAUD'
        WHEN net_reconciliation_variance > 0 THEN 'CASH OVERAGE / RECORDING ERROR'
        ELSE 'BALANCED'
    END AS audit_assessment,
    verified_by_user
FROM daily_reconciliation
WHERE net_reconciliation_variance != 0.00;
