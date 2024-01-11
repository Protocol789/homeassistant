#/bin/sh

#source ./fn_logging.sh "$3"

GetLoginToken () {
# Perform login call to airtel API
GetLogin="$(curl --location "$1" \
--silent \
--write-out '%{http_code}' \
--header 'x-app-version: 1.0.0' \
--header 'x-service-id: csteam_hbb_portal_backend_app' \
--header 'Content-Type: application/json' \
--header 'Cookie: HttpOnly' \
--data "$loginPayload")"
#--data '{"username":" username  ","password":" password "}')"

# Extract http response header
http_code="${GetLogin:${#GetLogin}-3}"
edebug "Login: HTTP code response $http_code"

# Error checking for response code
if [ $http_code != 200 ]; then
  eerror "Login: HTTP response code is non-200!"
  echo '{"status":"503"}'
  exit 20
else
  einfo "Login: HTTP response of 200 OK!"
fi

# Extract response body
if [ ${#GetLogin} -eq 3 ]; then
  body=""
else
  body="${GetLogin:0:${#GetLogin}-3}"
fi

edebug "Login: Body reponse is:"
#edebug "$body"

if [ "$2" = '-G' ]; then
#  jq -c <<< $body
  printf '%s\n' "$body" | jq -c
fi

}
