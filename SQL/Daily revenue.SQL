CREATE OR REPLACE VIEW "Daily revenue"
AS WITH daily_revenue AS (
         SELECT to_timestamp(ecd."Purchase Date"::text, 'DD.MM.YYYY HH24:MI'::text)::date AS "Purchase Day",
            sum(ecd."Total Purchase Amount") AS "Revenue"
           FROM "E-comerce".e_comerce_data ecd
          GROUP BY (to_timestamp(ecd."Purchase Date"::text, 'DD.MM.YYYY HH24:MI'::text)::date)
        )
 SELECT "Purchase Day",
    "Revenue",
    sum("Revenue") OVER (
    	ORDER BY "Purchase Day"
    	)::real AS "Running Total",
    avg("Revenue") OVER (
    	ORDER BY "Purchase Day" 
    	ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    )::real AS "Rolling avg 7 days"
   FROM daily_revenue
  ORDER BY "Purchase Day";
