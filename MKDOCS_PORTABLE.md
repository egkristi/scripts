# Portable Documentation Builder

This document describes how to use the `sbin/mkdocs-portable` script to create portable, self-contained documentation sites and desktop applications from any MkDocs-compatible documentation.

## Overview

The `mkdocs-portable` script transforms any collection of markdown files into multiple distribution formats:

1. **Web Server Version** - Requires uv, runs as local web server
2. **Desktop Applications** - Standalone apps for Windows, Mac, and Linux (no dependencies)
3. **Source Package** - Complete source with build scripts for customization

## Quick Start

### Basic Usage

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

### Prerequisites

**For Web Server Version:**
- Python 3.8+ (automatically managed by uv)
- uv package manager

**For Desktop Applications:**
- Node.js 16+ (for building Electron apps)
- npm (usually comes with Node.js)

## Command-Line Options

### Required Arguments

| Argument | Description |
|----------|-------------|
| `--target-folder` | Target folder for the portable site |

### Optional Arguments

| Argument | Description | Default |
|----------|-------------|---------|
| `--site-name` | Name of the documentation site | `Documentation` |
| `--site-description` | Description of the documentation site | `Portable documentation site` |
| `--site-author` | Author of the documentation site | `Documentation Team` |
| `--with-electron` | Include Electron desktop application files | `False` |
| `--build-electron` | Build Electron applications after creating files | `False` |
| `--help` | Show help message and exit | - |

### Examples
{{ ... }}

```bash
# Help and information
mkdocs-portable --help

# Basic site creation
mkdocs-portable --source-folder docs --target-folder portable_docs

# Custom source and target folders
mkdocs-portable \
  --source-folder my_studyguide \
  --target-folder my_portable_docs

# Include Electron files for manual building
mkdocs-portable \
  --source-folder studyguide \
  --target-folder studyguide_electron \
  --with-electron

# Automatically build desktop applications
mkdocs-portable \
  --source-folder studyguide \
  --target-folder studyguide_apps \
  --build-electron
```

## Output Structure

### Web Server Version

```
target_folder/
├── docs/                    # All documentation markdown files
│   ├── index.md            # Main page
│   ├── *.md                # All documentation files
│   └── subdirs/            # Any subdirectories with documentation
│   └── optional/           # 27+ optional topic files
├── mkdocs.yml              # MkDocs configuration
├── pyproject.toml          # uv/Python dependencies
├── run_windows.bat         # Windows launcher
├── run_windows.ps1         # Windows PowerShell launcher
├── run_unix.sh             # Mac/Linux launcher
├── README.md               # Usage instructions
└── .gitignore              # Version control exclusions
```

### Desktop Application Version

When using `--with-electron` or `--build-electron`, additional files are created:

```
target_folder/
├── [all web server files above]
├── package.json                 # Node.js/Electron configuration
├── electron/                    # Electron application files
│   ├── main.js                 # Main Electron process
│   └── assets/                 # Application assets
│       └── icon.svg            # Application icon
├── build_electron_apps.sh      # Unix build script
├── build_electron_apps.bat     # Windows build script
└── dist/                       # Built applications (if --build-electron used)
    ├── INF100 Study Guide Setup 1.0.0.exe      # Windows installer (~143MB)
    ├── INF100 Study Guide-1.0.0.dmg            # Mac Intel app (~100MB)
    ├── INF100 Study Guide-1.0.0-arm64.dmg      # Mac Apple Silicon app (~95MB)
    └── INF100 Study Guide-1.0.0.AppImage       # Linux portable app (~105MB)
```

## Distribution Methods

### Method 1: Web Server (Requires uv)

**Best for:** Developers, technical users, customization

**Steps:**
1. Run the build script: `uv run scripts/build_portable_docs.py`
2. Distribute the entire output folder
3. Users run the appropriate launcher script:
   - Windows: `run_windows.bat` or `run_windows.ps1`
   - Mac/Linux: `./run_unix.sh`
4. Documentation opens at `http://localhost:8000`

**Advantages:**
- Small file size (just markdown + config)
- Easy to update content
- Full MkDocs features (search, themes, etc.)

**Requirements:**
- Users need uv installed
- Internet connection for initial uv setup

### Method 2: Desktop Applications (No Dependencies)

**Best for:** End users, students, wide distribution

**Steps:**
1. Build applications: `uv run scripts/build_portable_docs.py --build-electron`
2. Distribute the built applications from `dist/` folder
3. Users simply download and run:
   - Windows: Run the `.exe` installer
   - Mac: Open `.dmg` and drag to Applications
   - Linux: Make `.AppImage` executable and run

**Advantages:**
- Zero dependencies for end users
- Professional desktop application experience
- Offline functionality
- Native OS integration (menus, shortcuts)

**Requirements:**
- Node.js for building (not for end users)
- Larger file sizes (95-143MB per platform)

### Method 3: Source Package (For Customization)

**Best for:** Course instructors, customization, CI/CD

**Steps:**
1. Create with Electron files: `uv run scripts/build_portable_docs.py --with-electron`
2. Distribute entire folder with build scripts
3. Recipients can:
   - Run web server version immediately
   - Build desktop apps with `./build_electron_apps.sh`
   - Modify content and rebuild

## Building Desktop Applications

### Automatic Building

```bash
# Build all platforms automatically
uv run scripts/build_portable_docs.py --build-electron

# This will:
# 1. Create all necessary files
# 2. Install npm dependencies
# 3. Build MkDocs site
# 4. Build Electron apps for Windows, Mac, and Linux
```

### Manual Building

If you have the source package or want to build manually:

```bash
# Navigate to the target folder
cd target_folder

# Install dependencies
npm install

# Build MkDocs site
npm run build:site

# Build all desktop applications
npm run build:all

# Or build for specific platforms
npm run build:win    # Windows only
npm run build:mac    # Mac only  
npm run build:linux  # Linux only
```

### Platform-Specific Build Scripts

**Unix/Mac/Linux:**
```bash
./build_electron_apps.sh
```

**Windows:**
```cmd
build_electron_apps.bat
```

## Desktop Application Features

### Application Capabilities

- **Native Window**: Proper desktop application with title bar, menus
- **Offline Operation**: Complete functionality without internet
- **Professional Menus**: File, View, Help menus with keyboard shortcuts
- **Zoom Support**: Ctrl/Cmd + Plus/Minus to zoom in/out
- **Developer Tools**: F12 to open debugging tools
- **External Links**: Links open in system browser
- **About Dialog**: Course information and version details

### Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl/Cmd + R` | Reload page |
| `F12` | Toggle Developer Tools |
| `Ctrl/Cmd + Plus` | Zoom In |
| `Ctrl/Cmd + Minus` | Zoom Out |
| `Ctrl/Cmd + 0` | Reset Zoom |
| `Ctrl/Cmd + Q` | Quit Application |

### Application Metadata

- **App ID**: `no.uib.inf100.studyguide`
- **Product Name**: INF100 Study Guide
- **Category**: Education (Mac)
- **Version**: 1.0.0
- **Publisher**: University of Bergen

## Troubleshooting

### Common Issues

**"uv not found" Error:**
```bash
# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh  # Mac/Linux
# or
irm https://astral.sh/uv/install.ps1 | iex       # Windows PowerShell
```

**"Node.js not found" Error (for Electron builds):**
- Install Node.js from https://nodejs.org/
- Ensure `node` and `npm` are in your PATH

**Build Fails on Linux:**
- Some Linux builds may fail due to missing system dependencies
- The AppImage usually builds successfully
- Windows and Mac builds are most reliable

**Permission Errors (Mac/Linux):**
```bash
# Make scripts executable
chmod +x run_unix.sh
chmod +x build_electron_apps.sh
```

**Port 8000 Already in Use:**
- MkDocs will automatically try other ports (8001, 8002, etc.)
- Or specify a custom port: `uv run mkdocs serve -a localhost:8001`

### Build Warnings

**"Author is missed in package.json":**
- This is a warning, not an error
- Applications build successfully despite this warning

**"Default Electron icon is used":**
- A basic icon is included
- For production, replace `electron/assets/icon.svg` with a custom icon

**"Skipped macOS application code signing":**
- Applications work fine without code signing
- For distribution, proper code signing certificates are recommended

## Advanced Usage

### Customizing the Build

**Modify MkDocs Configuration:**
Edit the `create_mkdocs_config()` function in the script to change:
- Site name and description
- Theme colors and features
- Navigation structure
- Markdown extensions

**Customize Electron App:**
Edit the generated files:
- `electron/main.js` - Main application logic
- `package.json` - App metadata and build configuration
- `electron/assets/icon.svg` - Application icon

**Add Custom Content:**
- Place additional markdown files in the source folder
- Update navigation structure in the script
- Rebuild to include new content

### Integration with CI/CD

```yaml
# Example GitHub Actions workflow
name: Build Documentation
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      - name: Install uv
        run: curl -LsSf https://astral.sh/uv/install.sh | sh
      - name: Build portable docs
        run: uv run scripts/build_portable_docs.py --build-electron
      - name: Upload artifacts
        uses: actions/upload-artifact@v3
        with:
          name: desktop-apps
          path: inf100_docs_portable/dist/
```

## File Sizes and Performance

### Web Server Version
- **Total Size**: ~2-5MB (markdown files + configuration)
- **Startup Time**: ~2-3 seconds
- **Memory Usage**: ~50-100MB (Python + MkDocs)

### Desktop Applications
- **Windows**: ~143MB (includes Electron runtime)
- **Mac Intel**: ~100MB
- **Mac Apple Silicon**: ~95MB  
- **Linux AppImage**: ~105MB
- **Startup Time**: ~1-2 seconds
- **Memory Usage**: ~80-150MB (Electron + Chromium)

### Build Times
- **Web Server Version**: ~5-10 seconds
- **Desktop Apps (all platforms)**: ~2-5 minutes
- **Single Platform**: ~30-60 seconds

## Best Practices

### For Course Distribution

1. **Use Desktop Applications** for student distribution
2. **Provide multiple formats** (web server + desktop apps)
3. **Test on target platforms** before distribution
4. **Include clear installation instructions**
5. **Consider file hosting** for large desktop applications

### For Development

1. **Use web server version** for rapid iteration
2. **Version control the source**, not built applications
3. **Automate builds** with CI/CD for releases
4. **Test Electron builds** on each target platform
5. **Keep dependencies updated** (uv, Node.js, Electron)

### For Customization

1. **Fork the script** for major customizations
2. **Use command-line arguments** for simple changes
3. **Test thoroughly** after modifications
4. **Document custom changes** for future reference
5. **Consider contributing** improvements back to the original

## Support and Maintenance

### Updating Content

To update the documentation content:

1. Modify the source markdown files
2. Re-run the build script
3. Distribute the updated version

### Updating Dependencies

**For uv/Python dependencies:**
```bash
# Dependencies are automatically managed by uv
# Update pyproject.toml if needed
```

**For Electron/Node.js dependencies:**
```bash
cd target_folder
npm update
npm audit fix  # Fix security issues
```

### Version Management

The script creates version 1.0.0 by default. To update:

1. Edit the version in `create_electron_files()` function
2. Update both `package.json` version and app version
3. Rebuild applications

## Conclusion

The `build_portable_docs.py` script provides a comprehensive solution for distributing the INF100 study guide in multiple formats. Choose the distribution method that best fits your audience:

- **Desktop applications** for students and end users
- **Web server version** for developers and technical users  
- **Source package** for customization and institutional deployment

The script handles all the complexity of creating professional, cross-platform documentation while maintaining the rich content and features of the original study guide.
