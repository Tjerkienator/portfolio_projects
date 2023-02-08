import tweepy
from time import sleep
from multiprocessing import Pool, Process

from app.data.twitter_api_keys import TwitterApiKeys
twitterKeys = TwitterApiKeys.twitterKeys

from app.modules.elon_musk import elonMuskFetch
elonMuskFetch = elonMuskFetch()


if __name__ == '__main__':

    # define processes
    process_elonMuskFetch = Process(target = elonMuskFetch.exc_bot)

    # start processes
    process_elonMuskFetch.start()