#!/usr/bin/env bash
# Toggle gnome-calculator:
#   - window focused        -> close it
#   - window exists, unfocused -> focus it
#   - no window             -> launch it
set -euo pipefail

APP_ID="org.gnome.Calculator"

window_info=$(
    niri msg -j windows | jq -r --arg app "$APP_ID" '
        [ .[] | select(.app_id == $app) ]
        | (first // empty)
        | "\(.id) \(.is_focused)"
    '
)

if [[ -n "$window_info" ]]; then
    read -r id focused <<< "$window_info"
    if [[ "$focused" == "true" ]]; then
        niri msg action close-window --id "$id"
    else
        niri msg action focus-window --id "$id"
    fi
    exit 0
fi

setsid -f gnome-calculator >/dev/null 2>&1
