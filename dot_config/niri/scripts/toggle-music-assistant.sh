#!/usr/bin/env bash
# Toggle the Music Assistant window:
#   - window focused        -> close (the app keeps running in the tray)
#   - window exists, unfocused -> focus it
#   - no window, tray icon present -> click "Show" on the tray menu
#   - none of the above     -> launch the AppImage
set -euo pipefail

APP_ID="music-assistant-companion"
TRAY_TITLE="music-assistant-companion"
LAUNCHER="music-assistant-companion"

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

# No window: try the tray menu, fall back to launching the binary.
TRAY_TITLE="$TRAY_TITLE" python3 - <<'PY' && exit 0
import os, sys, time
try:
    import dbus
except ImportError:
    sys.exit(1)

target_title = os.environ["TRAY_TITLE"]
bus = dbus.SessionBus()

try:
    snw = bus.get_object("org.kde.StatusNotifierWatcher", "/StatusNotifierWatcher")
    items = dbus.Interface(snw, "org.freedesktop.DBus.Properties").Get(
        "org.kde.StatusNotifierWatcher", "RegisteredStatusNotifierItems"
    )
except dbus.exceptions.DBusException:
    sys.exit(1)

owner = item_path = None
for entry in items:
    name, _, path = str(entry).partition("/")
    path = "/" + path
    try:
        props = dbus.Interface(bus.get_object(name, path), "org.freedesktop.DBus.Properties")
        if str(props.Get("org.kde.StatusNotifierItem", "Title")) == target_title:
            owner, item_path = name, path
            break
    except dbus.exceptions.DBusException:
        continue

if not owner:
    sys.exit(1)

try:
    menu_path = str(
        dbus.Interface(bus.get_object(owner, item_path), "org.freedesktop.DBus.Properties")
        .Get("org.kde.StatusNotifierItem", "Menu")
    )
    menu = dbus.Interface(bus.get_object(owner, menu_path), "com.canonical.dbusmenu")
    _, layout = menu.GetLayout(0, -1, [])
except dbus.exceptions.DBusException:
    sys.exit(1)

show_id = None
for child in layout[2]:
    cid, props_d, _ = child
    label = str(props_d.get("label", "")).strip().lower()
    if label in ("show", "open", "show window", "restore"):
        show_id = int(cid)
        break

if show_id is None:
    sys.exit(1)

menu.Event(dbus.Int32(show_id), "clicked", dbus.String("", variant_level=1), dbus.UInt32(int(time.time())))
PY

setsid -f "$LAUNCHER" >/dev/null 2>&1
