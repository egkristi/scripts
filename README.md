# Various Scripts

## Overview

The scripts, located in the `sbin/` directory, is various utility scripts to make life easier.

To start using the scripts, you can either:
1. run the init.sh directly from github, which will clone the repo into the current folder and initialize the environment:
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/egkristi/shell-scripts/refs/heads/main/init.sh)"
```
2. Clone the repository and run the init.sh script to set up the environment.
3. Manually copy the scripts to your local bin directory and add it to your PATH.

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
- Crawls websites recursively with configurable depth limits
- Downloads HTML pages and assets (images, CSS, JS, PDFs, etc.)
- Rewrites internal links to work offline
- Respects robots.txt and implements polite crawling delays
- Generates comprehensive indexes (JSON and Markdown)
- Supports incremental updates and resume functionality
- Concurrent asset downloading for performance
- Extensive filtering and customization options
- Usage: `mirror-site --website-url URL --target-folder DIR [options]`
- Examples:
  - `mirror-site --website-url https://docs.example.com/ --target-folder ./mirror --same-domain`
  - `mirror-site --website-url https://site.com/page.html --target-folder ./page --link-depth 0`
  - `mirror-site --website-url https://site.com/ --target-folder ./site --include '/docs/' --max-pages 500`
