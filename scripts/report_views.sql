/*
=============================================================
Gold Layer Report Views
=============================================================

Script Purpose:
This script creates business-ready reporting views in the Gold Layer.

Views Included:
- gold.report_customers
- gold.report_products

These views aggregate customer and product metrics to support:
- Reporting
- Dashboarding
- Customer segmentation
- Product performance analysis

Usage:
- Run this script after gold.dim_customers, gold.dim_products,
  and gold.fact_sales are available.
=============================================================
*/

-- Drop and recreate customer report view
IF OBJECT_ID('gold.report_customers', 'V') IS NOT NULL
    DROP VIEW gold.report_customers;
GO

/*
=====================================================================

Customer Report

=====================================================================

Purpose:
    - This report consolidates key customer metrics and behaviors.

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
    2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
        - total orders
        - total sales
        - total quantity purchased
        - total products
        - lifespan (in months)
    4. Calculates valuable KPIs:
        - recency (months since last order)
        - average order value
        - average monthly spend

=====================================================================
*/

CREATE VIEW gold.report_customers AS
WITH base_query AS
(
    /*-------------------------------------------------------------------
    1) Base Query: Retrieves core columns from tables
    -------------------------------------------------------------------*/
    SELECT
        f.order_number,
        f.product_key,
        f.order_date,
        f.sales_amount,
        f.quantity,
        c.customer_key,
        c.customer_number,
        CONCAT(TRIM(c.first_name), ' ', TRIM(c.last_name)) AS customer_name,
        DATEDIFF(YEAR, c.birthdate, GETDATE()) AS age
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c
        ON c.customer_key = f.customer_key
    WHERE f.order_date IS NOT NULL
),

customer_aggregation AS
(
    /*-------------------------------------------------------------------
    2) Customer Aggregations: Summarizes key metrics at the customer level
    -------------------------------------------------------------------*/
    SELECT
        customer_key,
        customer_number,
        customer_name,
        age,
        COUNT(DISTINCT order_number) AS total_orders,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        COUNT(DISTINCT product_key) AS total_products,
        MAX(order_date) AS last_order_date,
        DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan
    FROM base_query
    GROUP BY
        customer_key,
        customer_number,
        customer_name,
        age
)

SELECT
    customer_key,
    customer_number,
    customer_name,
    age,
    CASE
        WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20 - 29'
        WHEN age BETWEEN 30 AND 39 THEN '30 - 39'
        WHEN age BETWEEN 40 AND 49 THEN '40 - 49'
        ELSE '50 and above'
    END AS age_group,
    CASE
        WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
        WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
        ELSE 'New'
    END AS customer_segment,
    last_order_date,
    DATEDIFF(MONTH, last_order_date, GETDATE()) AS recency,
    total_orders,
    total_sales,
    total_quantity,
    total_products,
    lifespan,
    CASE
        WHEN total_orders = 0 THEN 0
        ELSE CAST(total_sales AS FLOAT) / total_orders
    END AS avg_order_value,
    CASE
        WHEN lifespan = 0 THEN total_sales
        ELSE CAST(total_sales AS FLOAT) / lifespan
    END AS avg_monthly_spend
FROM customer_aggregation;
GO

-- Drop and recreate product report view
IF OBJECT_ID('gold.report_products', 'V') IS NOT NULL
    DROP VIEW gold.report_products;
GO

/*
=====================================================================

Product Report

=====================================================================

Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
        - total orders
        - total sales
        - total quantity sold
        - total customers (unique)
        - lifespan (in months)
    4. Calculates valuable KPIs:
        - recency (months since last sale)
        - average order revenue
        - average monthly revenue

=====================================================================
*/

CREATE VIEW gold.report_products AS
WITH product_details AS
(
    SELECT
        p.product_number,
        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost,
        s.order_number,
        s.order_date,
        s.sales_amount,
        s.quantity,
        s.customer_key
    FROM gold.dim_products p
    LEFT JOIN gold.fact_sales s
        ON p.product_key = s.product_key
    WHERE s.order_date IS NOT NULL
),

product_aggregation AS
(
    SELECT
        product_key,
        product_name,
        category,
        subcategory,
        cost,
        SUM(sales_amount) AS total_sales,
        COUNT(DISTINCT order_number) AS total_orders,
        COUNT(DISTINCT customer_key) AS total_unique_customers,
        MAX(order_date) AS last_sale_date,
        DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
        SUM(quantity) AS total_quantity,
        ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)), 1) AS avg_selling_price
    FROM product_details
    GROUP BY
        product_key,
        product_name,
        category,
        subcategory,
        cost
)

SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    lifespan,
    last_sale_date,
    total_orders,
    total_sales,
    total_quantity,
    total_unique_customers,
    avg_selling_price,
    CASE
        WHEN total_sales > 50000 THEN 'High Performer'
        WHEN total_sales >= 10000 THEN 'Mid Range'
        ELSE 'Low Performer'
    END AS product_segment,
    DATEDIFF(MONTH, last_sale_date, GETDATE()) AS recency,
    CASE
        WHEN total_orders = 0 THEN 0
        ELSE CAST(total_sales AS FLOAT) / total_orders
    END AS avg_order_revenue,
    CASE
        WHEN lifespan = 0 THEN total_sales
        ELSE CAST(total_sales AS FLOAT) / lifespan
    END AS avg_monthly_income
FROM product_aggregation;
GO

-- Validation queries
SELECT *
FROM gold.report_customers;

SELECT *
FROM gold.report_products;
