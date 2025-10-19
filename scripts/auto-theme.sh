#!/usr/bin/env bash
# Automatic seasonal theme switcher for Hugo blog
# Switches to seasonal themes one week before holidays, then back to default

set -euo pipefail

THEME_DIR="assets/css/extended"
ACTIVE_FILE="$THEME_DIR/theme-colors.css"
DEFAULT_THEME="${DEFAULT_THEME:-catppuccin-macchiato}"

# Get current date info
YEAR=$(date +%Y)
MONTH=$(date +%m | sed 's/^0*//')  # Remove leading zero
DAY=$(date +%d | sed 's/^0*//')    # Remove leading zero
DATE_STR=$(date +%Y-%m-%d)

# Function to get current active theme ID
get_current_theme() {
    if [ -f "$ACTIVE_FILE" ]; then
        grep "theme-id:" "$ACTIVE_FILE" | head -n1 | sed 's|.*theme-id: ||' | tr -d ' '
    else
        echo "none"
    fi
}

# Function to calculate days until a date
days_until() {
    local target_date="$1"
    local current_epoch=$(date +%s)
    local target_epoch=$(date -d "$target_date" +%s)
    echo $(( (target_epoch - current_epoch) / 86400 ))
}

# Function to switch theme
switch_theme() {
    local new_theme="$1"
    local current_theme=$(get_current_theme)

    if [ "$current_theme" = "$new_theme" ]; then
        echo "Already using $new_theme theme, no change needed"
        return 1
    fi

    local target_file="$THEME_DIR/${new_theme}.css.backup"

    if [ ! -f "$target_file" ]; then
        echo "Error: Theme '$new_theme' not found at $target_file"
        return 1
    fi

    # Backup current theme
    if [ -f "$ACTIVE_FILE" ]; then
        local current_id=$(get_current_theme)
        if [ -n "$current_id" ]; then
            local backup_name="$THEME_DIR/${current_id}.css.backup"
            mv "$ACTIVE_FILE" "$backup_name"
            echo "Backed up $current_id theme"
        fi
    fi

    # Activate new theme
    mv "$target_file" "$ACTIVE_FILE"
    echo "Switched to $new_theme theme"
    return 0
}

# Halloween: October 31
# Active period: Oct 24 - Nov 1 (configurable via env vars)
HALLOWEEN_START="${HALLOWEEN_START:-$YEAR-10-24}"
HALLOWEEN_END="${HALLOWEEN_END:-$YEAR-11-01}"

# Thanksgiving: 4th Thursday of November (approximate: Nov 22-28)
# Active period: Nov 15 - Nov 29 (configurable via env vars)
THANKSGIVING_START="${THANKSGIVING_START:-$YEAR-11-15}"
THANKSGIVING_END="${THANKSGIVING_END:-$YEAR-11-29}"

# Christmas: December 25
# Active period: Dec 18 - Dec 26 (configurable via env vars)
CHRISTMAS_START="${CHRISTMAS_START:-$YEAR-12-18}"
CHRISTMAS_END="${CHRISTMAS_END:-$YEAR-12-26}"

# Determine which theme should be active
DESIRED_THEME="$DEFAULT_THEME"

# Check if we're in a holiday period (order matters - Christmas overrides Thanksgiving if they overlap)
if [[ "$DATE_STR" > "$HALLOWEEN_START" && "$DATE_STR" < "$HALLOWEEN_END" ]]; then
    DESIRED_THEME="halloween"
    echo "Halloween season detected"
elif [[ "$DATE_STR" > "$THANKSGIVING_START" && "$DATE_STR" < "$THANKSGIVING_END" ]]; then
    DESIRED_THEME="thanksgiving"
    echo "Thanksgiving season detected"
elif [[ "$DATE_STR" > "$CHRISTMAS_START" ]] || [[ "$DATE_STR" < "$YEAR-01-02" ]]; then
    # Christmas period can span year boundary
    DESIRED_THEME="christmas"
    echo "Christmas season detected"
else
    echo "No holiday season active, using default theme"
fi

echo "Current date: $DATE_STR"
echo "Current theme: $(get_current_theme)"
echo "Desired theme: $DESIRED_THEME"

# Switch theme if needed
if switch_theme "$DESIRED_THEME"; then
    echo "Theme changed successfully!"
    exit 0
else
    echo "No theme change needed"
    exit 1
fi
