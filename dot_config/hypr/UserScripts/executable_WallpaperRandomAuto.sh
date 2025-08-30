#!/bin/bash


wallDIR="$HOME/Pictures/wallpapers"
SCRIPTSDIR="$HOME/.config/hypr/scripts"

focused_monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')
FPS=240
TYPE="random"
DURATION=1
BEZIER=".43,1.19,1,.4"
SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION --transition-bezier $BEZIER"
INTERVAL=900
PICS=($(find -L ${wallDIR} -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.pnm" -o -name "*.tga" -o -name "*.tiff" -o -name "*.webp" -o -name "*.bmp" -o -name "*.farbfeld" -o -name "*.gif" \)))

while true; do
    # random file direkt auswählen
    RANDOMPICS=${PICS[ $RANDOM % ${#PICS[@]} ]}

    if [[ -n "$RANDOMPICS" ]]; then
        swww query || swww-daemon --format xrgb && swww img -o $focused_monitor ${RANDOMPICS} $SWWW_PARAMS
        
        wait $!
        "$SCRIPTSDIR/WallustSwww.sh" &&
        
        wait $!
        sleep 2
        "$SCRIPTSDIR/Refresh.sh"
    fi
    
    sleep $INTERVAL
done
