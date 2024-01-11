#/bin/bash

ver=0.1
rel=v0.1.tar.gz

# Get release
echo "Grabbing release from Github"
wget "https://github.com/Protocol789/homeassistant/archive/refs/tags/$rel"

echo "Decrompress archive"
tar -xvzf "$rel"

# Sort folders
echo "Sorting folders out"
mkdir func
cp ./homeassistant-$ver/func/* func/
cp ./homeassistant-$ver/Airtel_GetBalance.sh ./

# Clean up
echo "Clean up"
rm "$rel"
rm -rf homeassistant-0.1/

echo "--------- DONE -----------"