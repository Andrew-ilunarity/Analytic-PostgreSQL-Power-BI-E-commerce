CREATE OR REPLACE VIEW return_rate
AS WITH return_rate AS (
         SELECT
         	CASE
            	WHEN ecd."Returns" IS NULL THEN 0::real
                ELSE ecd."Returns"
            END AS "Return",
            ecd."Product Category",
            to_timestamp(ecd."Purchase Date"::text, 'DD.MM.YYYY HH24:MI'::text) AS "Date"
           FROM "E-comerce".e_comerce_data ecd
        )
 SELECT "Return",
    "Product Category",
    "Date"
   FROM return_rate rr
  GROUP BY "Return", "Date", "Product Category";
