#/bin/bash

# Get latest tag
latesttag=$(curl -s "https://api.github.com/repos/Protocol789/homeassistant/tags" | jq -r '.[0].name')
dlURL="https://github.com/Protocol789/homeassistant/archive/refs/tags/$latesttag.tar.gz"
dlFilename="$latesttag.tar.gz"
ver=$(echo $latesttag | cut -c 2-)

echo "--------- START -----------"

if [ -d "AirtelTracker" ]; then
  echo "AirtelTracker folder already exists, please remove it first and then rerun the command"
  exit 40
fi

echo "Creating folder for AirtelTracker..."
mkdir AirtelTracker
cd AirtelTracker/

# Get release
echo "Grabbing AirtelTracker release $ver from Github..."
wget -q --show-progress "$dlURL"

if [ $? -eq 0 ]; then
  echo "Successfully downloaded release $ver!"
else
  echo "ERROR: Release from Github did not download"
  echo "Exiting.............."
  exit 10
fi

echo "Decompressing archive..."
tar -xzf "$dlFilename"

if [ $? -eq 0 ]; then
  echo "Successfully extracted release!"
else
  echo "ERROR: Release was not extracted successfully"
  echo "Exiting.............."
  exit 20
fi


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
