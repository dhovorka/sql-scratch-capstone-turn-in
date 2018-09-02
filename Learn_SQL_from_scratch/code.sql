How many campaigns does Cool T-Shirts have?


SELECT DISTINCT utm_campaign
FROM page_visits
ORDER BY 1 ASC;


How many sources?


SELECT DISTINCT utm_source
FROM page_visits
ORDER BY 1 ASC;


Which source is used for each campaign?


SELECT DISTINCT utm_campaign, utm_source
FROM page_visits
ORDER BY utm_source ASC;


What Pages are on the website?


SELECT DISTINCT page_name
FROM page_visits
ORDER BY page_name ASC;


How many first touches for each campaign?


WITH first_touch AS (SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id),
ft_attr AS (
  SELECT ft.user_id,
         ft.first_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM first_touch ft
  JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp)
SELECT ft_attr.utm_source,
       ft_attr.utm_campaign,
       COUNT(*)
FROM ft_attr
GROUP BY 1, 2
ORDER BY 3 DESC;


How many last touches is each campaign responsible for?


WITH last_touch AS (SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign,
         pv.page_name
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_campaign,
       COUNT(*),
       lt_attr.utm_source
FROM lt_attr
GROUP BY 3, 1
ORDER BY 2 DESC;


How many visitors make a purchase?


SELECT COUNT(DISTINCT user_id) 
AS 'unique_purchase'
FROM page_visits
WHERE page_name = '4 - purchase';


How many last touches on the purchase page, is each campaign responsible for?


WITH last_touch AS (SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    WHERE page_name = '4 - purchase'
    GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign,
         pv.page_name
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_campaign,
       COUNT(*),
       lt_attr.utm_source
FROM lt_attr
GROUP BY 3, 1
ORDER BY 2 DESC;