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
# Usage: bash train.sh <checkpoints>
checkpoints=50
VERSION="1.0"

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -c|--checkpoints)
    checkpoints="$2"
    shift # past argument
    shift # past value
    ;;
    -e|--epochs)
    checkpoints="$2"
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
    echo '   -e --epochs <amount>        Specify the amount of checkpoints/epochs you want'
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
    bash format.sh
    bash process.sh

    cd .. && cd ..
fi

# Removing containers if they exist
docker stop trumptweet
docker rm trumptweet

# Training in docker container
cp train_data/trump_tweets.h5 docker/trump_tweets.h5
cp train_data/trump_tweets.json docker/trump_tweets.json
docker build -t trumptweet docker
docker run -t -d --name trumptweet trumptweet
docker exec -it trumptweet th train.lua -input_h5 data/trump_tweets.h5 -input_json data/trump_tweets.json -max_epochs $checkpoints -gpu -1
docker exec -it trumptweet th sample.lua -checkpoint cv/checkpoint_10000.t7 -length 180

docker cp trumptweet:/root/torch-rnn/cv/ models/

echo "Experiment around with the checkpoints by typing:"
echo "docker exec -it trumptweet th sample.lua -checkpoint cv/checkpoint_10000.t7 -length 140 -gpu -1"
echo "Checkpoints are also saved in models/cv"
echo "If you have everything installed on your system, you can type:"
echo "th sample.lua -checkpoint models/cv/checkpoint_10000.t7 -length 180"
