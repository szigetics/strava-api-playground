#!/bin/bash

set -e #Exit in case if any commands return with non-zero return value

Echo "Strava API : client id and client secret (coming from https://www.strava.com/settings/api) : "
read -p 'CLIENT_ID: ' CLIENT_ID
read -p 'CLIENT_SECRET: ' CLIENT_SECRET

if [ -z "$CLIENT_ID" ];
then
  echo "CLIENT_ID cannot be empty"
  exit 1
fi

if [ -z "$CLIENT_SECRET" ];
then
  echo "CLIENT_SECRET cannot be empty"
  exit 1
fi

open "http://www.strava.com/oauth/authorize?client_id=${CLIENT_ID}&response_type=code&redirect_uri=http://localhost/exchange_token&approval_prompt=force&scope=activity:read_all"
read -p 'CODE (coming from the redirect URL): ' CODE

FULL_RESPONSE=$(curl -X POST https://www.strava.com/oauth/token \
-F client_id=${CLIENT_ID} \
-F client_secret=${CLIENT_SECRET} \
-F code=${CODE} \
-F grant_type=authorization_code)
#echo "FULL_RESPONSE : $FULL_RESPONSE"

export ACCESS_TOKEN=$(echo $FULL_RESPONSE | jq -r .access_token)
echo "ACCESS_TOKEN : $ACCESS_TOKEN"
#REFRESH_TOKEN=$(echo $FULL_RESPONSE | jq -r .refresh_token)
#echo "REFRESH_TOKEN : $REFRESH_TOKEN"
##
#FULL_RESPONSE=$(curl -X POST https://www.strava.com/oauth/token \
#-F client_id=${CLIENT_ID} \
#-F client_secret=${CLIENT_SECRET} \
#-F refresh_token=${REFRESH_TOKEN} \
#-F grant_type=refresh_token)
#echo "FULL_RESPONSE : $FULL_RESPONSE"
#REFRESH_TOKEN=$(echo $FULL_RESPONSE | jq -r .refresh_token)
#echo "REFRESH_TOKEN : $REFRESH_TOKEN"
#
PS3='Which request to send? '
options=("Current athlete" "List Activities" "Filter Activities" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Current athlete")
            echo "you chose $REPLY which is $opt"
            source currentAthlete.sh
            currentAthlete
            ;;
        "List Activities")
            echo "you chose $REPLY which is $opt"
            source listActivities.sh
            listActivities
            ;;
        "Filter Activities")
            echo "you chose $REPLY which is $opt"
            source filterActivities.sh
            filterActivities
            ;;
        "Quit")
            exit 0
            ;;
        *) echo "invalid option $REPLY";;
    esac
done


