import tweepy, pprint, os 

from time import sleep
from datetime import date, datetime
import pandas as pd

from app.data.twitter_api_keys import TwitterApiKeys
twitterKeys = TwitterApiKeys.twitterKeys

from app.modules.helper_class import fetchTweet, openAi, muskTimeline
fetchTweet = fetchTweet()
openAi = openAi()
muskTimeline = muskTimeline()


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
    
    
    # creating a function that contains and runs the full script
    def run_but(self):

        # creating the twitter timeline of Elon Musk as variable
        muskTweetTimeline = muskTimeline.fetch_musk_timeline(self.muskUserId)

        # itterating over tweets by Elon Musk
        for tweet in muskTweetTimeline:

            # determining the tweet sentiment and setting it a a variable
            tweetSentiment = ((openAi.determine_tweet_sentiment(tweet.text)).strip(' \n')).lower()
            
            # creating a dictionary of values
            tweetDictObj = {
                "tweetId": tweet.id,
                "tweetText": tweet.text,
                "tweetSentiment": tweetSentiment, 
            }

            # adding the dictionary to a list
            self.listOfTweetDicts.append(tweetDictObj)

            sleep(0.1)

        # create dataframe of list
        tweetDf = pd.DataFrame.from_dict(self.listOfTweetDicts)

        # create csv from dataframe
        tweetDf.to_csv("app/csv_export/musk_tweet_sentiment.csv")


    # creating a function that will execute the script
    def exc_bot(self):

        self.run_but()