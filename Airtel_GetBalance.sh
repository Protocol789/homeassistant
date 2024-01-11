#!/bin/bash

# Variable declaration
URL='https://airtel.co.zm/broadband/be/api/hbb/user/v1/login'
user="$1"
pass="$2"
loglvl="$3"

# Load in the functions
source ./func/fn_logging.sh "$3"
source ./func/fn_BuildLogin.sh
source ./func/fn_GetLoginToken.sh
source ./func/fn_GetBalanceAll.sh

edebug "Variable passed in postion 1: $1"
edebug "Variable passed in postion 2: $2"

########## Main ##########

edebug "Running payload creator"
# Build the login JSON packet
Build_Login_Payload "$user" "$pass" "$loglvl"

einfo "Running airtel login call"
einfo "-------------------------"

# Make call to Airtel API to retieve login token guid
GetLoginToken "$URL" "$loglvl"

edebug "Extracting info from body response"
# Parse reponse body
status=$(echo "$body" | jq -r '.status')

if [ $status != 'SUCCESS' ]; then
  eerror "Airtel API returned 200 but there is an error in the response packet"
  exit 20
else
  edebug "Status code of SUCCCESS from Airtel login API response packet"
fi

token=$(echo "$body" | jq -r '.result')

edebug "This is login token:"
edebug "$token"

einfo "Extracted login token"
#echo "$token"

# Make get balance call to Airtel 
GetBalance "$loglvl" "$body"

exit 0
