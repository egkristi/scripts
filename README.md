# Various Scripts

## Overview

The scripts, located in the `sbin/` directory, is various utility scripts to make life easier.

# shell-scripts
-folder-cat
  - A script to concatenate and display the contents of files in a specified folder.
  - Supports filtering by file extensions and verbose output.
  - Usage: `folder-cat [options] [directory]`
  - Options:
    - `-i EXTENSIONS`: Include only files with specified extensions (comma-separated).
    - `-e EXTENSIONS`: Exclude files with specified extensions (comma-separated).
    - `-d DIRECTORY`: Specify target directory (alternative to providing it as last argument).
    - `-v`: Verbose mode (show skipped files).
    - `-h`: Show help message.
