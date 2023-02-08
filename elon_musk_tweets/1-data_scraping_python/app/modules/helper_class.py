import tweepy, openai

from time import sleep

from app.data.twitter_api_keys import TwitterApiKeys
twitterKeys = TwitterApiKeys.twitterKeys

from app.data.openAi_api_key import openAiKey
openAiKey = openAiKey().openAiKey


# creating a class that fetches single tweets including extra tweet fields (data fields) using Tweepy API V2
class fetchTweet():

    def __init__(self):

        self.client = tweepy.Client(consumer_key = twitterKeys["api_key"], consumer_secret = twitterKeys["api_key_secret"], access_token = twitterKeys["access_token"], access_token_secret = twitterKeys["access_token_secret"])

    
    def fetch_tweet(self, tweetId):

        tweet = self.client.get_tweet(id = tweetId, user_auth = True, tweet_fields = ["attachments", "context_annotations", "conversation_id", "created_at", "in_reply_to_user_id", "lang", "public_metrics", "possibly_sensitive", "source"]).data

        return tweet
    

# creating a class that manages the openAi prompt and connection
class openAi():

    def determine_tweet_sentiment(self, tweetString):

        while True:

            try:

                openai.api_key = openAiKey

                prompt = f"Classify the sentiment of the following text:\n" + tweetString

                response = openai.Completion.create(
                    model="text-davinci-003",
                    prompt=prompt,
                    temperature=0.7,
                    max_tokens=256,
                    top_p=1,
                    frequency_penalty=0,
                    presence_penalty=0
                )

                break
            
            except Exception as e:
                print(e)
                sleep(5)

        return response["choices"][0]["text"]