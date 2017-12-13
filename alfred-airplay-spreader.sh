#!/bin/bash

read -d '' APPLESCRIPT <<EOF
set found to false
tell application "System Events"
    tell process "SystemUIServer"
        click (menu bar item 1 of menu bar 1 whose description contains "Displays")
        try
            click menu item "$1" of menu 1 of result
            set found to true
            delay 4
        on error
            key code 53
        end try
    end tell
end tell
return found
EOF

found=$(osascript -e "$APPLESCRIPT")

if [[ "$1" = "Turn AirPlay Off" ]]; then
    echo "Display not shared anymore";
elif [ "$found" = true ]; then
    echo "Display now shared with \"$1\"";
else
    echo "Cannot find \"$1\" display";
fi