function openInBrowser() {
    local ACTIVITY_ID="$1"
    
    read -p "Would you like to open it on strava.com in your default browser? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        open "https://strava.com/activities/$ACTIVITY_ID"
    fi
}

function filterActivities() {
    OUT_DIR="allActivities"
    OUT_FILE="all.json"

    if [ ! -f "$OUT_DIR/$OUT_FILE" ];
    then
      echo "$OUT_DIR/$OUT_FILE does not exists yet. Please execute listActivities first!"
      return
    fi
    
    echo "Activity with longest distance : "
    LONGEST=$(jq '[ .[] ] | max_by(.distance)' "$OUT_DIR/$OUT_FILE")
    echo $LONGEST
    LONGEST_ID=$(echo $LONGEST | jq '.id')
    echo $LONGEST_ID
    openInBrowser "$LONGEST_ID"
    
    echo "Activity with highest elevation : "
    HIGHEST=$(jq '[ .[] ] | max_by(.elev_high)' "$OUT_DIR/$OUT_FILE")
    echo $HIGHEST
    HIGHEST_ID=$(echo $HIGHEST | jq '.id')
    echo $HIGHEST_ID
    openInBrowser "$HIGHEST_ID"
    
    echo "Activity with max total elevation gain : "
    MAX_ELEVATION_GAIN=$(jq '[ .[] ] | max_by(.total_elevation_gain)' "$OUT_DIR/$OUT_FILE")
    echo $MAX_ELEVATION_GAIN
    MAX_ELEVATION_GAIN_ID=$(echo $HIGHEST | jq '.id')
    echo $MAX_ELEVATION_GAIN_ID
    openInBrowser "$MAX_ELEVATION_GAIN_ID"
}
