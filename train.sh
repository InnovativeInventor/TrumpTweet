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

# Extracting and processing data
cd train_data/scripts || echo "Error: train_data/scripts not found"
bash uncompress.sh
python3 extract_tweets.py
bash format.sh
bash process.sh

# Removing containers if they exist
docker stop trumptweet
docker rm trumptweet

# Training in docker container
cp train_data/trump_tweets.h5 docker/trump_tweets.h5
cp train_data/trump_tweets.json docker/trump_tweets.json
docker build -t trumptweet docker
docker run -t -d --name trumptweet trumptweet
docker exec -it trumptweet th train.lua -input_h5 data/trump_tweets.h5 -input_json data/trump_tweets.json -gpu -1
docker exec -it trumptweet th sample.lua -checkpoint cv/checkpoint_10000.t7 -length 180

echo "Experiment around with the checkpoints by typing:"
echo "docker exec -it trumptweet th sample.lua -checkpoint cv/checkpoint_10000.t7 -length 180"
