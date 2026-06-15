CREATE OR REPLACE VIEW "Customer category spending"
AS WITH customer_category_spending AS (
         SELECT ecd."Customer ID",
            ecd."Customer Name",
            ecd."Product Category",
            sum(ecd."Total Purchase Amount") AS "Total Spend"
           FROM "E-comerce".e_comerce_data ecd
          GROUP BY ecd."Customer ID", ecd."Customer Name", ecd."Product Category"
        ), 
        ranked_categories AS (
         SELECT customer_category_spending."Customer ID",
            customer_category_spending."Customer Name",
            customer_category_spending."Product Category",
            customer_category_spending."Total Spend",
            dense_rank() OVER (
            	PARTITION BY customer_category_spending."Customer ID" 
            	ORDER BY customer_category_spending."Total Spend" desc
            	) AS "Category Rank"
         FROM customer_category_spending
        )
 SELECT "Customer ID",
    "Customer Name",
    "Product Category",
    "Total Spend",
    "Category Rank"
   FROM ranked_categories
  ORDER BY "Total Spend" DESC;
