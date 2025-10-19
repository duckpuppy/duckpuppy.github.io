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

The blog supports multiple color themes:

```bash
# List available themes
mise run theme-list

# Switch to a different theme
mise run theme palette17
mise run theme catppuccin-macchiato
```

Current themes include Catppuccin Macchiato (soothing pastels) and Palette #17 (bold vibrant colors).

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
