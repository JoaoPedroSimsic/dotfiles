#!/usr/bin/env bash
# Close any existing Grave pane, then open a fresh one

layout=$(zellij action dump-layout 2>/dev/null)

# Close existing Grave pane if it exists
if echo "$layout" | grep -q 'name="Grave"'; then
    pane_id=$(echo "$layout" | grep -oP 'pane[^>]*id=\K\d+(?=[^>]*name="Grave")' | head -1)
    if [ -n "$pane_id" ]; then
        zellij action close-pane --pane-id "$pane_id"
        sleep 0.1
    fi
fi

# Open fresh Grave pane
exec nu -c "use ~/.config/nushell/scripts/grave.nu *; grave switch"
