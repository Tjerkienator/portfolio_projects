/* 

Data Exploration using SQL Queries

*/

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
ORDER BY 3 DESC

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

------------------------------------------------------------------------------------------

-- Joining Tables --

-- Joining tables to see the tweet sentiment next to all other tweet data

SELECT tweet_data.*, tweet_sentiment.tweetSentiment
FROM tweet_data
JOIN tweet_sentiment ON tweet_data.tweetId = tweet_sentiment.tweetId

------------------------------------------------------------------------------------------

-- Sentiment --

-- Average of engagement metrics per type of tweet sentiment
-- Shows what type of sentiment has what effect to a tweets engagement

SELECT DISTINCT(tweet_sentiment.tweetSentiment) AS sentiment, 
ROUND((COUNT(tweet_sentiment.tweetSentiment)/(SELECT COUNT(*) FROM tweet_sentiment)*100), 2) AS percentage_of_tweets,
ROUND(AVG(tweet_data.likeCount),0) AS avg_likes,
ROUND(AVG(tweet_data.replyCount),0) AS avg_replies,
ROUND(AVG(tweet_data.retweetCount),0) AS avg_retweets
FROM tweet_data
JOIN tweet_sentiment ON tweet_data.tweetId = tweet_sentiment.tweetId
GROUP BY sentiment
ORDER BY 3 DESC

------------------------------------------------------------------------------------------

-- CTE --

-- Creating CTE called positive_tweets

WITH positive_tweets AS (
SELECT tweet_data.tweetId, tweet_data.tweetLength, tweet_data.tweetLanFull, tweet_sentiment.tweetSentiment AS tweetSentiment
FROM tweet_data
JOIN tweet_sentiment ON tweet_data.tweetId = tweet_sentiment.tweetId
WHERE tweetSentiment = "positive")


-- Selecting English tweets only

SELECT *
FROM positive_tweets
-- WHERE tweetLanFull = "English"

------------------------------------------------------------------------------------------

-- TEMP TABLE --

-- Creating a TEMP TABLE to do further calculations

DROP TEMPORARY TABLE IF EXISTS positive_tweets;

CREATE TEMPORARY TABLE positive_tweets
(
tweetId bigint,
tweetLength integer,
tweetLanFull varchar(150),
tweetSentiment varchar(100)
)


INSERT INTO positive_tweets
SELECT tweet_data.tweetId, tweet_data.tweetLength, tweet_data.tweetLanFull, tweet_sentiment.tweetSentiment AS tweetSentiment
FROM tweet_data
JOIN tweet_sentiment ON tweet_data.tweetId = tweet_sentiment.tweetId
WHERE tweetSentiment = "positive"

-- Selecting English tweets only

SELECT *
FROM positive_tweets
WHERE tweetLanFull = "English"

------------------------------------------------------------------------------------------

-- CREATING VIEW --

CREATE VIEW positive_tweets AS 