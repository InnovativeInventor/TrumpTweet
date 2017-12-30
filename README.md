## TrumpTweet
Machine generated trump-like tweets using Torch-rnn in a Docker container

## Training
To train type in:
`bash train.sh`

```
Usage: train.sh <options>
    -h --help                   Show help
    -u --update                 Update tweets and process data (clone recursively for this)
    -e --epochs <amount>        Specify the amount of checkpoints/epochs you want
```

Things you need to have preinstalled:
- numpy
- h5py
- six

## Generating text
Then, to generate text, type in:
`docker exec -it trumptweet th sample.lua -checkpoint cv/checkpoint_10000.t7 -length 140`

Models are saved in `cv`

To generate sample tweets on your computer, type:
`th sample.lua -checkpoint cv/checkpoint_10000.t7 -length 180`

Feel free to change the length and checkpoint to whatever you prefer.

## Credits
My docker images are based off of: https://github.com/crisbal/docker-torch-rnn

Submodules used:

- [Torch-rnn](https://github.com/jcjohnson/torch-rnn)
- [Trump-tweets](https://github.com/bpb27/trump_tweet_data_archive)
