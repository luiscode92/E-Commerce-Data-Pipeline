-- TODO: This query will return a table with the revenue by month and year. It
-- will have different columns: month_no, with the month numbers going from 01
-- to 12; month, with the 3 first letters of each month (e.g. Jan, Feb);
-- Year2016, with the revenue per month of 2016 (0.00 if it doesn't exist);
-- Year2017, with the revenue per month of 2017 (0.00 if it doesn't exist) and
-- Year2018, with the revenue per month of 2018 (0.00 if it doesn't exist).

SELECT 
    STRFTIME("%m", x.order_delivered_customer_date) AS month_no,
    CASE
        WHEN STRFTIME("%m", x.order_delivered_customer_date) = '01' THEN 'Jan'
        WHEN STRFTIME("%m", x.order_delivered_customer_date) = '02' THEN 'Feb'
        WHEN STRFTIME("%m", x.order_delivered_customer_date) = '03' THEN 'Mar'
        WHEN STRFTIME("%m", x.order_delivered_customer_date) = '04' THEN 'Apr'
        WHEN STRFTIME("%m", x.order_delivered_customer_date) = '05' THEN 'May'
        WHEN STRFTIME("%m", x.order_delivered_customer_date) = '06' THEN 'Jun'
        WHEN STRFTIME("%m", x.order_delivered_customer_date) = '07' THEN 'Jul'
        WHEN STRFTIME("%m", x.order_delivered_customer_date) = '08' THEN 'Aug'
        WHEN STRFTIME("%m", x.order_delivered_customer_date) = '09' THEN 'Sep'
        WHEN STRFTIME("%m", x.order_delivered_customer_date) = '10' THEN 'Oct'
        WHEN STRFTIME("%m", x.order_delivered_customer_date) = '11' THEN 'Nov'
        WHEN STRFTIME("%m", x.order_delivered_customer_date) = '12' THEN 'Dec'
        ELSE ''
    END AS month,
    SUM(
        CASE
            WHEN STRFTIME("%Y", x.order_delivered_customer_date) = "2016" THEN x.payment_value
            ELSE 0.00
        END
    ) AS Year2016,
    SUM(
        CASE
            WHEN STRFTIME("%Y", x.order_delivered_customer_date) = "2017" THEN x.payment_value
            ELSE 0.00
        END
    ) AS Year2017,
    SUM(
        CASE
            WHEN STRFTIME("%Y", x.order_delivered_customer_date) = "2018" THEN x.payment_value
            ELSE 0.00
        END
    ) AS Year2018
FROM (
    SELECT
        oo.order_delivered_customer_date,
        oop.payment_value,
        ROW_NUMBER() OVER (PARTITION BY oop.order_id) AS filtering
    FROM olist_orders oo
    JOIN olist_order_payments oop ON oo.order_id = oop.order_id
    WHERE 
        oo.order_status LIKE 'delivered' AND 
        oo.order_delivered_customer_date IS NOT NULL
) x
WHERE x.filtering = 1
GROUP BY month_no
ORDER BY month_no;