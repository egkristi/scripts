# Various Scripts

## Overview

The scripts, located in the `sbin/` directory, are various utility scripts to make life easier.

## Quick Start

**Requirements:** uv package manager (handles Python and dependencies automatically)

**Quick setup:**
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/egkristi/shell-scripts/refs/heads/main/init.sh)"
```

**📋 For detailed installation instructions, see [INSTALL.md](INSTALL.md)**

# shell-scripts

## cat-folder
A script to concatenate and display the contents of files in a specified folder.
- Supports filtering by file extensions and verbose output.
- Usage: `cat-folder [options] [directory]`
- Options:
  - `-i EXTENSIONS`: Include only files with specified extensions (comma-separated).
  - `-e EXTENSIONS`: Exclude files with specified extensions (comma-separated).
  - `-d DIRECTORY`: Specify target directory (alternative to providing it as last argument).
  - `-v`: Verbose mode (show skipped files).
  - `-h`: Show help message.

## mirror-site
General-purpose website mirroring tool with intelligent link rewriting.
- **Language:** Python (uses uv for dependency management)
- **Dependencies:** Automatically managed (chardet for encoding detection)
- **Requirements:** uv package manager only

**Features:**
- Crawls websites recursively with configurable depth limits
- Downloads HTML pages and assets (images, CSS, JS, PDFs, etc.)
- Rewrites internal links to work offline
- Respects robots.txt and implements polite crawling delays
- Generates comprehensive indexes (JSON and Markdown)
- Supports incremental updates and resume functionality
- Concurrent asset downloading for performance
- Extensive filtering and customization options

**Usage:** `mirror-site --website-url URL --target-folder DIR [options]`

**Examples:**
```bash
# Mirror a documentation site
mirror-site --website-url https://docs.example.com/ \
            --target-folder ./mirror \
            --same-domain --post-process

# Quick single-page download  
mirror-site --website-url https://site.com/page.html \
            --target-folder ./page \
            --link-depth 0

# Deep crawl with filtering
mirror-site --website-url https://site.com/ \
            --target-folder ./site \
            --include '/docs/' \
            --exclude '/admin/' \
            --max-pages 500
```

**Note:** Uses uv's inline dependencies - no manual package installation required!
