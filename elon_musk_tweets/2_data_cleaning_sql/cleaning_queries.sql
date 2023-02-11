/* 

Cleaning Data in SQL Queries

*/


------------------------------------------------------------------------------------------

-- Looking at both tables after importing them into Big Queary from CSV files --


SELECT *
FROM `concrete-tuner-297911.musktweetdata.musk_tweet_Data`

SELECT *
FROM `concrete-tuner-297911.musktweetdata.tweet_sentiment`


------------------------------------------------------------------------------------------

-- Changing tweetAttachments value --

SELECT DISTINCT(tweetAttachments), COUNT(tweetAttachments)
FROM `concrete-tuner-297911.musktweetdata.musk_tweet_Data`
GROUP BY tweetAttachments
ORDER BY tweetAttachments

SELECT tweetId, tweetAttachments
FROM `concrete-tuner-297911.musktweetdata.musk_tweet_Data`
WHERE tweetAttachments IS NULL

-- Looking at the results of above queries, I can conclude that there are 2 types of tweetAttachments. "media_keys" which stands a media file, and "poll_ids" which stands for a Twitter poll. The 3rd available variable is null, which provides us with 311 rows -- 

UPDATE `musktweetdata.musk_tweet_Data`
SET tweetAttachements = "None"
WHERE tweetAttachements IS NULL
