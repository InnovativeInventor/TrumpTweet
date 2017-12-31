FROM crisbal/torch-rnn:base
MAINTAINER InnovativeInventor

# Moving pretrained models
RUN mkdir /root/torch-rnn/cv
COPY checkpoint* /root/torch-rnn/cv/

# Copying files
COPY trump_tweets.h5 /root/torch-rnn/data/trump_tweets.h5
COPY trump_tweets.json /root/torch-rnn/data/trump_tweets.json

WORKDIR /root/torch-rnn

