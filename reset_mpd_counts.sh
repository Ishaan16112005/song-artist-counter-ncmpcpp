#!/bin/bash

JSON_FILE=~/.config/mpd/counts.json

jq 'map_values(0)' "$JSON_FILE" > "${JSON_FILE}.tmp" && mv "${JSON_FILE}.tmp" "$JSON_FILE"
echo "All play counts have been reset to 0."
