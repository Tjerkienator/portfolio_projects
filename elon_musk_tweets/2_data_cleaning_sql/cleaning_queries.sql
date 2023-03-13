/* 

Cleaning Data using SQL Queries

*/


------------------------------------------------------------------------------------------

-- Looking at both tables after importing them into SQLPro from CSV files


SELECT * 
FROM tweet_data

SELECT * 
FROM tweet_sentiment


------------------------------------------------------------------------------------------

-- Changing tweetAttachments value

SELECT DISTINCT(tweetAttachment), COUNT(tweetAttachment)
FROM tweet_Data
GROUP BY tweetAttachment
ORDER BY tweetAttachment

SELECT *
FROM tweet_data
WHERE LENGTH(tweetAttachment) = 0

-- Looking at the results of above queries, I can conclude that there are 2 types of tweetAttachments. "media_keys" which stands a media file, and "poll_ids" which stands for a Twitter poll. The 3rd available variable is null, which provides us with 311 rows. Somehow "WHERE tweetAttachement IS NULL" isn't showing the 311 results, so I used a LENGTH function instead.

-- Next step will be to change the different kind of tweetAttachments in easy to understand values

UPDATE tweet_data
SET tweet_data.tweetAttachment = CASE 
WHEN LENGTH(tweetAttachment) = 0 THEN "None"
WHEN tweetAttachment LIKE "%media_keys%" THEN "Media"
WHEN tweetAttachment LIKE "%poll_ids%" THEN "Poll"
ELSE "None"
END

------------------------------------------------------------------------------------------

-- Adding New Column --

-- I would like to add another column displaying which tweetText contains a url (https). The value of this new column will be a boolean

SELECT tweetText
FROM tweet_data
WHERE tweetText LIKE "%https%"

-- Above query shows 199 records. I will now add a new column

ALTER TABLE tweet_data
ADD COLUMN URL VARCHAR(8)

SELECT tweetId, URL
FROM tweet_data LIMIT 10

-- URL column created successfuly. Adding True, False values next

UPDATE tweet_data
SET URL = IF(tweetText LIKE "%https%", "Yes", "No")

------------------------------------------------------------------------------------------

-- SETTING tweetLanFull VALUES -- 

-- I want to make the different tweetLanguage abbreviation easier to read and recognize.

SELECT DISTINCT(tweetLanguage), COUNT(tweetLanguage)
FROM tweet_data
GROUP BY tweetLanguage
ORDER BY 2 DESC

ALTER TABLE tweet_data
ADD COLUMN tweetLanFull VARCHAR(50)

UPDATE tweet_data
SET tweetLanFull = CASE
WHEN tweetLanguage = "en" THEN "English"
WHEN tweetLanguage = "zxx" THEN "No linguistic content"
WHEN tweetLanguage = "und" THEN "Undefined"
WHEN tweetLanguage = "qst" THEN "Very short text"
WHEN tweetLanguage = "art" THEN "Artificial"
WHEN tweetLanguage = "fr" THEN "French"
WHEN tweetLanguage = "in" THEN "Indonesian"
WHEN tweetLanguage = "pt" THEN "Portuguese"
WHEN tweetLanguage = "it" THEN "Italien"
WHEN tweetLanguage = "et" THEN "Estonian"
WHEN tweetLanguage = "ca" THEN "Catalan"
WHEN tweetLanguage = "ht" THEN "Haitian"
WHEN tweetLanguage = "el" THEN "Modern Greek"
ELSE "Unknown"
END;

SELECT tweetText, tweetLanguage, tweetLanFull
FROM tweet_data

------------------------------------------------------------------------------------------

-- MISSING DATA --

-- impressionCount --

-- The column impressionCount misses data for a large amount of tweets. I want to determine if I should remove the column or ignore the missing data.

SELECT (
	(SELECT COUNT(impressionCount)
	FROM tweet_data
	WHERE impressionCount = 0)
	/
	(SELECT COUNT(impressionCount)
	FROM tweet_data
	WHERE NOT impressionCount IS NULL)) * 100 
AS missing_data_percentage

-- Above query shows that over 61% of records are missing data for impressionCount, therefor I decide to drop that column as it has no use in the later data analysis.

ALTER TABLE tweet_data
DROP COLUMN impressionCount
	
------------------------------------------------------------------------------------------

-- DROPPING COLUMNS -- 

-- conversationId -- 

-- I want to see if all the conversationIds are equal to their corresponding tweetId. If they are all the same we know the conversationId column can be deleted.

SELECT tweetId, conversationId
FROM tweet_data
WHERE NOT tweetId = conversationId

-- As above query gives us 0 records we can continue and drop the conversationId column

ALTER TABLE tweet_data
DROP COLUMN conversationId

-- replyToUserId -- 

-- I want to see if there are any rows with where LENGTH(value) is larger than 0

SELECT replyToUserId
FROM tweet_data
WHERE LENGTH(replyToUserId) > 0

-- As above query gives us 0 records we can continue and drop the replyToUserId column

ALTER TABLE tweet_data
DROP COLUMN replyToUserId

-- possiblySensitive -- 

-- I want to see if any other value than FALSE for possiblySensitive

SELECT DISTINCT(possiblySensitive), COUNT(possiblySensitive)
FROM tweet_data
GROUP BY possiblySensitive

-- As above query shows us that all values are FALSE we can continue and drop the replyToUserId column

ALTER TABLE tweet_data
DROP COLUMN possiblySensitive

------------------------------------------------------------------------------------------

-- tweet_sentiment table -- 

-- tweetSentiment -- 

-- I need to clean up the tweetSentiment column because not all cells contain workable values. 

SELECT *
FROM tweet_sentiment

SELECT DISTINCT(tweetSentiment), COUNT(tweetSentiment)
FROM tweet_sentiment
GROUP BY tweetSentiment
ORDER BY 2 DESC

ALTER TABLE tweet_sentiment
ADD COLUMN sentimentNew VARCHAR(30)

UPDATE tweet_sentiment
SET sentimentNew = CASE
WHEN tweetSentiment LIKE "%negative%" THEN "negative"
WHEN tweetSentiment LIKE "%positive%" THEN "positive"
WHEN tweetSentiment LIKE "%neutral%" THEN "neutral"
ELSE "unknown"
END;

ALTER TABLE tweet_sentiment
DROP COLUMN tweetSentiment

SELECT DISTINCT(sentimentNew), COUNT(sentimentNew)
FROM tweet_sentiment
GROUP BY sentimentNew
ORDER BY 2 DESC

ALTER TABLE tweet_sentiment
RENAME COLUMN sentimentNew TO tweetSentiment

------------------------------------------------------------------------------------------

-- DELETING ROWS -- 

-- I will remove all rows that have tweetSentiment = "unknown" as value.

DELETE FROM tweet_sentiment
WHERE tweetSentiment = "unknown"

------------------------------------------------------------------------------------------