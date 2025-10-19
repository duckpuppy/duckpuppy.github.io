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

The blog has two available color schemes in `assets/css/extended/`:

### Active: Catppuccin Macchiato (theme-colors.css)
- Official Catppuccin Macchiato palette
- Soothing pastel colors with medium contrast
- Dark mode: `#24273a` base with pastel accents
- Light mode: Lighter variant with adjusted contrast

### Available: Palette #17 (palette17.css.backup)
- Visme website color palette #17
- Bold, modern palette with vibrant accents
- Colors: `#272727`, `#747474`, `#FF652F`, `#FFE400`, `#14A76C`

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
```

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
