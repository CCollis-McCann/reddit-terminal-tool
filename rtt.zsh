#!/bin/zsh

# check if subreddit supplied, if not exit (-z checks if length of string is zero)
if [ -z "$1" ]
then
    echo "Please specify a subreddit"
    exit 1
fi

# store the first argument as the subreddit name, and build up a date-stamped filename where the output will be saved.
SUBREDDIT=$1
NOW=$(date +"%m_%d_%y-%H_%M")
OUTPUT_FILE="${SUBREDDIT}_${NOW}.txt"

# curl is called with a custom header and the URL of the subreddit to scrape. The output is piped to  jq where it’s parsed and reduced to three
# fields: Title, URL and Permalink. These lines are read, one-at-a-time, and saved into a variable using the read command, all inside of a while
# loop, that will continue until there are no more lines to read. The last line of the inner while block echoes the three fields, delimited by a
# tab character, and then pipes it through the tr command so that the double-quotes can be stripped out. The output is then appended to the file.
curl -s -A “reddit terminal tool” https://www.reddit.com/r/${SUBREDDIT}.json | jq '.data.children | .[] | .data.title, .data.url, .data.permalink' | \
while read -r TITLE; do
    read -r URL
    read -r PERMALINK
    echo -e "${TITLE}\t${URL}\t${PERMALINK}" | tr -d \" >> ${OUTPUT_FILE}
done

less ${OUTPUT_FILE}



