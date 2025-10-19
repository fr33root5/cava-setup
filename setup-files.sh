#!/bin/bash

# Setup script to create all necessary files for cava-setup repository
# Run this in the root of your cava-setup directory

echo "Creating all files for cava-setup repository..."

# Create README.md
cat > README.md << 'EOF'
# 🎵 Cava Waybar Setup

Beautiful clickable audio visualizer for Waybar with automatic wallpaper color theming.

![Demo](screenshots/demo.png)

## ✨ Features

- Two clickable Cava visualizations in Waybar (left and right)
- Top Cava with flipped orientation (bars go down)
- Bottom Cava with normal orientation (bars go up)
- Automatic color theming from wallpaper using Matugen
- Transparent floating windows
- Auto-reload on wallpaper change
- Toggle split window functionality

## 📦 Dependencies

```bash
# Arch/Manjaro
sudo pacman -S cava kitty jq hyprland waybar
yay -S matugen swww  # or paru -S matugen swww
```

**Required:**
- `cava` - Audio visualizer
- `kitty` - Terminal emulator
- `jq` - JSON processor
- `hyprland` - Window manager
- `waybar` - Status bar
- `matugen` - Color theme generator
- `swww` or `hyprpaper` - Wallpaper daemon

## 🚀 Installation

### 1. Copy Scripts

```bash
# Copy all scripts to waybar scripts folder
cp waybar/scripts/* ~/.config/waybar/scripts/

# Make them executable
chmod +x ~/.config/waybar/scripts/cava-opener.sh
chmod +x ~/.config/waybar/scripts/restart-cava.sh
chmod +x ~/.config/waybar/scripts/restart-cava-top.sh
```

### 2. Add Waybar Modules

Add to your `~/.config/waybar/config`:

```json
"modules-center": [
    "custom/cava-left",
    "hyprland/window",
    "custom/cava-right"
]
```

Then copy the module definitions from `waybar/modules.json.snippet` to your `~/.config/waybar/modules.json`

### 3. Setup Matugen Templates

```bash
# Copy templates
mkdir -p ~/.config/matugen/templates
cp matugen/templates/* ~/.config/matugen/templates/
```

Add the content from `matugen/config.toml.snippet` to your `~/.config/matugen/config.toml`

### 4. Add Hyprland Rules

Add to your `~/.config/hypr/hyprland.conf`:

```conf
source = ~/.config/hypr/cava-rules.conf
```

Then copy `hypr/cava-rules.conf` to `~/.config/hypr/`

### 5. Reload Everything

```bash
hyprctl reload
killall waybar && waybar &
matugen image /path/to/your/wallpaper.jpg
```

## 🎮 Usage

- **Left click on left Cava** → Opens top visualization (bars going down)
- **Left click on right Cava** → Opens bottom visualization (bars going up)  
- **Click again** → Closes the visualization
- **Change wallpaper** → Colors automatically update

## 🎨 Customization

### Window Size

Edit `~/.config/hypr/cava-rules.conf`:
```conf
windowrulev2 = size 100% 10%, title:^(cava_top)$    # 10% height
windowrulev2 = size 100% 15%, title:^(cava_bottom)$ # 15% height
```

### Transparency

Edit `~/.config/waybar/scripts/cava-opener.sh` line 31:
```bash
-o background_opacity=0.0  # 0.0 = fully transparent, 1.0 = opaque
```

### Colors

Colors are auto-generated from wallpaper. To manually adjust, edit:
- `~/.config/cava/config_top`
- `~/.config/cava/config_bottom`

## 🔧 Troubleshooting

**Cava doesn't open:**
```bash
killall -9 cava
~/.config/waybar/scripts/cava-opener.sh bottom
```

**Too many Cava processes running:**
```bash
killall -9 cava
```

**Colors don't update after wallpaper change:**
```bash
matugen image $(swww query | grep -oP 'image: \K.*')
```

## 📝 Notes

- This setup uses Kitty terminal. If you use a different terminal, adjust the scripts accordingly.
- The small Waybar visualizations require ML4W's `cava-waybar.sh` script. If you don't have it, replace with static icons.
- Window positioning works best with floating windows in Hyprland.

## 📄 License

MIT License - Feel free to use and modify!

## 🙏 Credits

Created through many iterations and debugging sessions 😅
EOF

echo "✅ Created README.md"

# Create waybar/modules.json.snippet
cat > waybar/modules.json.snippet << 'EOF'
// Add these modules to your ~/.config/waybar/modules.json

"custom/cava-left": {
    "exec": "~/.config/ml4w/scripts/cava-waybar.sh",
    "format": "{}",
    "return-type": "",
    "interval": 0,
    "escape": false,
    "tooltip": false,
    "on-click": "~/.config/waybar/scripts/cava-opener.sh top"
},

"custom/cava-right": {
    "exec": "~/.config/ml4w/scripts/cava-waybar.sh",
    "format": "{}",
    "return-type": "",
    "interval": 0,
    "escape": false,
    "tooltip": false,
    "on-click": "~/.config/waybar/scripts/cava-opener.sh bottom"
}

// Note: If you don't have ML4W's cava-waybar.sh, replace "exec" with a static icon:
// "format": " 🎵 "
EOF

echo "✅ Created waybar/modules.json.snippet"

# Create waybar/scripts/restart-cava.sh
cat > waybar/scripts/restart-cava.sh << 'EOF'
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
EOF

chmod +x waybar/scripts/restart-cava.sh
echo "✅ Created waybar/scripts/restart-cava.sh"

# Create waybar/scripts/restart-cava-top.sh
cat > waybar/scripts/restart-cava-top.sh << 'EOF'
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
EOF

chmod +x waybar/scripts/restart-cava-top.sh
echo "✅ Created waybar/scripts/restart-cava-top.sh"

# Copy cava-opener.sh from your system
if [ -f ~/.config/waybar/scripts/cava-opener.sh ]; then
    cp ~/.config/waybar/scripts/cava-opener.sh waybar/scripts/
    chmod +x waybar/scripts/cava-opener.sh
    echo "✅ Copied waybar/scripts/cava-opener.sh from your system"
else
    echo "⚠️  Please manually copy cava-opener.sh to waybar/scripts/"
fi

# Create matugen/config.toml.snippet
cat > matugen/config.toml.snippet << 'EOF'
# Add these templates to your ~/.config/matugen/config.toml

[templates.cava]
input_path = '~/.config/matugen/templates/cava_bottom.conf'
output_path = '~/.config/cava/config_bottom'
post_hook = '~/.config/waybar/scripts/restart-cava.sh'

[templates.cava_top]
input_path = '~/.config/matugen/templates/cava_top.conf'
output_path = '~/.config/cava/config_top'
post_hook = '~/.config/waybar/scripts/restart-cava-top.sh'
EOF

echo "✅ Created matugen/config.toml.snippet"

# Create matugen/templates/cava_bottom.conf
cat > matugen/templates/cava_bottom.conf << 'EOF'
[general]
framerate = 60
bars = 0

[input]
method = pulse
source = auto

[output]
method = noncurses

[color]
gradient = 1
gradient_count = 6
gradient_color_1 = '{{colors.primary.default.hex}}'
gradient_color_2 = '{{colors.secondary.default.hex}}'
gradient_color_3 = '{{colors.tertiary.default.hex}}'
gradient_color_4 = '{{colors.tertiary.default.hex}}'
gradient_color_5 = '{{colors.secondary.default.hex}}'
gradient_color_6 = '{{colors.primary.default.hex}}'

[smoothing]
noise_reduction = 77

[eq]
EOF

echo "✅ Created matugen/templates/cava_bottom.conf"

# Create matugen/templates/cava_top.conf
cat > matugen/templates/cava_top.conf << 'EOF'
[general]
framerate = 60
bars = 0

[input]
method = pulse
source = auto

[output]
method = noncurses
orientation = top

[color]
gradient = 1
gradient_count = 6
gradient_color_1 = '{{colors.primary.default.hex}}'
gradient_color_2 = '{{colors.secondary.default.hex}}'
gradient_color_3 = '{{colors.tertiary.default.hex}}'
gradient_color_4 = '{{colors.tertiary.default.hex}}'
gradient_color_5 = '{{colors.secondary.default.hex}}'
gradient_color_6 = '{{colors.primary.default.hex}}'

[smoothing]
noise_reduction = 77

[eq]
EOF

echo "✅ Created matugen/templates/cava_top.conf"

# Create hypr/cava-rules.conf
cat > hypr/cava-rules.conf << 'EOF'
# Hyprland Window Rules for Cava
# Add to your hyprland.conf: source = ~/.config/hypr/cava-rules.conf

# Cava Top Window (flipped, bars go down)
windowrulev2 = float, title:^(cava_top)$
windowrulev2 = noborder, title:^(cava_top)$
windowrulev2 = size 100% 10%, title:^(cava_top)$
windowrulev2 = move 0% 0%, title:^(cava_top)$
windowrulev2 = nofocus, title:^(cava_top)$
windowrulev2 = opacity 0.95 0.95, title:^(cava_top)$

# Cava Bottom Window (normal, bars go up)
windowrulev2 = float, title:^(cava_bottom)$
windowrulev2 = noborder, title:^(cava_bottom)$
windowrulev2 = size 100% 10%, title:^(cava_bottom)$
windowrulev2 = move 0% 90%, title:^(cava_bottom)$
windowrulev2 = nofocus, title:^(cava_bottom)$
windowrulev2 = opacity 0.95 0.95, title:^(cava_bottom)$
EOF

echo "✅ Created hypr/cava-rules.conf"

# Create .gitignore
cat > .gitignore << 'EOF'
# OS
.DS_Store
Thumbs.db

# Editor
.vscode/
.idea/
*.swp
*.swo
*~
EOF

echo "✅ Created .gitignore"

echo ""
echo "🎉 All files created successfully!"
echo ""
echo "Next steps:"
echo "1. Add your screenshot to screenshots/demo.png"
echo "2. Review all files"
echo "3. git add ."
echo "4. git commit -m 'Initial commit'"
echo "5. git remote add origin https://github.com/YOUR-USERNAME/cava-setup"
echo "6. git push -u origin main"
EOF

chmod +x setup-files.sh
echo "✅ Setup script created!"