CREATE OR REPLACE VIEW "Sales_history"
AS WITH e_comerce_sales_history AS (
         SELECT ecd."Customer ID",
            ecd."Customer Name",
            to_timestamp(ecd."Purchase Date"::text, 'DD.MM.YYYY HH24:MI'::text) AS "Purchase Datetime",
            ecd."Product Category",
            ecd."Total Purchase Amount",
            row_number() OVER (
            	PARTITION BY ecd."Customer ID" 
            	ORDER BY (to_timestamp(ecd."Purchase Date"::text, 'DD.MM.YYYY HH24:MI'::text))
            	) AS "Purchase Sequence",
            lag(to_timestamp(ecd."Purchase Date"::text, 'DD.MM.YYYY HH24:MI'::text), 1) OVER (
            	PARTITION BY ecd."Customer ID" 
            	ORDER BY (to_timestamp(ecd."Purchase Date"::text, 'DD.MM.YYYY HH24:MI'::text))
            	) AS "Previous Purchase Date"
           FROM "E-comerce".e_comerce_data ecd
        )
 SELECT "Customer ID",
    "Customer Name",
    "Purchase Sequence",
    to_char("Purchase Datetime", 'DD.MM.YYYY HH24:MI'::text) AS "Purchase Date",
    "Product Category",
    "Total Purchase Amount",
        CASE
            WHEN "Previous Purchase Date" IS NULL THEN 'First Purchase'::text
            ELSE to_char("Previous Purchase Date", 'DD.MM.YYYY HH24:MI'::text)
        END AS "Previous Purchase Status",
        CASE
            WHEN "Previous Purchase Date" IS NULL THEN NULL::numeric
            ELSE EXTRACT(day FROM "Purchase Datetime" - "Previous Purchase Date")
        END AS "Days since last purchase"
   FROM e_comerce_sales_history
  ORDER BY "Customer ID", "Purchase Sequence";
