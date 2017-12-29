#!/usr/bin/env python3
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

import json
import datetime
import subprocess

# Finding year
now = datetime.datetime.now()
year = 2009
current_year = now.year

# Loading file
all_tweets_url = open('../text/trump_tweets_url.txt', 'w')

# Looping over and processing

while year <= current_year:
    data = json.load(open('../uncompressed/master_'+str(year)+'.json'))
    # print(json.dumps(data, indent=4, sort_keys=True))
    for element in data:
        try:
            all_tweets_url.write(element['text']+"\n")
            print(element['text']) # Debug
        except:
            print("Text does not exist in this line")
    year+=1

data = json.load(open('../uncompressed/master_2017.json'))
print(json.dumps(data, indent=4, sort_keys=True)) # Debug

# Removing urls using sed and bash
subprocess.call("bash url_remove.sh", shell=True)
