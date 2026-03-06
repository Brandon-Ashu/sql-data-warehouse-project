/*
========================================================================================
Stored Procedure: Load Silver  Layer(Bronze -> Silver)
========================================================================================
Script Purpose:
    This stored procedure performs ETL(Extract,Transform,Load) process to populate the 
    'silver' schema tables from the 'bronze' schema.
  Actions performed:
    - Truncates silver tables.
    - Insert transformed and cleansed data from Bronze into Silver tables.

Parameters:
  None.
  This stored procedure does not accept any parameters or return any values

Usage Example:
  Call silver.load_silver();
===========================================================================================
*/

CREATE OR REPLACE PROCEDURE silver.load_silver()
LANGUAGE plpgsql
AS $$
DECLARE
    v_row_count INTEGER;
    v_start_time TIMESTAMP;
	    -- Start transaction
BEGIN
	        v_start_time := NOW();
	        RAISE NOTICE 'Starting silver layer load at %', v_start_time;
	
	--================================================================================================
	--Insert Data into silver.crm_cust_info
	--================================================================================================
	RAISE NOTICE 'Loading silver.crm_cust_info...';
	
	truncate table silver.crm_cust_info;
	
	insert into silver.crm_cust_info(
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date)
	
	select 
		cst_id,
		cst_key,
		trim(cst_firstname) as cst_firstname,
		trim(cst_lastname) as cst_lastname,
		case when upper(trim(cst_marital_status)) = 'M' then 'Married'
		     when upper(trim(cst_marital_status)) = 'S' then 'Single' 
		     else 'Unknown' end as cst_marital_status,
		case when upper(trim(cst_gndr)) = 'F' then 'Female'
			 when upper(trim(cst_gndr)) = 'M' then 'Male'
			 else 'Unknown'end as cst_gndr,
		cst_create_date 
		from (select *,
		row_number() over(partition by cst_id order by cst_create_date desc ) as flag_last
		from bronze.crm_cust_info
		where cst_id is not null)t
		where flag_last = 1;
	
	GET DIAGNOSTICS v_row_count = ROW_COUNT;
	        RAISE NOTICE '  Loaded % rows', v_row_count;
	
	--========================================================================================
	--Insert Data into silver.crm_prd_info
	--========================================================================================
	RAISE NOTICE 'Loading silver.crm_prd_info...';
	
	truncate table silver.crm_prd_info;
	
	insert into silver.crm_prd_info(
	
		prd_id,
		prd_key,
		cat_id,
		prd_key_clean,
		prd_nm,
		prd_cost,
		prd_line,
		prd_start_dt,
		prd_end_dt)
	
	
		select 
			prd_id,
			prd_key,
			replace(substring(prd_key,1,5), '-', '_') as cat_id,
			substring(prd_key,7,length(prd_key)) as prd_key,
			prd_nm,
			coalesce(prd_cost,0) as prd_cost,
			case UPPER(TRIM(prd_line))
				 when 'M' then 'Mountain'
				 when 'R' then 'Road'
				 when 'S' then 'Other sales'
				 when 'T' then 'Touring'
				 else 'Unknown' end as prd_line,
			prd_start_dt,
			lead(prd_start_dt) over(partition by prd_key order by prd_start_dt)-1 as prd_end_dt
		from bronze.crm_prd_info;
		
		GET DIAGNOSTICS v_row_count = ROW_COUNT;
	        RAISE NOTICE '  Loaded % rows', v_row_count;
	
	--================================================================================================
	-- Insert Data into silver.crm_sales_details
	--================================================================================================
	RAISE NOTICE 'Loading silver.sales_details...';
	
	truncate table silver.crm_sales_details;
	
	insert into silver.crm_sales_details (
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		sls_order_dt,
		sls_ship_dt,
		sls_due_dt,
		sls_sales,
		sls_quantity,
		sls_price)
		
	select 
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			case when sls_order_dt = 0 or length(sls_order_dt::text) !=8 then null
			else to_date(sls_order_dt::text, 'YYYYMMDD') end as sls_order_dt,
			case when sls_ship_dt = 0 or length(sls_ship_dt::text) !=8 then null
			else to_date(sls_ship_dt::text, 'YYYYMMDD') end as sls_ship_dt,
			case when sls_due_dt = 0 or length(sls_due_dt::text) !=8 then null
			else to_date(sls_due_dt::text, 'YYYYMMDD') end as sls_due_dt,
			case when sls_sales is null or sls_sales <=0 or sls_sales != sls_quantity * abs(sls_price)
				then sls_quantity * abs(sls_price)
			else sls_sales
			end as sls_sales,
			sls_quantity,
			case when sls_price is null or sls_price <=0
				then sls_sales / nullif(sls_quantity,0)
			else sls_price
			end as sls_price
		from bronze.crm_sales_details;
	
	GET DIAGNOSTICS v_row_count = ROW_COUNT;
	        RAISE NOTICE '  Loaded % rows', v_row_count;
	
	--=========================================================================================================
	-- Insert into silver.erp_cust_az12
	--=========================================================================================================
	RAISE NOTICE 'Loading silver.erp_cust_az12...';
	
	truncate table silver.erp_cust_az12;
	
	insert into silver.erp_cust_az12(
	    cid,
		bdate,
		gen
	) 
	
	select 
	case when cid like 'NAS%' then substr(cid,4, length(cid))
	 else cid
	end as cid,
	case when bdate > current_date then null
		else bdate
	end as bdate,
	case when UPPER(TRIM(gen)) in ('M','MALE') then 'Male'
		when upper(trim(gen)) in ('F','FEMALE') then  'Female'
	else 'Unknown' end as gen
	from bronze.erp_cust_az12;
	
	GET DIAGNOSTICS v_row_count = ROW_COUNT;
	        RAISE NOTICE '  Loaded % rows', v_row_count;
	
	--===========================================================================================
	-- Insert into silver.erp_loc_a101
	--===========================================================================================
	RAISE NOTICE 'Loading silver.erp_loc_a101...';
	
	truncate table silver.erp_loc_a101;
	
	insert into silver.erp_loc_a101(
	cid,
	cntry
	)
	
	select 
	replace(cid, '-', '') as cid,
	case when trim(cntry) = 'DE' then 'Germany'
		 when trim(cntry) in ('US','USA') then 'United States'
		 when trim(cntry) = '' or trim(cntry) is null then 'Unknown'
	     else trim(cntry)
	end as cntry
	from bronze.erp_loc_a101;
	
	GET DIAGNOSTICS v_row_count = ROW_COUNT;
	        RAISE NOTICE '  Loaded % rows', v_row_count;
	
	--===========================================================================================
	-- Insert into silver.erp_px_cat_g1v2
	--===========================================================================================
	RAISE NOTICE 'Loading silver.erp_px_cat_g1v2...';
	
	truncate table silver.erp_px_cat_g1v2;
	
	insert into silver.erp_px_cat_g1v2 (
	id,
	cat,
	subcat,
	maintenance
	)
	
	select 
	id,
	cat,
	subcat,
	maintenance
	from bronze.erp_px_cat_g1v2 ;
	
	GET DIAGNOSTICS v_row_count = ROW_COUNT;
	        RAISE NOTICE '  Loaded % rows', v_row_count;
	        
	        RAISE NOTICE 'Silver layer load completed successfully at %', NOW();
	        RAISE NOTICE 'Total duration: % seconds', EXTRACT(EPOCH FROM (NOW() - v_start_time));
	        
	    EXCEPTION WHEN OTHERS THEN
	        RAISE NOTICE 'ERROR: %', SQLERRM;
	        RAISE;
END;
$$;
