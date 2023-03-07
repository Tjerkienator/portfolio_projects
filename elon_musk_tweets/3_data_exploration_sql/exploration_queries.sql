/* 

Data Exploration using SQL Queries

*/

SELECT *
FROM tweet_data

------------------------------------------------------------------------------------------

-- LANGUAGE --

-- Language used / total tweets
-- Shows to what percentage the language was used on the total amount of tweets

SELECT DISTINCT(tweetLanFull) AS tweet_language, 
ROUND((COUNT(tweetLanFUll)/(SELECT COUNT(*) FROM tweet_data)*100), 2) AS percentage_of_tweets
FROM tweet_data
GROUP BY tweetLanFull
ORDER BY 2 DESC

-- Average of engagement metrics per language
-- Shows what language is most popular among Musks followers

SELECT DISTINCT(tweetLanFull), 
ROUND((COUNT(tweetLanFUll)/(SELECT COUNT(*) FROM tweet_data)*100), 2) AS percentage_of_tweets,
ROUND(AVG(likeCount),0) AS avg_likes,
ROUND(AVG(replyCount),0) AS avg_replies,
ROUND(AVG(retweetCount),0) AS avg_retweets
FROM tweet_data
GROUP BY tweetLanFull
ORDER BY 2 DESC, 3 DESC

------------------------------------------------------------------------------------------

-- URL --

-- Average of engagement metrics per URL value
-- Shows if adding a URL is of any effect to a tweets engagement

SELECT DISTINCT(URL), 
ROUND((COUNT(URL)/(SELECT COUNT(*) FROM tweet_data)*100), 2) AS percentage_of_tweets,
ROUND(AVG(likeCount),0) AS avg_likes,
ROUND(AVG(replyCount),0) AS avg_replies,
ROUND(AVG(retweetCount),0) AS avg_retweets
FROM tweet_data
GROUP BY URL
ORDER BY 2 DESC, 3 DESC

------------------------------------------------------------------------------------------

-- Attachments --

-- Average of engagement metrics per type of attachment
-- Shows what type of attachment has what effect to a tweets engagement

SELECT DISTINCT(tweetAttachment), 
ROUND((COUNT(tweetAttachment)/(SELECT COUNT(*) FROM tweet_data)*100), 2) AS percentage_of_tweets,
ROUND(AVG(likeCount),0) AS avg_likes,
ROUND(AVG(replyCount),0) AS avg_replies,
ROUND(AVG(retweetCount),0) AS avg_retweets
FROM tweet_data
GROUP BY tweetAttachment
ORDER BY 3 DESC
