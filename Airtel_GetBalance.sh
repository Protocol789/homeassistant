#!/bin/bash

# Variable declaration
URL='https://airtel.co.zm/broadband/be/api/hbb/user/v1/login'
user="$1"
pass="$2"
loglvl="$3"
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
#echo "Script directory: $SCRIPT_DIR"

# Load in the functions

source $SCRIPT_DIR/func/fn_logging.sh "$3"
source $SCRIPT_DIR/func/fn_BuildLogin.sh
source $SCRIPT_DIR/func/fn_GetLoginToken.sh
source $SCRIPT_DIR/func/fn_GetBalanceAll.sh

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
  echo $body
  exit 0
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

# Split out balance into integer and type
bal_int=$(echo $totalbalance | awk '{print $1}')
bal_unit=$(echo $totalbalance | awk '{print $2}')
edebug "Balance integer is |$bal_int| and the unit of mesurement is |$bal_unit|"

json=$(cat <<EOF
{"balance":"$bal_int", "unit":"$bal_unit", "message":"success", "status":"SUCCESS", "statusCode":200}
EOF
)

if [ $loglvl = "-V" ]; then
  printf '%s\n' "$json" | jq -c
fi

# Output value and exit
echo $json
exit 0
