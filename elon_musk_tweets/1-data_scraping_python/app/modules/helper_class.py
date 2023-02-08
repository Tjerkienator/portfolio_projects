import tweepy

from app.data.twitter_api_keys import TwitterApiKeys
twitterKeys = TwitterApiKeys.twitterKeys


# creating a class that fetches single tweets including extra tweet fields (data fields) 
# using Tweepy API V2
class fetchTweet():

    def __init__(self):

        self.client = tweepy.Client(consumer_key = twitterKeys["api_key"], consumer_secret = twitterKeys["api_key_secret"], access_token = twitterKeys["access_token"], access_token_secret = twitterKeys["access_token_secret"])

    
    def fetch_tweet(self, tweetId):

        tweet = self.client.get_tweet(id = tweetId, user_auth = True, tweet_fields = ["attachments", "context_annotations", "conversation_id", "created_at", "in_reply_to_user_id", "lang", "public_metrics", "possibly_sensitive", "source"]).data

        return tweet