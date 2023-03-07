/* 

Data Exploration using SQL Queries

*/


------------------------------------------------------------------------------------------

-- Selecting data we are going to start with

SELECT 

-- Language used / total tweets
-- Shows to what percentage the language was used on the total amount of tweets


SELECT DISTINCT(tweetLanFull) AS tweet_language, ROUND((COUNT(tweetLanFUll)/(SELECT COUNT(*) FROM tweet_data)*100), 2) AS percentage_of_tweets
FROM tweet_data
GROUP BY tweetLanFull
ORDER BY 2 DESC


-- Average of engagement metrics per language
-- Shows what language is most popular among Musks followers

SELECT DISTINCT(tweetLanFull), COUNT(tweetLanFUll) AS times_used, AVG(likeCount), AVG(replyCount), AVG(retweetCount)
FROM tweet_data
GROUP BY tweetLanFull
ORDER BY 2 DESC
