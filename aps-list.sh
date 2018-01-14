#!/bin/bash

read -d '' APPLESCRIPT <<EOF

tell application "iTunes"	
	set apDevices to (get name of AirPlay devices whose kind is Apple TV)
end tell

return apDevices

EOF

apDevices=$(osascript -e "$APPLESCRIPT")

cat << EOB

{"items": [

EOB

IFS=","

for f in ${apDevices}; do

	item=${f#"${f%%[![:space:]]*}"}

cat << EOB


    {
		"uid": "${item}",
        "type": "file",
        "title": "${item}",
        "subtitle": "Extend display to ${item}",
        "arg": "${item}",
        "autocomplete": "${item}",
    },


EOB

done

cat << EOB

	{
        "type": "file",
        "title": "Turn AirPlay Off",
        "subtitle": "Turn AirPlay Off",
        "arg": "Turn AirPlay Off",
        "autocomplete": "Turn AirPlay Off",
    }
]}
EOB