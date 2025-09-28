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

## convert-to-mkdocs
Convert raw website mirrors into MkDocs-friendly documentation sites.
- **Language:** Python (uses uv for dependency management)
- **Dependencies:** None (uses only Python standard library)
- **Requirements:** uv package manager only

**Features:**
- Converts mirrored HTML pages to Markdown with embedded HTML
- Preserves page titles and navigation structure
- Rewrites internal links for offline browsing
- Copies assets to appropriate locations
- Generates MkDocs configuration automatically
- Works with mirror-site output or any HTML file structure

**Usage:** `convert-to-mkdocs --mirror-folder MIRROR --output-folder OUTPUT [options]`

**Examples:**
```bash
# Convert a mirrored documentation site
convert-to-mkdocs --mirror-folder docs-mirror \
                  --output-folder mkdocs-site \
                  --base-url https://docs.example.com/ \
                  --write-config

# Convert with custom structure
convert-to-mkdocs --mirror-folder site-mirror \
                  --output-folder my-docs \
                  --docs-subdir content \
                  --write-config

# Silent conversion for automation
convert-to-mkdocs --mirror-folder ./mirror \
                  --output-folder ./site \
                  --silent --write-config
```

**Note:** Works perfectly with mirror-site output that includes metadata!

## mkdocs-serve
Robust MkDocs development server wrapper with automatic setup.
- **Language:** Python (uses uv for dependency management)
- **Dependencies:** None (optionally installs mkdocs and mkdocs-material via uv)
- **Requirements:** uv package manager only

**Features:**
- Automatically creates minimal mkdocs.yml if missing
- Creates placeholder docs/index.md if needed
- Optionally installs MkDocs and Material theme via uv
- Flexible host and port configuration
- Works with any MkDocs project structure

**Usage:** `mkdocs-serve --project-root PROJECT_DIR [options]`

**Examples:**
```bash
# Serve a converted mirror site
mkdocs-serve --project-root ./mkdocs-site --install-deps

# Serve with custom host and port
mkdocs-serve --project-root ./docs \
             --host 0.0.0.0 \
             --port 8080 \
             --install-deps

# Serve with custom docs directory
mkdocs-serve --project-root ./my-project \
             --docs-subdir content \
             --theme readthedocs

# Silent mode for automation
mkdocs-serve --project-root ./site \
             --install-deps \
             --silent
```

**Note:** Perfect companion to convert-to-mkdocs for serving converted website mirrors!

## mkdocs-portable
Create portable, self-contained MkDocs documentation sites.
- **Language:** Python (uses uv for dependency management)
- **Dependencies:** None (uses only Python standard library)
- **Requirements:** uv package manager only

**Features:**
- Creates portable MkDocs sites with cross-platform run scripts
- Generates automatic navigation from file structure
- Optional Electron desktop application support
- Self-contained with uv dependency management
- Works with any collection of markdown files

**Usage:** `mkdocs-portable --source-folder SOURCE --target-folder TARGET [options]`

**Examples:**
```bash
# Create basic portable site
mkdocs-portable --source-folder docs --target-folder portable_docs

# Create with custom site information
mkdocs-portable --source-folder studyguide \
                --target-folder my_docs \
                --site-name "My Documentation" \
                --site-description "Comprehensive guide"

# Create with Electron desktop app files
mkdocs-portable --source-folder docs \
                --target-folder portable_docs \
                --with-electron

# Create and build desktop applications automatically
mkdocs-portable --source-folder docs \
                --target-folder portable_docs \
                --build-electron
```

**Note:** Perfect for creating offline documentation that can be shared and run anywhere!

## mkdocs-test
Test and validate portable MkDocs sites.
- **Language:** Python (uses uv for dependency management)
- **Dependencies:** None (uses only Python standard library)
- **Requirements:** uv package manager only

**Features:**
- Validates portable site structure and required files
- Tests MkDocs configuration validity
- Checks run scripts and permissions
- Validates Electron application files (if present)
- Provides detailed status reporting

**Usage:** `mkdocs-test --target-folder TARGET_FOLDER [options]`

**Examples:**
```bash
# Test a portable site
mkdocs-test --target-folder portable_docs

# Test with verbose output
mkdocs-test --target-folder my_docs --verbose

# Test specific components only
mkdocs-test --target-folder docs --check-files-only
```

**Note:** Essential for validating portable documentation before distribution!
