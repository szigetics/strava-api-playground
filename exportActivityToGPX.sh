function exportActivityToGPX() {
  #GET /athlete/activities/<id>/streams/latlng,altitude
  read -p 'Activity ID: ' ACTIVITY_ID
  
  if [ -z "$ACTIVITY_ID" ];
  then
      echo "Please enter a valid activity id"
      return
  fi
  
  if [ -f "activities/$ACTIVITY_ID/latlng.json" ];
  then
    echo "Activity ($ACTIVITY_ID) already downloaded"
    return
  fi
  
  mkdir -p "activities/$ACTIVITY_ID"
  
  FULL_RESPONSE=$(curl     https://www.strava.com/api/v3/activities/${ACTIVITY_ID}/streams/latlng?access_token=${ACCESS_TOKEN} | python    -m json.tool)
  COUNT=$(echo $FULL_RESPONSE | jq '. | length')
  echo "GET activities/${ACTIVITY_ID}/streams/latlng?access_token=${ACCESS_TOKEN} FULL_RESPONSE : \n      $FULL_RESPONSE"
  echo "size : ${COUNT}"
  
  echo "$FULL_RESPONSE" > "activities/$ACTIVITY_ID/latlng.json"
  
  LAT_LNG_LIST=$(echo $FULL_RESPONSE | jq '.[] | select(.type == "latlng").data')
  echo "$LAT_LNG_LIST" | jq -r '.[] | join(", ")' > "activities/$ACTIVITY_ID/gpx.csv"
  gpsbabel -i csv -f "activities/$ACTIVITY_ID/gpx.csv" -o gpx -F "activities/$ACTIVITY_ID/gpx.gpx"
  
  echo ""
}
