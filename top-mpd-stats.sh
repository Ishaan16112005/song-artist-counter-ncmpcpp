#!/bin/bash

JSON_FILE=~/.config/mpd/counts.json

# Top 5 Songs
echo "Top 5 Most Played Songs:"
jq -r 'to_entries[] | "\(.value)\t\(.key)"' "$JSON_FILE" | sort -nr | head -5

# Top 5 Artists (split by commas)
echo -e "\nTop 5 Most Played Artists:"
jq -r 'to_entries[] | "\(.key)\t\(.value)"' "$JSON_FILE" |
while IFS=$'\t' read -r song count; do
  # Remove trailing .mp3 and extract artist section before ' - '
  artist_part="${song%% - *}"
  # Split artists by comma
  IFS=',' read -ra artists <<< "$artist_part"
  for artist in "${artists[@]}"; do
    # Trim leading/trailing whitespace
    artist_cleaned="$(echo "$artist" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
    echo -e "$artist_cleaned\t$count"
  done
done |
awk -F'\t' '{a[$1]+=$2} END {for (k in a) print a[k] "\t" k}' |
sort -nr | head -5
