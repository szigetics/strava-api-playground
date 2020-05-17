function currentAthlete() {
  #GET /athlete
  FULL_RESPONSE=$(curl https://www.strava.com/api/v3/athlete?access_token=${ACCESS_TOKEN} | python -m json.tool)
  echo "GET /athlete FULL_RESPONSE : \n $FULL_RESPONSE"

  echo ""
}
