#!/bin/bash

# Restart script for bottom Cava window
# Triggered by Matugen when wallpaper changes

# Kill all Cava processes
killall -9 cava 2>/dev/null

# Close the bottom Cava window
hyprctl dispatch closewindow title:cava_bottom 2>/dev/null

# Wait for cleanup
sleep 1

# Reopen if it was open before
if [ -f /tmp/cava_was_open ]; then
    ~/.config/waybar/scripts/cava-opener.sh bottom &
fi
