import tweepy, pprint, os 

from time import sleep
from datetime import date, datetime
import pandas as pd

from app.data.twitter_api_keys import TwitterApiKeys
twitterKeys = TwitterApiKeys.twitterKeys

from app.modules.helper_class import fetchTweet, muskTimeline
fetchTweet = fetchTweet()
muskTimeline = muskTimeline()


class tweetData():


    def __init__(self):

        # setting Elon Musks Twitter user Id as a variable
        self.muskUserId = 44196397

        # setting listOfTweetDicts as a variable
        self.listOfTweetDicts = []

        # creating a Twitter API object
        self.auth = tweepy.OAuthHandler(twitterKeys['api_key'], twitterKeys['api_key_secret'])
        self.auth.set_access_token(twitterKeys['access_token'], twitterKeys['access_token_secret'])
        self.api = tweepy.API(self.auth, wait_on_rate_limit=True)
    

    # creating a function to make a dictionary object from each tweet that will be added to a list.
    def create_dict_obj(self, tweetId):

        tweetData = fetchTweet.fetch_tweet(tweetId)

        # creating dict obj
        dictObj = {
            "tweetId": tweetData.id,
            "tweetText": tweetData.text,
            "tweetLength": len(tweetData.text),
            "tweetCount@": (tweetData.text).count('@'),
            "tweetCount#": (tweetData.text).count('#'),
            "tweetAttachments": tweetData.attachments,
            "tweetConversationId": tweetData.conversation_id,
            "tweetCreatedAt": tweetData.created_at.strftime("%d-%m-%Y"),     
            "tweetReplyToUserId": tweetData.in_reply_to_user_id,     
            "tweetLanguage": tweetData.lang,     
            "tweetImpressionCount": tweetData.public_metrics['impression_count'],
            "tweetLikeCount": tweetData.public_metrics['like_count'],
            "tweetReplyCount": tweetData.public_metrics['reply_count'],
            "tweetRetweetCount": tweetData.public_metrics['retweet_count'],
            "tweetPossiblySensitive": tweetData.possibly_sensitive,
            "tweetSource": tweetData.source,     
        }

        return dictObj
    
    
    # creating a function that contains the full script
    def run_bot(self):

        # creating the twitter timeline of Elon Musk as a variable
        muskTweetTimeline = muskTimeline.fetch_musk_timeline(self.muskUserId)

        # itterating over tweets by Elon Musk
        for tweet in muskTweetTimeline:

            # creating a dictionary of the tweet data
            tweetDictObj = self.create_dict_obj(tweet.id)

            # adding the dictionary to a list
            self.listOfTweetDicts.append(tweetDictObj)

        # create dataframe of list
        tweetDf = pd.DataFrame.from_dict(self.listOfTweetDicts)

        # create csv from dataframe
        tweetDf.to_csv("app/csv_export/musk_tweet_data.csv", index = False)


    # creating a function that will execute the script
    def exc_bot(self):

        self.run_bot()