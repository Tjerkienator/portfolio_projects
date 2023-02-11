import os

class TwitterApiKeys():

    # leaving twitterKeys value empty for protection of my account
    twitterKeys = {
        "api_key": os.getenv("TWITTER_API_KEY"),
        "api_key_secret": os.getenv("TWITTER_API_SECRET"),
        "access_token": os.getenv("TWITTER_ACCESS_TOKEN"),
        "access_token_secret": os.getenv("TWITTER_ACCESS_SECRET"),
        "client_id": os.getenv("TWITTER_CLIENT_ID"),
        "client_secret": os.getenv("TWITTER_CLIENT_SECRET"),
    }

