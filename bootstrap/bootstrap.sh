#/bin/bash

# Get latest tag
latesttag=$(curl -s "https://api.github.com/repos/Protocol789/homeassistant/tags" | jq -r '.[0].name')
dlURL="https://github.com/Protocol789/homeassistant/archive/refs/tags/$latesttag.tar.gz"
dlFilename="$latesttag.tar.gz"
ver=$(echo $latesttag | cut -c 2-)

echo "--------- START -----------"

echo "Creating folder for AirtelTracker..."
mkdir AirtelTracker
cd AirtelTracker/

# Get release
echo "Grabbing release from Github..."
wget -q --show-progress "$dlURL"

echo "Decompressing archive..."
tar -xzf "$dlFilename"

# Sort folders
echo "Sorting folders out...."
mkdir func
cp ./homeassistant-$ver/func/* func/
cp ./homeassistant-$ver/Airtel_GetBalance.sh ./

# Clean up
echo "Clean up"
rm "$dlFilename"
rm -rf homeassistant-$ver/

echo "--------- DONE -----------"
