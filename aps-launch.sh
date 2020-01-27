#!/bin/bash

read -d '' APPLESCRIPT <<EOF
set found to false
tell application "System Events"
    tell process "SystemUIServer"
        set airplayMenuItem to click (menu bar item 1 of menu bar 1 whose description contains "Displays")
        delay 0.1
        try
            click menu item "$1" of menu 1 of airplayMenuItem
            set found to true
            delay 1
        on error
            if ("$1" is not equal to "Go AirPlay Menu") then
                key code 53
            end if
        end try
    end tell
end tell
return found
EOF

found=$(osascript -e "$APPLESCRIPT")

if [[ "$1" = "Turn AirPlay Off" || "$1" = "Stop AirPlay" ]]; then
    if [[ "$found" = true ]]; then
        echo "Display not shared anymore";
    else
        echo "Cannot stop sharing display";
    fi
elif [ "$found" = true ]; then
    echo "Display will now be shared with \"$1\"";
elif [ "$1" != "Go Airplay Menu"]; then
    echo "Cannot find \"$1\" display";
fi
