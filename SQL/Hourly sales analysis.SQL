CREATE OR REPLACE VIEW v_hourly_sales_analysis
AS WITH parsed_data AS (
         SELECT to_timestamp(e_comerce_data."Purchase Date"::text, 'DD.MM.YYYY HH24:MI'::text) AS clean_datetime,
            e_comerce_data."Customer ID"
           FROM "E-comerce".e_comerce_data
        )
 SELECT 
 	EXTRACT(hour FROM clean_datetime) AS purchase_hour,
    EXTRACT(year FROM clean_datetime) AS purchase_year,
    EXTRACT(month FROM clean_datetime) AS purchase_month,
    clean_datetime::date AS clean_datetime,
    "Customer ID"
FROM parsed_data;
