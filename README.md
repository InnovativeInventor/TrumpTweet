## TrumpTweet
Machine generated trump-like tweets using Torch-rnn in a Docker container

## Training
To train type in:
`bash train.sh`

Then, to generate text, type in:
`docker exec -it trumptweet th sample.lua -checkpoint cv/checkpoint_10000.t7 -length 140`

Feel free to change the length and checkpoint to whatever you prefer.

## Credits
My docker images are based off of: https://github.com/crisbal/docker-torch-rnn

Submodules used:

    [Torch-rnn](https://github.com/jcjohnson/torch-rnn)

    [Trump-tweets](https://github.com/bpb27/trump_tweet_data_archive)
