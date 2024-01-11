#/bin/bash

#source ./fn_logging.sh "$loglvl"

# Variable declaration
Bal_URL='https://airtel.co.zm/broadband/be/api/hbb/subscriber/get-balance-all'

function GetBalance () {

einfo  "-------------------------"
einfo  "Starting Airtel Balance call"
edebug "Calling Airtel Balance API on:"
edebug "$Bal_URL"
edebug "-------------------------"

GetBal=$(curl --location "$Bal_URL" \
--silent \
--write-out '%{http_code}' \
--header 'x-app-version:  1.0.0' \
--header 'x-service-id:  csteam_hbb_portal_backend_app' \
--header "Authorization: Bearer $token")

# Extract http response header
http_code="${GetBal:${#GetBal}-3}"
edebug "HTTP code response $http_code"

# Error checking for response code
if [ $http_code != 200 ]; then
  eerror "HTTP response code is non-200!"
  exit 10
else
  einfo "Get Balance HTTP response of 200 OK!"
fi

# Extract response body
if [ ${#GetBal} -eq 3 ]; then
  body=""
else
  body="${GetBal:0:${#GetBal}-3}"
fi

edebug "Get Balance body reponse is:"
#edebug "$body"

if [ "$loglvl" = '-G' ]; then
  jq -c <<< $body
fi

einfo "Here's your balances per bundle"
if [ "$loglvl" = '-G' ]; then
  #jq -c .result.devices[0].balanceDetails.data[] | balance,bundletype  <<< $body
  jq -c '.result.devices[0].balanceDetails.data[] | {balanceDescription, balance}' <<< $body
fi

}
