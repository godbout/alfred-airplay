#!/bin/bash

read -d '' APPLESCRIPT <<EOF
tell application "System Events"
    tell process "SystemUIServer"
        click (menu bar item 1 of menu bar 1 whose description contains "Displays")
        click menu item "$1" of menu 1 of result
        delay 4
    end tell
end tell
EOF

osascript -e "$APPLESCRIPT" > /dev/null

if [[ "$1" = "Turn AirPlay Off" ]]; then
    echo "Display not shared anymore";
else
    echo "Cannot find display to share with";
endif 