#!/bin/bash

# Restart script for top Cava window
# Triggered by Matugen when wallpaper changes

# Kill all Cava processes
killall -9 cava 2>/dev/null

# Close the top Cava window
hyprctl dispatch closewindow title:cava_top 2>/dev/null

# Wait for cleanup
sleep 1

# Reopen if it was open before
if [ -f /tmp/cava_top_was_open ]; then
    ~/.config/waybar/scripts/cava-opener.sh top &
fi
