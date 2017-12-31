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

# sed -e 's!http\(s\)\{0,1\}://[^[:space:]]*!!g' ../text/trump_tweets_url.txt > ../text/trump_tweets_process1.txt
sed -e 's/http[^ ]*//g' ../text/trump_tweets_url.txt > ../text/trump_tweets_www.txt
sed -e 's/[a-zA-Z]*www\.[a-zA-Z]*//g' ../text/trump_tweets_www.txt > ../text/trump_tweets_com.txt
sed -e 's/[a-zA-Z]*\.com[a-zA-Z]*//g' ../text/trump_tweets_com.txt > ../text/trump_tweets_process1.txt

# Remove periods at the begining of any line
sed -e 's/^\.//' ../text/trump_tweets_process1.txt > ../text/trump_tweets_process2.txt
sed -e 's/^\.//' ../text/trump_tweets_process2.txt > ../text/trump_tweets_process3.txt
sed -e 's/^\.//' ../text/trump_tweets_process3.txt > ../text/trump_tweets_colon.txt

sed -e 's/://g' ../text/trump_tweets_colon.txt > ../text/trump_tweets_bracket.txt
sed -e 's/[][]//g' ../text/trump_tweets_bracket.txt > ../text/trump_tweets_right_brace.txt

sed -e 's/[{]//g' ../text/trump_tweets_right_brace.txt > ../text/trump_tweets_left_brace.txt
sed -e 's/[}]//g' ../text/trump_tweets_left_brace.txt > ../text/trump_tweets_double_quotes.txt

sed -e 's|["]||g' ../text/trump_tweets_double_quotes.txt > ../text/trump_tweets_single_quotes.txt

perl -pe "s@(?:\s'|'\s)@ @g" ../text/trump_tweets_single_quotes.txt > ../text/trump_tweets_cont.txt

sed -e 's/[(]cont[)]//' ../text/trump_tweets_cont.txt >  ../text/trump_tweets_amp.txt
sed -e 's/\&amp;//g' ../text/trump_tweets_amp.txt >  ../text/trump_tweets_rt.txt
sed -e '/^RT/ d' ../text/trump_tweets_rt.txt >  ../text/trump_tweets_unicode.txt
iconv -c -f utf-8 -t ascii ../text/trump_tweets_unicode.txt > ../text/trump_tweets_at.txt
python3 format_tweets.py
sed -e '/^\s*$/d' ../text/trump_tweets_spaces.txt > ../text/trump_tweets.txt
# cat ../common_phrases.txt >> ../text/trump_tweets.txt
