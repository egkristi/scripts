# Various Scripts

## Overview

The scripts, located in the `sbin/` directory, are various utility scripts to make life easier.

## Requirements

**For Python scripts:**
- **uv** package manager (handles Python versions and dependencies automatically)
- Python 3.8+ (automatically managed by uv)

**Install uv (one-time setup):**
```bash
# Unix/Mac
curl -LsSf https://astral.sh/uv/install.sh | sh

# Windows
irm https://astral.sh/uv/install.ps1 | iex
```

**For shell scripts:**
- Bash (usually pre-installed on Unix/Mac/WSL)

## Setup

To start using the scripts, you can either:

1. **Quick setup** - Run the init.sh directly from GitHub:
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/egkristi/shell-scripts/refs/heads/main/init.sh)"
```

2. **Manual setup** - Clone the repository and run the init.sh script:
```bash
git clone https://github.com/egkristi/shell-scripts.git
cd shell-scripts
./init.sh
```

3. **Direct usage** - Use scripts directly without PATH setup:
```bash
./shell-scripts/sbin/script-name [options]
```

## Python Script Dependencies

Python scripts in this collection use **uv's inline dependencies feature**. This means:
- ✅ **No manual dependency installation required**
- ✅ **Automatic virtual environment management**
- ✅ **Isolated dependencies per script**
- ✅ **Consistent behavior across systems**
- ✅ **Only requirement: uv installed**

Dependencies are declared directly in each Python script and automatically installed when the script runs.

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
