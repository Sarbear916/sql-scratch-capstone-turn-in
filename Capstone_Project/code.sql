/*How many campaigns and sources does CoolTShirts use? 
Which source is used for each campaign?
Use three queries:
one for the number of distinct campaigns,
one for the number of distinct sources,
one to find how they are related. */

/* Count of Distinct Campaigns */
SELECT COUNT(DISTINCT utm_campaign)
FROM page_visits;

/* Count of Disctinct Sources */
SELECT COUNT(DISTINCT utm_source)
FROM page_visits;

/* Distinct Campaigns and Source */
SELECT DISTINCT utm_campaign, utm_source
FROM page_visits
ORDER BY 1,2;

/*What pages are on the CoolTShirts website? Find the distinct values of the page_name column. */

/*Disctinct Page Names */
SELECT DISTINCT page_name
FROM page_visits;

/* Distinct Page Names by Campaign */
SELECT DISTINCT utm_campaign, page_name
FROM page_visits;

/*How many first touches is each campaign responsible for? 
You'll need to use the first-touch query from the lesson (also provided in the hint below). Group by campaign and count the number of first touches for each.
(The hint query is more involved, but I verified I am getting the same results*/
WITH first_touch AS (
	SELECT user_id,
		MIN(timestamp) as first_touch_at
	FROM page_visits
	GROUP BY user_id)
SELECT pv.utm_source AS traffic_source,
	pv.utm_campaign AS campaign_name,
  COUNT(*) AS campaign_count
FROM first_touch AS ft
JOIN page_visits AS pv
	ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
GROUP BY pv.utm_campaign
ORDER BY campaign_count DESC;

/*How many users drop off after first touch (First and Last touch are the same?*/
WITH last_touch AS (
	SELECT user_id,
		MAX(timestamp) as last_touch_at
	FROM page_visits
	GROUP BY user_id),
first_touch AS (
	SELECT user_id,
		MIN(timestamp) as first_touch_at
	FROM page_visits
	GROUP BY user_id)
SELECT pv.utm_source AS traffic_source,
	pv.utm_campaign AS campaign_name,
  COUNT(*) AS user_dropoff
FROM last_touch AS lt, first_touch AS ft
JOIN page_visits AS pv
		ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
    AND ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
WHERE ft.first_touch_at = lt.last_touch_at
GROUP BY pv.utm_campaign
ORDER BY user_dropoff DESC;

/*How many last touches is each campaign responsible for?*/ 
/*Starting with the last-touch query from the lesson, group by campaign and count the number of last touches for each.
(The hint query is more involved, but I verified I am getting the same result)*/
WITH last_touch AS (
	SELECT user_id,
		MAX(timestamp) as last_touch_at
	FROM page_visits
	GROUP BY user_id)
SELECT pv.utm_source AS traffic_source,
	pv.utm_campaign AS campaign_name,
  COUNT(*) AS campaign_count
FROM last_touch AS lt
JOIN page_visits AS pv
		ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
GROUP BY pv.utm_campaign
ORDER BY campaign_count DESC;


/* How many visitors make a purchase? Count the distinct users who visited the page named 4 - purchase. */
SELECT COUNT(DISTINCT user_id) AS purchase_visits
FROM page_visits
WHERE page_name = '4 - purchase';

/*How many distinct users have been to the site?*/
SELECT COUNT(DISTINCT user_id) AS user_count
FROM page_visits;

/* How many last touches on the purchase page is each campaign responsible for? This query will look similar to your last-touch query, but with an additional WHERE clause. */
WITH last_touch AS (
	SELECT user_id,
		MAX(timestamp) as last_touch_at
	FROM page_visits
  	WHERE page_name = '4 - purchase'
	GROUP BY user_id)
SELECT pv.utm_source AS traffic_source,
	pv.utm_campaign AS campaign_name,
  COUNT(*) AS campaign_count
FROM last_touch AS lt
JOIN page_visits AS pv
		ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
GROUP BY pv.utm_campaign
ORDER BY campaign_count DESC;

/* Create a table layout to put all the data together */
SELECT DISTINCT utm_source AS traffic_source,utm_campaign AS campaign_name
FROM page_visits
ORDER BY 1,2;