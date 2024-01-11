#/bin/bash

# Builds the login JSON packet for body of the REST call

source ./fn_logging.sh "$3"

Build_Login_Payload () {
# Build body payload for login
loginPayload=$(echo "{\"username\":\"$1\",\"password\":\"$2\"}")
edebug "This is login payload:"
#edebug "${loginPayload}"

if [ "$3" = '-G' ]; then
  jq -c <<< $loginPayload
fi

}

