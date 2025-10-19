#!/bin/bash

# Cava Terminal Opener für Waybar mit Tiling
# Nutzung: ./cava-opener.sh [top|bottom]

POSITION="$1"

# Terminal-Emulator
TERMINAL="kitty"

if [ "$POSITION" = "top" ]; then
    WINDOW_NAME="cava_top"
    CAVA_CONFIG="$HOME/.config/cava/config_top"
    STATUS_FILE="/tmp/cava_top_was_open"
else
    WINDOW_NAME="cava_bottom"
    CAVA_CONFIG="$HOME/.config/cava/config_bottom"
    STATUS_FILE="/tmp/cava_was_open"
fi

#!/bin/bash

# Cava Terminal Opener für Waybar mit Tiling
# Nutzung: ./cava-opener.sh [top|bottom]

POSITION="$1"

# Terminal-Emulator
TERMINAL="kitty"

if [ "$POSITION" = "top" ]; then
    WINDOW_NAME="cava_top"
    CAVA_CONFIG="$HOME/.config/cava/config_top"
    STATUS_FILE="/tmp/cava_top_was_open"
else
    WINDOW_NAME="cava_bottom"
    CAVA_CONFIG="$HOME/.config/cava/config_bottom"
    STATUS_FILE="/tmp/cava_was_open"
fi

# Prüfen ob Fenster bereits existiert
if hyprctl clients -j | jq -e ".[] | select(.title == \"$WINDOW_NAME\")" > /dev/null; then
    # Fenster existiert, schließen
    hyprctl dispatch closewindow "title:$WINDOW_NAME"
    # Markiere dass Cava geschlossen ist
    rm -f "$STATUS_FILE"
else
    # Markiere dass Cava offen ist
    touch "$STATUS_FILE"
    
    # Neues Fenster öffnen mit spezifischer Config und Transparenz
    kitty --class "$WINDOW_NAME" --title "$WINDOW_NAME" \
        -o background_opacity=0.0 \
        bash -c "cava -p \"$CAVA_CONFIG\"; exec bash" &
    
    # Warte bis Fenster existiert
    sleep 0.3
    
    # Fenster als getilt behandeln (nicht floating)
    # und split direction setzen
    if [ "$POSITION" = "top" ]; then
        hyprctl dispatch togglesplit
    else
        hyprctl dispatch togglesplit
    fi
fi