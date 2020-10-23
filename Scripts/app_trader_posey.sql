--Entire Play Store data
SELECT *
FROM play_store_apps;

--Entire App store data
SELECT *
FROM app_store_apps;

--Designate category from  Play store
SELECT *
FROM play_store_apps
WHERE category = 'COMMUNICATION';

--Category listing for Play Store
SELECT DISTINCT category
FROM play_store_apps;

--Play Store apps by rating
SELECT *
FROM play_store_apps
WHERE rating IS NOT NULL
ORDER BY rating DESC;

-- Distinct Genres in APP Store
SELECT DISTINCT genres
FROM play_store_apps
ORDER BY genres;


--Play Store with review count over 10000
SELECT DISTINCT(name),category, rating, review_count, type, price, content_rating
FROM play_store_apps
WHERE review_count > 10000
ORDER BY rating DESC;

--Play Store only Sports Category
SELECT *
FROM play_store_apps
WHERE category = 'SPORTS'
AND rating IS NOT NULL
ORDER BY rating DESC;

--Play Store with over 1M reviews and rating over 4.0
SELECT *
FROM play_store_apps
WHERE rating > 4.0 
AND review_count > 1000000
ORDER BY rating DESC;


-- App store Distinct genres
SELECT DISTINCT primary_genre
FROM app_store_apps
ORDER BY primary_genre;


SELECT price, COUNT(price)
FROM app_store_apps
GROUP BY price
ORDER BY count DESC;

SELECT play_store_apps.name, play_store_apps.price , install_count
FROM play_store_apps
GROUP BY name
ORDER BY  install_count DESC;

SELECT name,category,price, rating, review_count
FROM (SELECT DISTINCT name, category, price,rating,review_count 
	  FROM play_store_apps
	  WHERE rating > 4
		AND price::money < 1:: money
		AND review_count > 100000
		AND category ILIKE 'Game') AS psa 
		 
INNER JOIN 
USING(name)
SELECT name, category price, rating, review_count
FROM (SELECT DISTINCT name, primary_genre AS category , price, rating, review_count
	  FROM app_store_apps
  	  WHERE rating > 4
		AND price::money < 1:: money
		AND review_count::numeric > 100000
	 	AND primary_genre ILIKE 'Games')  AS asa
GROUP BY name, category,price,rating,review_count
ORDER BY category, rating DESC
LIMIT 40;


WITH psa AS (SELECT name AS psa_name, category, price AS psa_price,rating AS psa_rating,
			 review_count AS psa_review_count
		  	 FROM play_store_apps
	 		 WHERE rating > 4
				AND price::money < 1:: money
				AND review_count > 100000
				AND category ILIKE 'Game'),
	 asa AS (SELECT name AS asa_name, primary_genre AS category , price AS asa_price,
			 rating AS asa_rating, review_count AS asa_review_count
	  		 FROM app_store_apps
  	  		 WHERE rating > 4
				AND price::money < 1:: money
				AND review_count::numeric > 100000
	 			AND primary_genre ILIKE 'Games')
SELECT psa_name, psa_price, psa_rating,psa_review_count,asa_price,asa_rating,asa_review_count
FROM psa 
INNER JOIN asa on psa.psa_name = asa.asa_name
GROUP BY psa_name, psa_price,psa_rating,psa_review_count,asa_price,asa_rating,asa_review_count
ORDER BY psa_name
LIMIT 200;

