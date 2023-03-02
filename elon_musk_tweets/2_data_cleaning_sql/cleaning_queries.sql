/* 

Cleaning Data in SQL Queries

*/


------------------------------------------------------------------------------------------

-- Looking at both tables after importing them into Big Queary from CSV files --


SELECT * 
FROM tweet_data

SELECT * 
FROM tweet_sentiment


------------------------------------------------------------------------------------------

-- Changing tweetAttachments value --

SELECT DISTINCT(tweetAttachment), COUNT(tweetAttachment)
FROM tweet_Data
GROUP BY tweetAttachment
ORDER BY tweetAttachment

SELECT *
FROM tweet_data
WHERE LENGTH(tweetAttachment) = 0

-- Looking at the results of above queries, I can conclude that there are 2 types of tweetAttachments. "media_keys" which stands a media file, and "poll_ids" which stands for a Twitter poll. The 3rd available variable is null, which provides us with 311 rows. Somehow "WHERE tweetAttachement IS NULL" isn't showing the 311 results, so I used a LENGTH function instead. -- 

-- Next step will be to change the different kind of tweetAttachments in easy to understand values -- 

UPDATE tweet_data
SET tweetAttachment = IF(LENGTH(tweetAttachment) = 0, "None", IF(tweetAttachment LIKE "%media_keys%", "Media", IF(tweetAttachment LIKE "%poll_ids%", "Poll", "None")))

------------------------------------------------------------------------------------------

-- Adding New Column --

-- I would like to add another column displaying which tweetText contains a url (https). The value of this new column will be a boolean -- 

SELECT tweetText
FROM tweet_data
WHERE tweetText LIKE "%https%"

-- Above query shows 199 records. I will now add a new column -- 

ALTER TABLE tweet_data
ADD COLUMN URL VARCHAR(8)

SELECT tweetId, URL
FROM tweet_data LIMIT 10

-- URL column created successfuly. Adding True, False values next -- 

UPDATE tweet_data
SET URL = IF(tweetText LIKE "%https%", "Yes", "No")

------------------------------------------------------------------------------------------

-- SETTING tweetLanFull VALUES -- 

-- I want to make the different tweetLanguage abbreviation easier to read and recognize. -- 

SELECT DISTINCT(tweetLanguage), COUNT(tweetLanguage)
FROM tweet_data
GROUP BY tweetLanguage
ORDER BY 2 DESC

ALTER TABLE tweet_data
ADD COLUMN tweetLanFull VARCHAR(50)

UPDATE tweet_data
SET tweetLanFull = 
IF(tweetLanguage = "en", "English", 
IF(tweetLanguage = "zxx", "No linguitic content",
IF(tweetLanguage = "und", "Undefined",
IF(tweetLanguage = "qst", "Very short text",
IF(tweetLanguage = "art", "Artificial",
IF(tweetLanguage = "fr", "French",
IF(tweetLanguage = "in", "Indonesian",
IF(tweetLanguage = "pt", "Portuguese",
IF(tweetLanguage = "it", "Italien",
IF(tweetLanguage = "et", "Estonian",
IF(tweetLanguage = "ca", "Catalan",
IF(tweetLanguage = "ht", "Haitian",
IF(tweetLanguage = "el", "Modern Greek", "")))))))))))))

SELECT tweetText, tweetLanguage, tweetLanFull
FROM tweet_data

------------------------------------------------------------------------------------------

-- DROPPING COLUMNS -- 

-- conversationId -- 

-- I want to see if all the conversationIds are equal to their corresponding tweetId. If they are all the same we know the conversationId column can be deleted. -- 

SELECT tweetId, conversationId
FROM tweet_data
WHERE NOT tweetId = conversationId

-- As above query gives us 0 records we can continue and drop the conversationId column -- 

ALTER TABLE tweet_data
DROP COLUMN conversationId

-- replyToUserId -- 

-- I want to see if there are any rows with where LENGTH(value) is larger than 0 -- 

SELECT replyToUserId
FROM tweet_data
WHERE LENGTH(replyToUserId) > 0

-- As above query gives us 0 records we can continue and drop the replyToUserId column -- 

ALTER TABLE tweet_data
DROP COLUMN replyToUserId

-- possiblySensitive -- 

-- I want to see if any other value than FALSE for possiblySensitive -- 

SELECT DISTINCT(possiblySensitive), COUNT(possiblySensitive)
FROM tweet_data
GROUP BY possiblySensitive

-- As above query shows us that all values are FALSE we can continue and drop the replyToUserId column -- 

ALTER TABLE tweet_data
DROP COLUMN possiblySensitive

------------------------------------------------------------------------------------------