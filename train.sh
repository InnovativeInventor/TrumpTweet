#!/bin/bash

# Made by Innovative Inventor at https://github.com/innovativeinventor.
# If you like this code, star it on GitHub!
# Contributions are always welcome.

# MIT License
# Copyright (c) 2017 InnovativeInventor

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Notes:
# If docker requires sudo on your computer run this script as sudo
# Type in bash train.sh --help for more info

# Default values
checkpoints=100
length=140
VERSION="1.2"
layers="3"
rnn_size="200"

DATE=`date +%m-%d@%H-%M`

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -e|--epochs)
    checkpoints="$2"
    shift # past argument
    shift # past value
    ;;
    -l|--layers)
    layers="$2"
    shift # past argument
    shift # past value
    ;;
    --rnn|--size)
    rnn_size="$2"
    shift # past argument
    shift # past value
    ;;
    -l|--length)
    length="$2"
    shift # past argument
    shift # past value
    ;;
    -h|--help)
    help=YES
    shift # past argument
    ;;
    -u|--update)
    update=YES
    shift # past argument
    ;;
    -s|--speech)
    speech=YES
    shift # past argument
    ;;
esac
done

display_help() {
    echo
    echo "Script version $VERSION"
    echo 'Machine generated trump-like tweets using Torch-rnn in a Docker container'
    echo 'Usage: train.sh <options>'
    echo 'Options:'
    echo '   -h --help                   Show help'
    echo '   -u --update                 Update tweets and process data'
    echo '   -e --epochs <amount>        Specify the amount of epochs you want'
    echo '   -l --length                 Specify length of tweet generated (default=140)'
    exit 1
}

# Help option
if [ "$help" == YES ]; then
    display_help
fi

# Extracting and processing data
if [ "$update" == YES ]; then
    git submodule update --remote
    rm train_data/uncompressed/*

    cd train_data/scripts || echo "Error: train_data/scripts not found"
    bash uncompress.sh
    python3 extract_tweets.py
    bash format_tweets.sh
    bash format_speeches.sh
    bash process.sh

    cd .. && cd ..

    # Moving
    cp train_data/trump_tweets.h5 docker-train/trump_tweets.h5
    cp train_data/trump_tweets.json docker-train/trump_tweets.json
    cp train_data/trump_speeches.h5 docker-train/trump_speeches.h5
    cp train_data/trump_speeches.json docker-train/trump_speeches.json
fi

# Removing containers if they exist
docker stop trumptweet
docker rm trumptweet

# Training in docker container
docker build -t trumptweet_train docker-train
docker run -t -d --name trumptweet trumptweet_train

# Speech option
if [ "$speech" == YES ]; then
    docker exec -it trumptweet th train.lua -input_h5 data/trump_speeches.h5 -input_json data/trump_speeches.json -num_layers $layers -rnn_size $rnn_size -max_epochs $checkpoints -gpu -1
    msg="speech-"+$DATE
else
    docker exec -it trumptweet th train.lua -input_h5 data/trump_tweets.h5 -input_json data/trump_tweets.json -num_layers $layers -rnn_size $rnn_size -max_epochs $checkpoints -gpu -1
    msg="tweet-"+$DATE
fi

docker exec -it trumptweet th sample.lua -checkpoint cv/checkpoint_10000.t7 -length $length -gpu -1

echo "$msg"

mkdir -p "cv/$msg"
docker cp trumptweet:/root/torch-rnn/cv/ .
docker cp trumptweet:/root/torch-rnn/cv/* "cv/$msg"
mv cv
echo "Layers: $layers" > "cv/$msg/details.txt"
echo "Rnn_size: $rnn_size" >> "cv/$msg/details.txt"
echo "Layers: $layers" > "cv/details.txt"
echo "Rnn_size: $rnn_size" >> "cv/details.txt"

echo "Experiment around with the checkpoints by typing:"
echo "docker exec -it trumptweet th sample.lua -checkpoint cv/checkpoint_10000.t7 -length $length -gpu -1"
echo "Checkpoints are also saved in cv/"
echo "If you have everything installed on your system, you can type:"
echo "th sample.lua -checkpoint cv/checkpoint_10000.t7 -length $length"
