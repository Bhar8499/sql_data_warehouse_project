/*
=============================================================
Quality Checks - Gold Layer
=============================================================

Script Purpose:
This script performs data quality checks to validate the integrity,
consistency, and accuracy of the Gold Layer tables in the data warehouse.

These checks ensure:
- Uniqueness of surrogate keys in dimension tables.
- Referential integrity between fact and dimension tables.
- Valid relationships between entities in the star schema.
- Data consistency required for reliable analytical reporting.

Usage Notes:
- Run these checks after the Gold Layer views/tables are created.
- The queries are expected to return **no results** when the data is valid.
- If records are returned, investigate and resolve the data issues.

These validations help guarantee that the Gold Layer provides
clean, reliable, and analysis-ready datasets for business intelligence
and reporting.
=============================================================
*/

-- =========================================================
-- Checking 'gold.dim_customers'
-- =========================================================
SELECT
    customer_key,
  COUNT(*) AS duplicate_count
  FROM gold.dim_customers
  GROUP BY customer_key
  HAVING COUNT(*) > 1;
-- =========================================================
-- Checking 'gold.dim_products'
-- =========================================================
-- Check for Uniquwnwss of Product Key in gold.dim_products
-- Expectation: No Results
SELECT
    product_key,
  COUNT(*) AS duplicate_count
  FROM gold.dim_products
  GROUP BY product_key
  HAVING COUNT(*) > 1;
-- =========================================================
-- Checking 'gold.fact_sales'
-- =========================================================
-- Check the data model connectivity between fact and dimensions
SELECT *
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
WHERE p.product_key IS NULL OR c.customer_key IS NULL
