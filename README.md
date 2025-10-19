# cat /proc/brain

A personal blog built with Hugo and the PaperMod theme. Dev diaries, technical musings, and occasional pop culture thoughts.

## Quick Start

### Prerequisites

Install [mise](https://mise.jdx.dev/) for tool version management:
```bash
curl https://mise.run | sh
```

### Setup

1. Clone the repository
2. Install tools:
   ```bash
   mise install
   ```
3. Initialize Hugo modules:
   ```bash
   hugo mod get
   ```

### Development

Run the development server (includes drafts):
```bash
mise run serve
```

Visit http://localhost:1313

### Create a New Post

```bash
mise run new -- 'Your Post Title'
```

This creates a new post in `content/posts/` with the current date and a slugified filename.

### Build for Production

```bash
mise run build
```

The site is generated to the `public/` directory.

### Switch Color Themes

The blog supports multiple color themes including seasonal palettes:

```bash
# List available themes
mise run theme-list

# Switch to a different theme
mise run theme catppuccin-macchiato  # Default, year-round
mise run theme palette17              # Bold vibrant colors

# Seasonal themes
mise run theme halloween              # Spooky oranges and purples (October)
mise run theme thanksgiving           # Warm autumn harvest (November)
mise run theme christmas              # Festive reds, greens, golds (December)
```

Themes include light and dark mode variants with coordinated syntax highlighting.

## Deployment

The blog is automatically deployed to GitHub Pages at https://duckpuppy.com.

Every push to `main` triggers a GitHub Actions workflow that:
- Builds the Hugo site with the latest content
- Deploys to GitHub Pages
- Updates the live site in 1-2 minutes

Check deployment status in the repository's "Actions" tab.

## Project Structure

```
.
├── content/
│   └── posts/          # Blog posts (markdown)
├── layouts/            # Custom layout overrides
├── static/             # Static assets
├── hugo.toml           # Hugo configuration
├── .mise.toml          # Tool versions and tasks
└── public/             # Generated site (git-ignored)
```

## Configuration

The site is configured in `hugo.toml`:
- Site metadata and URLs
- PaperMod theme settings
- Menu structure
- Syntax highlighting (Monokai theme)

The PaperMod theme is imported as a Hugo module, not a git submodule.

## Writing Posts

Posts are markdown files in `content/posts/` with TOML frontmatter:

```toml
+++
date = '2025-10-17T01:04:55-04:00'
draft = true
title = 'Your Post Title'
tags = ['tag1', 'tag2']
categories = ['category']
summary = 'Brief description for the post listing'
+++

Your content here...
```

Set `draft = false` when ready to publish.

## Theme

This blog uses [PaperMod](https://github.com/adityatelange/hugo-PaperMod), a fast and minimal Hugo theme. Theme customization is done via the `[params]` section in `hugo.toml`.

To override theme templates, create corresponding files in the `layouts/` directory.

## License

Blog content is my own. Hugo and PaperMod are licensed under their respective licenses.
