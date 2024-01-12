#/bin/bash

# Get latest tag
latesttag=$(curl -s "https://api.github.com/repos/Protocol789/homeassistant/tags" | jq -r '.[0].name')
dlURL="https://github.com/Protocol789/homeassistant/archive/refs/tags/$latesttag.tar.gz"
dlFilename="$latesttag.tar.gz"

# Get release
echo "Grabbing release from Github"
wget "$dlURL"

echo "Decrompress archive"
tar -xvzf "$dlFilename"

# Sort folders
echo "Sorting folders out"
mkdir func
cp ./homeassistant-$latesttag/func/* func/
cp ./homeassistant-$latesttag/Airtel_GetBalance.sh ./

# Clean up
echo "Clean up"
rm "$dlFilename"
rm -rf homeassistant-$latesttag/

echo "--------- DONE -----------"
