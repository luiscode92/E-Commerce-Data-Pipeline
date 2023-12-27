-- TODO: This query will return a table with the differences between the real 
-- and estimated delivery times by month and year. It will have different 
-- columns: month_no, with the month numbers going from 01 to 12; month, with 
-- the 3 first letters of each month (e.g. Jan, Feb); Year2016_real_time, with 
-- the average delivery time per month of 2016 (NaN if it doesn't exist); 
-- Year2017_real_time, with the average delivery time per month of 2017 (NaN if 
-- it doesn't exist); Year2018_real_time, with the average delivery time per 
-- month of 2018 (NaN if it doesn't exist); Year2016_estimated_time, with the 
-- average estimated delivery time per month of 2016 (NaN if it doesn't exist); 
-- Year2017_estimated_time, with the average estimated delivery time per month 
-- of 2017 (NaN if it doesn't exist) and Year2018_estimated_time, with the 
-- average estimated delivery time per month of 2018 (NaN if it doesn't exist).
-- HINTS
-- 1. You can use the julianday function to convert a date to a number.
-- 2. order_status == 'delivered' AND order_delivered_customer_date IS NOT NULL
-- 3. Take distinct order_id.

SELECT 
	STRFTIME("%m", oo.order_purchase_timestamp) AS month_no,
    CASE
        WHEN STRFTIME("%m", oo.order_purchase_timestamp) = '01' THEN 'Jan'
        WHEN STRFTIME("%m", oo.order_purchase_timestamp) = '02' THEN 'Feb'
        WHEN STRFTIME("%m", oo.order_purchase_timestamp) = '03' THEN 'Mar'
        WHEN STRFTIME("%m", oo.order_purchase_timestamp) = '04' THEN 'Apr'
        WHEN STRFTIME("%m", oo.order_purchase_timestamp) = '05' THEN 'May'
        WHEN STRFTIME("%m", oo.order_purchase_timestamp) = '06' THEN 'Jun'
        WHEN STRFTIME("%m", oo.order_purchase_timestamp) = '07' THEN 'Jul'
        WHEN STRFTIME("%m", oo.order_purchase_timestamp) = '08' THEN 'Aug'
        WHEN STRFTIME("%m", oo.order_purchase_timestamp) = '09' THEN 'Sep'
        WHEN STRFTIME("%m", oo.order_purchase_timestamp) = '10' THEN 'Oct'
        WHEN STRFTIME("%m", oo.order_purchase_timestamp) = '11' THEN 'Nov'
        WHEN STRFTIME("%m", oo.order_purchase_timestamp) = '12' THEN 'Dec'
        ELSE ''
    END AS month,
    AVG(
    	CASE
    		WHEN STRFTIME("%Y", oo.order_purchase_timestamp) = "2016"
    		THEN JULIANDAY(oo.order_delivered_customer_date) - JULIANDAY(oo.order_purchase_timestamp)
    		ELSE NULL
    	END
    ) AS Year2016_real_time,
    AVG(
    	CASE
    		WHEN STRFTIME("%Y", oo.order_purchase_timestamp) = "2017"
    		THEN JULIANDAY(oo.order_delivered_customer_date) - JULIANDAY(oo.order_purchase_timestamp)
    		ELSE NULL
    	END
    ) AS Year2017_real_time,
    AVG(
    	CASE
    		WHEN STRFTIME("%Y", oo.order_purchase_timestamp) = "2018"
    		THEN JULIANDAY(oo.order_delivered_customer_date) - JULIANDAY(oo.order_purchase_timestamp)
    		ELSE NULL
    	END
    ) AS Year2018_real_time,
    AVG(
    	CASE
    		WHEN STRFTIME("%Y", oo.order_purchase_timestamp) = "2016"
    		THEN JULIANDAY(oo.order_estimated_delivery_date) - JULIANDAY(oo.order_purchase_timestamp)
    		ELSE NULL
    	END
    ) AS Year2016_estimated_time,
    AVG(
    	CASE
    		WHEN STRFTIME("%Y", oo.order_purchase_timestamp) = "2017"
    		THEN JULIANDAY(oo.order_estimated_delivery_date) - JULIANDAY(oo.order_purchase_timestamp)
    		ELSE NULL
    	END
    ) AS Year2017_estimated_time,
    AVG(
    	CASE
    		WHEN STRFTIME("%Y", oo.order_purchase_timestamp) = "2018"
    		THEN JULIANDAY(oo.order_estimated_delivery_date) - JULIANDAY(oo.order_purchase_timestamp)
    		ELSE NULL
    	END
    ) AS Year2018_estimated_time
FROM olist_orders oo
WHERE 
	oo.order_status = 'delivered' AND 
	oo.order_delivered_customer_date IS NOT NULL
GROUP BY month_no