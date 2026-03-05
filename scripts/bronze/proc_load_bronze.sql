/*
=============================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
=============================================================

Script Purpose:
This stored procedure loads raw data into the 'bronze' schema 
from external CSV source files. The bronze layer stores the 
original, unprocessed data as received from source systems.

The procedure performs the following actions:
- Truncates existing bronze tables before loading new data.
- Uses BULK INSERT to ingest data from CSV files into bronze tables.

Parameters:
None.
This procedure does not accept parameters and does not return values.

Usage Example:
EXEC bronze.load_bronze;

Notes:
The bronze layer represents the first stage of the data pipeline,
capturing raw source data for further processing in the silver and
gold layers of the data warehouse.
=============================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME , @end_time DATETIME , @total_start_time DATETIME , @total_end_time DATETIME;
	SET @total_start_time = GETDATE();
	BEGIN TRY
		PRINT '======================================================';
		PRINT 'Loading Bronze Layer';
		PRINT '======================================================';

		PRINT'-------------------------------------------------------'
		PRINT'Loading CRM Tables';
		PRINT'-------------------------------------------------------'

		SET @start_time = GETDATE();
		PRINT'Truncating Table bronze.crm_cust_info....... ';
		TRUNCATE TABLE bronze.crm_cust_info;

		PRINT'Loading data into bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'A:\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Loading Time : ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '_____________________________'

		PRINT'Truncating Table bronze.crm_prd_info....... ';
		TRUNCATE TABLE bronze.crm_prd_info;

		SET @start_time = GETDATE();
		PRINT'Loading data into bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'A:\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Loading Time : ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '_____________________________'

		PRINT'Truncating Table bronze.crm_sales_details....... ';
		TRUNCATE TABLE bronze.crm_sales_details;

		SET @start_time = GETDATE();
		PRINT'Loading data into bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'A:\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Loading Time : ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';

		PRINT'-------------------------------------------------------'
		PRINT'Loading ERP Tables';
		PRINT'-------------------------------------------------------'

		PRINT'Truncating Table bronze.erp_cust_az12....... ';
		TRUNCATE TABLE bronze.erp_cust_az12;
		SET @start_time = GETDATE();
		PRINT'Loading data into bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'A:\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Loading Time : ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '_____________________________'

		PRINT'Truncating Table bronze.erp_loc_a101....... ';
		TRUNCATE TABLE bronze.erp_loc_a101;
		SET @start_time = GETDATE();
		PRINT'Loading data into bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'A:\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Loading Time : ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '_____________________________'


		PRINT'Truncating Table bronze.erp_px_cat_g1v2....... ';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		SET @start_time = GETDATE();
		PRINT'Loading data into bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'A:\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Loading Time : ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '_____________________________'
	END TRY
	BEGIN CATCH
			PRINT '========================================================';
			PRINT'ERROR OCCURED DURING LOADING BRONZE LAYER';
			PRINT 'ERROR MESSAGE' + ERROR_MESSAGE();
			PRINT 'ERROR MESSAGE' + CAST (ERROR_NUMBER() AS NVARCHAR);
			PRINT 'ERROR MESSAGE' + CAST(ERROR_STATE() AS NVARCHAR);
			PRINT '========================================================';
	END CATCH
	SET @total_end_time = GETDATE();
PRINT'Total time taken for loading bronze layer was ' + CAST(DATEDIFF(second, @total_start_time, @total_end_time ) AS NVARCHAR) + 'seconds';
END

