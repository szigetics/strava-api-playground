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
    read -p "Would you like to open it on strava.com in your default browser? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        open "https://strava.com/activities/$LONGEST_ID"
    fi
}
