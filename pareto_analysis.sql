WITH	city_sales AS (
    SELECT 
        c.customer_city,
        SUM(oi.price) AS city_revenue
    FROM olist_project.olist_orders_dataset o
    JOIN olist_project.olist_customers_dataset c ON o.customer_id = c.customer_id
    JOIN olist_project.olist_order_items_dataset oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_city
),
		ranked_sales AS (
    SELECT 
        customer_city,
        city_revenue,
        SUM(city_revenue) OVER() AS total_global_revenue,
        SUM(city_revenue) OVER(ORDER BY city_revenue DESC) AS running_total_revenue
    FROM city_sales
)
SELECT 
    customer_city,
    city_revenue,
    (city_revenue / total_global_revenue) * 100 AS pct_of_total,
    (running_total_revenue / total_global_revenue) * 100 AS cumulative_pct
FROM ranked_sales
ORDER BY city_revenue DESC
