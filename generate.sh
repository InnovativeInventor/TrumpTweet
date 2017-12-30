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

checkpoint=27000
length=140
VERSION="1.0"

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -c|--checkpoint)
    checkpoint="$2"
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
esac
done

display_help() {
    echo
    echo "Script version $VERSION"
    echo 'Machine generated trump-like tweets using Torch-rnn in a Docker container'
    echo 'Usage: train.sh <options>'
    echo 'Options:'
    echo '   -h --help                   Show help'
    echo '   -c --checkpoint <amount>    Specify the checkpoint you want to use, in increments of 1000 (default=10000)'
    echo '   -l --length                 Specify length of tweet generated (default=140)'
    exit 1
}

# Help option
if [ "$help" == YES ]; then
    display_help
fi
# Removing containers if they exist
docker stop trumptweet
docker rm trumptweet

cp cv/* docker-generate/
docker build -t trumptweet_gen docker-generate
docker run -t -d --name trumptweet trumptweet_gen
docker exec -it trumptweet th sample.lua -checkpoint cv/checkpoint_$checkpoint.t7 -length $length -gpu -1
