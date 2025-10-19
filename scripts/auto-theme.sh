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

# Function to calculate Easter Sunday using Computus algorithm (Gregorian calendar)
calculate_easter() {
    local year=$1
    local a=$(( year % 19 ))
    local b=$(( year / 100 ))
    local c=$(( year % 100 ))
    local d=$(( b / 4 ))
    local e=$(( b % 4 ))
    local f=$(( (b + 8) / 25 ))
    local g=$(( (b - f + 1) / 3 ))
    local h=$(( (19 * a + b - d - g + 15) % 30 ))
    local i=$(( c / 4 ))
    local k=$(( c % 4 ))
    local l=$(( (32 + 2 * e + 2 * i - h - k) % 7 ))
    local m=$(( (a + 11 * h + 22 * l) / 451 ))
    local month=$(( (h + l - 7 * m + 114) / 31 ))
    local day=$(( ((h + l - 7 * m + 114) % 31) + 1 ))
    printf "%d-%02d-%02d" "$year" "$month" "$day"
}

# Calculate Easter and its period
EASTER_DATE=$(calculate_easter $YEAR)
EASTER_OFFSET_BEFORE="${EASTER_OFFSET_BEFORE:-7}"
EASTER_OFFSET_AFTER="${EASTER_OFFSET_AFTER:-7}"
EASTER_START=$(date -d "$EASTER_DATE - $EASTER_OFFSET_BEFORE days" +%Y-%m-%d)
EASTER_END=$(date -d "$EASTER_DATE + $EASTER_OFFSET_AFTER days" +%Y-%m-%d)

# New Year: January 1
# Active period: Dec 27 - Jan 7 (configurable via env vars)
NEW_YEAR_START="${NEW_YEAR_START:-$(($YEAR-1))-12-27}"
NEW_YEAR_END="${NEW_YEAR_END:-$YEAR-01-07}"

# Anniversary: February 4
# Active period: February 4 only (configurable via env vars)
ANNIVERSARY_START="${ANNIVERSARY_START:-$YEAR-02-04}"
ANNIVERSARY_END="${ANNIVERSARY_END:-$YEAR-02-05}"

# Valentine's Day: February 14
# Active period: Feb 7 - Feb 15 (configurable via env vars)
VALENTINES_START="${VALENTINES_START:-$YEAR-02-07}"
VALENTINES_END="${VALENTINES_END:-$YEAR-02-15}"

# Memorial Day: Last Monday of May
# Active period: Week before Memorial Day (configurable via env vars)
MEMORIAL_DAY_START="${MEMORIAL_DAY_START:-$YEAR-05-19}"
MEMORIAL_DAY_END="${MEMORIAL_DAY_END:-$YEAR-05-26}"

# Birthday: July 1
# Active period: July 1 only (configurable via env vars)
BIRTHDAY_START="${BIRTHDAY_START:-$YEAR-07-01}"
BIRTHDAY_END="${BIRTHDAY_END:-$YEAR-07-02}"

# Independence Day: July 4
# Active period: Week before through week after (configurable via env vars)
INDEPENDENCE_DAY_START="${INDEPENDENCE_DAY_START:-$YEAR-06-27}"
INDEPENDENCE_DAY_END="${INDEPENDENCE_DAY_END:-$YEAR-07-11}"

# Labor Day: First Monday of September
# Active period: Week before through week after (configurable via env vars)
LABOR_DAY_START="${LABOR_DAY_START:-$YEAR-08-25}"
LABOR_DAY_END="${LABOR_DAY_END:-$YEAR-09-08}"

# Fall: Mid-September through late October
# Active period: Between Labor Day and Halloween (configurable via env vars)
FALL_START="${FALL_START:-$YEAR-09-15}"
FALL_END="${FALL_END:-$YEAR-10-23}"

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
# Priority order: Specific holidays > Seasonal themes > Default
DESIRED_THEME="$DEFAULT_THEME"

# Check if we're in a holiday period (check most specific first)
if [[ ("$DATE_STR" > "$NEW_YEAR_START" && "$MONTH" == "12") || ("$MONTH" == "1" && "$DATE_STR" < "$NEW_YEAR_END") ]]; then
    DESIRED_THEME="new-year"
    echo "New Year season detected ($NEW_YEAR_START to $NEW_YEAR_END)"
elif [[ "$DATE_STR" > "$ANNIVERSARY_START" && "$DATE_STR" < "$ANNIVERSARY_END" ]]; then
    DESIRED_THEME="anniversary"
    echo "Anniversary detected! 💍 ($ANNIVERSARY_START)"
elif [[ "$DATE_STR" > "$VALENTINES_START" && "$DATE_STR" < "$VALENTINES_END" ]]; then
    DESIRED_THEME="valentines"
    echo "Valentine's Day season detected ($VALENTINES_START to $VALENTINES_END)"
elif [[ "$DATE_STR" > "$EASTER_START" && "$DATE_STR" < "$EASTER_END" ]]; then
    DESIRED_THEME="easter"
    echo "Easter season detected ($EASTER_START to $EASTER_END, Easter: $EASTER_DATE)"
elif [[ "$DATE_STR" > "$MEMORIAL_DAY_START" && "$DATE_STR" < "$MEMORIAL_DAY_END" ]]; then
    DESIRED_THEME="memorial-day"
    echo "Memorial Day season detected ($MEMORIAL_DAY_START to $MEMORIAL_DAY_END)"
elif [[ "$DATE_STR" > "$BIRTHDAY_START" && "$DATE_STR" < "$BIRTHDAY_END" ]]; then
    DESIRED_THEME="birthday"
    echo "Birthday detected! 🎂 ($BIRTHDAY_START)"
elif [[ "$DATE_STR" > "$INDEPENDENCE_DAY_START" && "$DATE_STR" < "$INDEPENDENCE_DAY_END" ]]; then
    DESIRED_THEME="independence-day"
    echo "Independence Day season detected ($INDEPENDENCE_DAY_START to $INDEPENDENCE_DAY_END)"
elif [[ "$DATE_STR" > "$LABOR_DAY_START" && "$DATE_STR" < "$LABOR_DAY_END" ]]; then
    DESIRED_THEME="labor-day"
    echo "Labor Day season detected ($LABOR_DAY_START to $LABOR_DAY_END)"
elif [[ "$DATE_STR" > "$FALL_START" && "$DATE_STR" < "$FALL_END" ]]; then
    DESIRED_THEME="fall"
    echo "Fall season detected ($FALL_START to $FALL_END)"
elif [[ "$DATE_STR" > "$HALLOWEEN_START" && "$DATE_STR" < "$HALLOWEEN_END" ]]; then
    DESIRED_THEME="halloween"
    echo "Halloween season detected ($HALLOWEEN_START to $HALLOWEEN_END)"
elif [[ "$DATE_STR" > "$THANKSGIVING_START" && "$DATE_STR" < "$THANKSGIVING_END" ]]; then
    DESIRED_THEME="thanksgiving"
    echo "Thanksgiving season detected ($THANKSGIVING_START to $THANKSGIVING_END)"
elif [[ "$DATE_STR" > "$CHRISTMAS_START" ]] || [[ "$DATE_STR" < "$(($YEAR+1))-01-02" ]]; then
    # Christmas period can span year boundary
    DESIRED_THEME="christmas"
    echo "Christmas season detected ($CHRISTMAS_START to $(($YEAR+1))-01-02)"
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
