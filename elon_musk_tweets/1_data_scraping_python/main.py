import tweepy
from time import sleep
from multiprocessing import Pool, Process

from app.data.twitter_api_keys import TwitterApiKeys
twitterKeys = TwitterApiKeys.twitterKeys

from app.modules.tweet_data import elonMuskFetch
elonMuskFetch = elonMuskFetch()

from app.modules.tweet_sentiment import tweetSentiment
tweetSentiment = tweetSentiment()


if __name__ == '__main__':

    # define processes
    process_elonMuskFetch = Process(target = elonMuskFetch.exc_bot)
    process_tweetSentiment = Process(target = tweetSentiment.exc_bot)

    # start processes
    process_elonMuskFetch.start()
    process_tweetSentiment.start()