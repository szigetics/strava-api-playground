function listActivities() {
  #GET /athlete/activities
  read -p 'After date epoch (leave empty for default) : ' AFTER_DATE_EPOCH

  OUT_DIR="allActivities"
  rm -rf "$OUT_DIR"
  mkdir -p "$OUT_DIR"
  pushd "$OUT_DIR"

  PAGE="0"
  while [ true ];
  do
    let "PAGE+=1"
    
    QUERY_PARAMETERS="&per_page=200" #30 is the default value
    
    if [ ! -z "$AFTER_DATE_EPOCH" ];
    then
      QUERY_PARAMETERS="$QUERY_PARAMETERS&after=${AFTER_DATE_EPOCH}"
    fi
    
    if [ ! -z "$PAGE" ];
    then
      QUERY_PARAMETERS="$QUERY_PARAMETERS&page=${PAGE}"
    fi
    
    FULL_RESPONSE=$(curl https://www.strava.com/api/v3/athlete/activities?access_token=${ACCESS_TOKEN}${QUERY_PARAMETERS} | python -m json.tool)
    COUNT=$(echo $FULL_RESPONSE | jq '. | length')
    echo "GET athlete/activities?access_token=${ACCESS_TOKEN}${QUERY_PARAMETERS} FULL_RESPONSE : \n $FULL_RESPONSE"
    echo "size : ${COUNT}"
    
    echo "$FULL_RESPONSE" >> "$PAGE.json"
    
    if [ "$COUNT" -le 0 ];
    then
        echo "no more pages"
        break
    else
        echo "loading more pages..."
    fi
  done
  
  OUT_FILE="all.json"
  jq -s '[.[][]]' *.json > $OUT_FILE
  echo "All results can be found under $OUT_DIR/$OUT_FILE"
  popd #OUT_DIR
  
  echo ""
}
