/*
=============================================================
Create Database and Schemas
=============================================================

Script Purpose:
This script initializes the data warehouse environment by creating 
a database named 'DataWarehouse'. It first checks whether the 
database already exists. If it exists, the database is dropped 
and recreated to ensure a clean setup.

The script also creates three schemas used in the data pipeline:
- bronze  : Stores raw ingested data from source systems
- silver  : Stores cleaned and transformed data
- gold    : Stores business-ready data optimized for analytics

WARNING:
Running this script will delete the existing 'DataWarehouse' database 
if it already exists. All stored data will be permanently removed. 
Ensure that proper backups are taken before executing this script.
*/

USE master;
GO

-- Drop and recreate the 'DataWarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO

-- Create the 'DataWarehouse' database
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

--Create SChemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
