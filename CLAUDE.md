# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a personal blog built with Hugo static site generator, using the PaperMod theme. The blog is titled "cat /proc/brain" and covers dev diaries, technical posts, and pop culture topics.

## Development Environment

The project uses `mise` for tool version management. Tools are defined in `.mise.toml`:
- `hugo-extended` (latest)
- `go` (latest)
- `just` (latest)

Run `mise install` to ensure all tools are installed.

## Common Commands

### Development Server
```bash
mise run serve
# or directly:
hugo server -D --bind 0.0.0.0
```
The `-D` flag includes draft posts. The server runs on port 1313 by default.

### Build for Production
```bash
mise run build
# or directly:
HUGO_ENV=production hugo --minify
```
Builds the site to the `public/` directory.

### Create New Post
```bash
mise run new -- 'Your Post Title'
```
Creates a new post in `content/posts/` with the date and slugified title.

## Deployment

The site is automatically deployed to GitHub Pages using GitHub Actions.

### Initial Setup (One-time)

1. **Archive old repository** (on GitHub web):
   - Rename `duckpuppy.github.io` to `duckpuppy.github.io-archive`
   - Disable GitHub Pages on the archived repo

2. **Create new repository** (on GitHub web):
   - Create new public repo named `duckpuppy.github.io`
   - Don't initialize with README

3. **Configure GitHub Pages** (on GitHub web):
   - Go to Settings → Pages
   - Source: **GitHub Actions** (not branch)
   - Custom domain: `duckpuppy.com`
   - Enable "Enforce HTTPS" after DNS propagates

4. **Push to new repository**:
   ```bash
   git remote add origin git@github.com:duckpuppy/duckpuppy.github.io.git
   git push -u origin main
   ```

### Automatic Deployment

Every push to `main` triggers the GitHub Actions workflow (`.github/workflows/hugo.yaml`):
- Installs Hugo extended v0.148.1
- Builds the site with minification
- Deploys to GitHub Pages
- Typically completes in 1-2 minutes

View deployment status in the "Actions" tab on GitHub.

### Manual Deployment

To trigger a deployment manually:
- Go to Actions → Deploy Hugo site to Pages → Run workflow

### Local Testing Before Deploy

Always test locally before pushing:
```bash
mise run serve  # Test with drafts
mise run build  # Test production build
```

## Project Structure

- **`hugo.toml`**: Main Hugo configuration file
  - Site metadata, theme settings, menu structure
  - Uses Hugo Modules to import PaperMod theme from GitHub
  - PaperMod settings configured under `[params]`

- **`content/posts/`**: Blog post markdown files
  - Use frontmatter with `date`, `title`, `tags`, `categories`, `summary`, and `draft`

- **`layouts/`**: Custom Hugo layouts (currently empty, defaults to theme)

- **`static/`**: Static assets served directly

- **`public/`**: Generated site output (git-ignored)

- **`go.mod`/`go.sum`**: Hugo module dependencies (PaperMod theme)

## Theme: PaperMod

The site uses the PaperMod theme imported as a Hugo module:
```toml
[[module.imports]]
  path = "github.com/adityatelange/hugo-PaperMod"
```

Theme customization is done via `[params]` in `hugo.toml`, not by modifying theme files. To override theme templates, create corresponding files in the `layouts/` directory.

## Content Guidelines

Blog posts should include frontmatter:
```yaml
+++
date = '2025-10-17T01:04:55-04:00'
draft = true
title = 'Your Title'
tags = ['tag1', 'tag2']
categories = ['category']
summary = 'Brief description'
+++
```

Posts are in `content/posts/` and support all Hugo markdown features including syntax highlighting (configured for Monokai style with line numbers).

## Color Schemes

The blog has multiple color schemes available in `assets/css/extended/`.

**Automatic Seasonal Switching:** Themes automatically switch based on the calendar:
- Halloween theme activates Oct 24 - Nov 1
- Thanksgiving theme activates Nov 15 - Nov 29
- Christmas theme activates Dec 18 - Dec 26
- Default (Catppuccin Macchiato) used outside holiday periods

The nightly build (12 AM EST) runs `scripts/auto-theme.sh` to check and switch themes automatically.

**Configuring Automation:** Set GitHub Actions variables to customize behavior:
- Go to: Settings → Secrets and variables → Actions → Variables tab
- Available variables:
  - `DEFAULT_THEME` - Theme to use outside holiday periods (default: `catppuccin-macchiato`)
  - `HALLOWEEN_START` / `HALLOWEEN_END` - Override Halloween period (format: `YYYY-MM-DD`)
  - `THANKSGIVING_START` / `THANKSGIVING_END` - Override Thanksgiving period
  - `CHRISTMAS_START` / `CHRISTMAS_END` - Override Christmas period

Example: To use Palette #17 as default, create variable `DEFAULT_THEME` with value `palette17`.

### Default: Catppuccin Macchiato
- Official Catppuccin Macchiato palette
- Soothing pastel colors with medium contrast
- Dark mode: `#24273a` base with pastel accents
- Light mode: Lighter variant with adjusted contrast
- Best for: Year-round use, easy on the eyes

### Seasonal Themes

**Halloween**
- Spooky oranges, purples, and blacks
- Colors: `#ff6600` (pumpkin), `#9933ff` (purple), `#00ff00` (neon green)
- Best for: October festivities

**Thanksgiving**
- Warm autumn harvest colors
- Colors: `#8b4513` (saddle brown), `#ff8c00` (dark orange), `#daa520` (goldenrod)
- Best for: November, cozy autumn vibes

**Christmas**
- Festive reds, greens, and golds
- Colors: `#165b33` (evergreen), `#bb2528` (christmas red), `#f8b229` (gold)
- Best for: December holiday season

### Other Themes

**Palette #17**
- Bold, modern palette with vibrant accents
- Colors: `#272727`, `#747474`, `#FF652F`, `#FFE400`, `#14A76C`
- Best for: High energy, modern aesthetic

### Switching Color Schemes

Use the mise task for easy theme switching:

```bash
# List available themes
mise run theme-list

# Switch to a theme (no arguments shows available themes)
mise run theme

# Switch to a specific theme
mise run theme palette17
mise run theme catppuccin-macchiato

# Seasonal themes (or wait for automatic switching!)
mise run theme halloween
mise run theme thanksgiving
mise run theme christmas
```

**Note:** Seasonal themes switch automatically during their active periods. Manual switching overrides automation until the next nightly build.

The active theme is always `theme-colors.css`. Inactive themes are stored as `*.css.backup` files.

### Adding New Themes

To add a new theme:

1. Create a new CSS file in `assets/css/extended/` with this header format:
   ```css
   /* Your Theme Name color scheme
    * theme-id: your-theme-id
    * Optional description
    */
   ```

2. Save it as `your-theme-id.css.backup`

3. Use `mise run theme your-theme-id` to activate it

Hugo automatically includes all CSS files in `assets/css/extended/` that match `*.css` (not `*.backup`).

## TOML Formatting

The project uses `taplo` for TOML formatting (configured in `.taplo.toml`). TOML files are formatted with aligned entries and indented tables/entries.
