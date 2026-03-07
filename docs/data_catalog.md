
# Data Dictionary for Gold Layer

## Overview
The **Gold Layer** represents the business-level data model designed for analytics and reporting.  
It contains **dimension tables** and **fact tables** optimized for analytical queries and business insights.

---

# 1. gold.dim_customers

**Purpose:**  
Stores customer information enriched with demographic and geographic attributes.

### Columns

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| customer_key | INT | Surrogate key uniquely identifying each customer record in the dimension table. |
| customer_id | INT | Unique numerical identifier assigned to each customer. |
| customer_number | NVARCHAR(50) | Alphanumeric identifier representing the customer for tracking and reference. |
| first_name | NVARCHAR(50) | Customer's first name as recorded in the system. |
| last_name | NVARCHAR(50) | Customer's last name or family name. |
| country | NVARCHAR(50) | Country of residence for the customer (e.g., Australia). |
| marital_status | NVARCHAR(50) | Marital status of the customer (e.g., Married, Single). |
| gender | NVARCHAR(50) | Gender of the customer (e.g., Male, Female). |
| birthdate | DATE | Customer's date of birth formatted as YYYY-MM-DD. |
| create_date | DATE | Date when the customer record was created in the system. |

---

# 2. gold.dim_products

**Purpose:**  
Provides detailed information about products and their attributes.

### Columns

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| product_key | INT | Surrogate key uniquely identifying each product record. |
| product_id | INT | Unique identifier assigned to the product. |
| product_number | NVARCHAR(50) | Alphanumeric code representing the product. |
| product_name | NVARCHAR(50) | Descriptive name of the product. |
| category_id | NVARCHAR(50) | Identifier representing the product category. |
| category | NVARCHAR(50) | High-level classification of the product (e.g., Bikes, Components). |
| subcategory | NVARCHAR(50) | Detailed classification within the category. |
| maintenance_required | NVARCHAR(50) | Indicates whether maintenance is required (Yes/No). |
| cost | INT | Base cost or price of the product. |
| product_line | NVARCHAR(50) | Product series or line (e.g., Road, Mountain). |
| start_date | DATE | Date when the product became available for sale. |

---

# 3. gold.fact_sales

**Purpose:**  
Stores transactional sales data used for analytical reporting.

### Columns

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| order_number | NVARCHAR(50) | Unique identifier for each sales order. |
| product_key | INT | Foreign key linking to the product dimension table. |
| customer_key | INT | Foreign key linking to the customer dimension table. |
| order_date | DATE | Date when the order was placed. |
| shipping_date | DATE | Date when the order was shipped to the customer. |
| due_date | DATE | Date when the payment for the order is due. |
| sales_amount | INT | Total sales value for the line item. |
| quantity | INT | Number of units ordered. |
| price | INT | Price per unit of the product. |

---

## Summary

The **Gold Layer** serves as the final analytical layer of the data warehouse.  
It provides clean, structured data models that support:

- Business Intelligence dashboards  
- Analytical reporting  
- Customer and product insights  
- Sales performance analysis
