import tweepy, pprint, os 

from time import sleep
from datetime import date, datetime
import pandas as pd

from app.data.twitter_api_keys import TwitterApiKeys
twitterKeys = TwitterApiKeys.twitterKeys

from app.modules.helper_class import fetchTweet
fetchTweet = fetchTweet()


class elonMuskFetch():


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
    

    def create_dict_obj(self, tweetId):

        tweetData = fetchTweet.fetch_tweet(tweetId)

        # creating a string of the different context annotations instead of having huge dictionaries
        contextString = ""

        for context in tweetData.context_annotations:

            if not f"{context['domain']['name']}" in contextString:

                contextString += f"{context['domain']['name']}, "

        # creating dict obj
        dictObj = {
            "tweetId": tweetData.id,
            "tweetText": tweetData.text,
            "tweetLength": len(tweetData.text),
            "tweetCount@": (tweetData.text).count('@'),
            "tweetCount#": (tweetData.text).count('#'),
            "tweetAttachments": tweetData.attachments,
            "tweetContextAnnotations": contextString,
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
    
    
    def run_but(self):

        muskTimeline = self.fetch_musk_timeline(self.muskUserId)

        for tweet in muskTimeline:

            # creating a dictionary of the tweet data
            tweetDictObj = self.create_dict_obj(tweet.id)

            # adding the dictionary to a list
            self.listOfTweetDicts.append(tweetDictObj)

        # create dataframe of list
        tweetDf = pd.DataFrame.from_dict(self.listOfTweetDicts)

        # create csv from dataframe
        tweetDf.to_csv("app/csv_export/musk_tweet_data.csv")


    def exc_bot(self):

        self.run_bot()