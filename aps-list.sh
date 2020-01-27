#!/bin/bash

apDevices=()

i=0
while read -r line; do
    i=`expr $i + 1`
    if [ $i -lt 5 ]; then continue; fi # skip the header lines
        room=$( echo $line | cut -d ' ' -f 7-100 )
                apDevices+=("$room")

    # break if no more items will follow (e.g. Flags != 3)
    if [ $(echo $line | cut -d ' ' -f 3) -ne '3' ]; then
        break
    fi
done < <((sleep 0.1; pgrep -q dns-sd && kill -13 $(pgrep dns-sd)) & # kill quickly if trapped
            dns-sd -B _airplay._tcp)

if [[ -z "${apDevices}" ]]; then
    cat << EOB
        {"items": [
            {
                "type": "default",
                "title": "No AirPlay device found",
                "subtitle": "Make sure your AirPlay devices are ON and accessible",
                "valid": false,
            },
            {
                "type": "file",
                "title": "Go to AirPlay Menu",
                "subtitle": "Jump to the AirPlay Menu and play around manually",
                "arg": "Go AirPlay Menu",
                "valid": true,
            }
        ]}
EOB
else
    cat << EOB
        {"items": [
EOB
    IFS=","

    for f in ${apDevices[@]}; do
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

    if [[ $(sw_vers -productVersion | cut -d '.' -f 1,2) > 10.14 ]]; then
        cat << EOB
                {
                    "type": "file",
                    "title": "Stop AirPlay",
                    "subtitle": "Stop AirPlay",
                    "arg": "Stop AirPlay",
                    "autocomplete": "Stop AirPlay",
                },
EOB
    else
        cat << EOB
                {
                    "type": "file",
                    "title": "Turn AirPlay Off",
                    "subtitle": "Turn AirPlay Off",
                    "arg": "Turn AirPlay Off",
                    "autocomplete": "Turn AirPlay Off",
                },
EOB
    fi

    cat << EOB
            {
                "type": "file",
                "title": "Go to AirPlay Menu",
                "subtitle": "Jump to the AirPlay Menu and play around manually",
                "arg": "Go AirPlay Menu",
                "valid": true,
            }
        ]}
EOB
fi
