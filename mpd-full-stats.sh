#!/bin/bash

JSON_FILE=~/.config/mpd/counts.json

# All Songs
echo "🎵 All Songs with Play Counts:"
jq -r 'to_entries[] | "\(.value)\t\(.key)"' "$JSON_FILE" | sort -nr
echo ""

# All Artists
echo "🎤 All Artists with Total Play Counts:"
jq -r 'to_entries[] | "\(.key)\t\(.value)"' "$JSON_FILE" |
while IFS=$'\t' read -r song count; do
  artist_part="${song%% - *}"
  IFS=',' read -ra artists <<< "$artist_part"
  for artist in "${artists[@]}"; do
    artist_cleaned="$(echo "$artist" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
    echo -e "$artist_cleaned\t$count"
  done
done |
awk -F'\t' '{a[$1]+=$2} END {for (k in a) print a[k] "\t" k}' |
sort -nr
