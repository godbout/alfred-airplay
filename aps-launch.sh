#!/bin/bash

read -d '' APPLESCRIPT <<EOF
set found to false
tell application "System Events"
    tell process "SystemUIServer"
        click (menu bar item 1 of menu bar 1 whose description contains "Displays")
        try
            click menu item "$1" of menu 1 of result
            set found to true
            delay 1
        on error
            key code 53
        end try
    end tell
end tell
return found
EOF

found=$(osascript -e "$APPLESCRIPT")

if [[ "$1" = "Turn AirPlay Off" ]]; then
    if [[ "$found" = true ]]; then
        echo "Display not shared anymore";
    else
        echo "Cannot stop sharing display";
    fi
elif [ "$found" = true ]; then
    echo "Display will now be shared with \"$1\"";
else
    echo "Cannot find \"$1\" display";
fi
