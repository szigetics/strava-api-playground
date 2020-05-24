function exportActivityToGPX() {
  #GET /athlete/activities/<id>/streams/latlng,altitude
  read -p 'Activity ID: ' ACTIVITY_ID
  
  if [ -z "$ACTIVITY_ID" ];
  then
      echo "Please enter a valid activity id"
      return
  fi
  
  FULL_RESPONSE=$(curl     https://www.strava.com/api/v3/activities/${ACTIVITY_ID}/streams/latlng?access_token=${ACCESS_TOKEN} | python    -m json.tool)
  COUNT=$(echo $FULL_RESPONSE | jq '. | length')
  echo "GET activities/${ACTIVITY_ID}/streams/latlng?access_token=${ACCESS_TOKEN} FULL_RESPONSE : \n      $FULL_RESPONSE"
  echo "size : ${COUNT}"
  
  echo ""
}
