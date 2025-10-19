# Theme Automation Scripts

## auto-theme.sh

Automatically switches blog themes based on seasonal periods.

### How It Works

- Runs nightly at 12 AM EST via GitHub Actions
- Checks current date against seasonal periods
- Switches to appropriate seasonal theme or default
- Commits and pushes changes if theme switch occurs

### Seasonal Periods (Default)

| Theme | Start | End | Description |
|-------|-------|-----|-------------|
| Halloween | Oct 24 | Nov 1 | Spooky oranges and purples |
| Thanksgiving | Nov 15 | Nov 29 | Warm autumn harvest colors |
| Christmas | Dec 18 | Dec 26 | Festive reds, greens, and golds |
| Default | - | - | Catppuccin Macchiato (year-round) |

### Configuration via GitHub Actions Variables

Configure behavior without editing code:

**Repository Settings → Secrets and variables → Actions → Variables**

| Variable | Description | Example |
|----------|-------------|---------|
| `DEFAULT_THEME` | Theme used outside holiday periods | `palette17` |
| `HALLOWEEN_START` | Halloween period start date | `2025-10-20` |
| `HALLOWEEN_END` | Halloween period end date | `2025-11-02` |
| `THANKSGIVING_START` | Thanksgiving period start date | `2025-11-10` |
| `THANKSGIVING_END` | Thanksgiving period end date | `2025-11-30` |
| `CHRISTMAS_START` | Christmas period start date | `2025-12-15` |
| `CHRISTMAS_END` | Christmas period end date | `2025-12-27` |

**Note:** Dates use format `YYYY-MM-DD`. Omit variables to use defaults.

### Manual Testing

Test the script locally:

```bash
# Use default settings
./scripts/auto-theme.sh

# Override default theme
DEFAULT_THEME=palette17 ./scripts/auto-theme.sh

# Test with custom date periods
HALLOWEEN_START=2025-10-15 HALLOWEEN_END=2025-11-05 ./scripts/auto-theme.sh
```

### Exit Codes

- `0` - Theme was changed successfully
- `1` - No theme change needed (already correct theme)

### Requirements

- Bash shell
- Git repository with theme files in `assets/css/extended/`
- Themes must have `theme-id` in their CSS comment header
