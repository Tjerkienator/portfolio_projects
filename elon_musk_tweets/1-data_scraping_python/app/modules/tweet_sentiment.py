import tweepy, pprint, os 

from time import sleep
from datetime import date, datetime
import pandas as pd

from app.data.twitter_api_keys import TwitterApiKeys
twitterKeys = TwitterApiKeys.twitterKeys

from app.modules.helper_class import fetchTweet, openAi
fetchTweet = fetchTweet()
openAi = openAi()


class tweetSentiment():


    def __init__(self):

        # setting Elon Musks Twitter user Id as a variable
        self.muskUserId = 44196397

        # setting listOfTweetDicts as a variable
        self.listOfTweetDicts = []

        # creating a Twitter API object
        self.auth = tweepy.OAuthHandler(twitterKeys['api_key'], twitterKeys['api_key_secret'])
        self.auth.set_access_token(twitterKeys['access_token'], twitterKeys['access_token_secret'])
        self.api = tweepy.API(self.auth, wait_on_rate_limit=True)


    # function to fetch the timeline of Elon Musk
    def fetch_musk_timeline(self, userId):

        return tweepy.Cursor(self.api.user_timeline, user_id = userId, exclude_replies= True, include_rts = False).items(limit = 20)
    
    
    def run_but(self):

        muskTimeline = self.fetch_musk_timeline(self.muskUserId)

        for tweet in muskTimeline:

            tweetSentiment = ((openAi.determine_tweet_sentiment(tweet.text)).strip(' \n')).lower()
            
            tweetDictObj = {
                "tweetId": tweet.id,
                "tweetText": tweet.text,
                "tweetSentiment": tweetSentiment, 
            }

            # adding the dictionary to a list
            self.listOfTweetDicts.append(tweetDictObj)

        # create dataframe of list
        tweetDf = pd.DataFrame.from_dict(self.listOfTweetDicts)

        # create csv from dataframe
        tweetDf.to_csv("app/csv_export/musk_tweet_sentiment.csv")


    def exc_bot(self):

        self.run_but()