#!/bin/bash
# Cava Waybar Integration Script

CONFIG_FILE="/tmp/cava-waybar-config"

cat > "$CONFIG_FILE" << 'EOF'
[general]
mode = normal
framerate = 60
bars = 12

[input]
method = pulse
source = auto

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
bar_delimiter = 32

[smoothing]
integral = 77
monstercat = 0
waves = 0
gravity = 100

[eq]
1 = 1
2 = 1
3 = 1
4 = 1
5 = 1
EOF

format_cava() {
    local bars=("▁" "▂" "▃" "▄" "▅" "▆" "▇" "█")
    
    while read -r line; do
        output=""
        for val in $line; do
            if [ "$val" -gt 7 ]; then
                val=7
            elif [ "$val" -lt 0 ]; then
                val=0
            fi
            output+="${bars[$val]}"
        done
        echo "$output"
    done
}

cava -p "$CONFIG_FILE" | format_cava