/*
=========================================================================================================
DDL Script: Create Silver Tables
=========================================================================================================
Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables
    if they already exist.
    Run this script to re-define the DDL structure of 'Bronze' tables.
===========================================================================================================
*/
-- create tables in silver layer

--drop table if it exists to make sure we don't have errors in our script execution while creating tables

drop table if exists silver.crm_cust_info;

create table silver.crm_cust_info(
	cst_id INTEGER,
	cst_key VARCHAR(50),
	cst_firstname VARCHAR(100),
	cst_lastname VARCHAR(100),
	cst_marital_status VARCHAR(50),
	cst_gndr VARCHAR(50),
	cst_create_date DATE,
dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
 
drop table if exists silver.crm_prd_info;

create table silver.crm_prd_info(
	prd_id INTEGER,
	prd_key VARCHAR(50),
	cat_id VARCHAR(50),
	prd_key_clean VARCHAR(50),
	prd_nm VARCHAR(100),
	prd_cost INTEGER,
	prd_line VARCHAR(100),
	prd_start_dt DATE,
	prd_end_dt DATE,
dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

drop table if exists silver.crm_sales_details;

create table silver.crm_sales_details(
	sls_ord_num VARCHAR(50),
	sls_prd_key VARCHAR(50),
	sls_cust_id VARCHAR(50),
	sls_order_dt DATE,
	sls_ship_dt DATE,
	sls_due_dt DATE,
	sls_sales INTEGER,
	sls_quantity INTEGER,
	sls_price INTEGER,
	dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- create erp tables

drop table if exists silver.erp_cust_az12;

create table silver.erp_cust_az12(
	cid VARCHAR(50),
	bdate DATE,
	gen VARCHAR(50),
	dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

drop table if exists silver.erp_loc_a101;

create table silver.erp_loc_a101(
	cid VARCHAR(50),
	cntry VARCHAR(50),
	dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

drop table if exists silver.erp_px_cat_g1v2;

create table silver.erp_px_cat_g1v2(
	id VARCHAR(50),
	cat VARCHAR(100),
	subcat VARCHAR(100),
	maintenance VARCHAR(50),
	dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
