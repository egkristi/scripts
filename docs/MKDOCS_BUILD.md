# mkdocs-build v2.0

Multi-target build system for MkDocs documentation with unified configuration.

## Overview

`mkdocs-build` is a unified build system that supports multiple output targets from a single configuration file. Build ephemeral MkDocs directories, static websites, and Electron desktop applications all from one command.

## Key Features

- ✅ **Multi-target builds** - mkdocs, site, site-zip, pdf, electron, go from one config
- ✅ **Unified configuration** - Single JSON file replaces mkdocs.yml, version.json, build config
- ✅ **Version management** - Built-in version tracking with auto-increment
- ✅ **Dynamic mkdocs.yml** - Generated from unified config
- ✅ **Electron apps** - Desktop application generation with cross-platform support
- ✅ **Go binaries** - Self-contained static web server binaries
- ✅ **Static sites** - Direct static website output
- ✅ **Site archives** - Compressed zip archives for distribution
- ✅ **PDF export** - Searchable PDF documentation (requires system dependencies)

## Installation

No installation required! The script uses uv's inline dependencies:

```bash
# Just run it directly
uv run scripts/sbin/mkdocs-build --help
```

## Usage

### Basic Usage

```bash
# Build default target (mkdocs)
uv run scripts/sbin/mkdocs-build --config docs/mkdocs-build.json

# Build specific target
uv run scripts/sbin/mkdocs-build --config docs/mkdocs-build.json --target site

# Build multiple targets
uv run scripts/sbin/mkdocs-build --config docs/mkdocs-build.json --target mkdocs,site

# Build all enabled targets
uv run scripts/sbin/mkdocs-build --config docs/mkdocs-build.json --target all

# Build electron with auto-build
uv run scripts/sbin/mkdocs-build --config docs/mkdocs-build.json --target electron --electron-build

# List available targets
uv run scripts/sbin/mkdocs-build --config docs/mkdocs-build.json --list-targets
```

### Unified Configuration File

Create a `docs/mkdocs-build.json` file (stored with your documentation source):

```json
{
  "version": {
    "current": "1.0.0",
    "build_count": 0,
    "auto_increment": "patch"
  },
  "project": {
    "name": "My Documentation",
    "description": "Project Documentation",
    "author": "Author Name",
    "url": null
  },
  "source": {
    "docs_dir": ".",
    "content_dirs": ["ARCHITECTURE", "BUSINESS", "DEVELOPMENT"],
    "assets_dir": ".mkdocs-assets",
    "asset_subdirs": ["assets", "javascripts", "stylesheets"]
  },
  "mkdocs": {
    "theme": "material",
    "features": ["navigation.tabs", "search.highlight"],
    "plugins": ["search", "offline"],
    "extensions": ["admonition", "pymdownx.superfences"]
  },
  "targets": {
    "mkdocs": {
      "enabled": true,
      "output_dir": "../mkdocs",
      "docs_subdir": "docs",
      "auto_build": true
    },
    "site": {
      "enabled": true,
      "output_dir": "../site",
      "clean_build": true
    },
    "electron": {
      "enabled": true,
      "output_dir": "../desktop-app/my-docs",
      "platforms": ["mac", "win", "linux"],
      "auto_build": false
    }
  }
}
```

## Build Targets

### Available Targets

| Target | Description | Output | Dependencies |
|--------|-------------|--------|--------------|
| `mkdocs` | Ephemeral build directory | `../mkdocs/` | None |
| `site` | Static website | `../site/` | None |
| `site-zip` | Compressed site archive | `../site-archives/*.zip` | None |
| `pdf` | PDF documentation | `../pdf-archives/*.pdf` | **System libraries** |
| `electron` | Desktop applications | `../desktop-app/dists/` | Node.js, npm |
| `go` | Static server binaries | `../go-dists/` | Go compiler |
| `all` | All enabled targets | Multiple | Varies |

### PDF Target - System Dependencies

The PDF target requires system libraries for WeasyPrint. These must be installed separately:

#### macOS (Homebrew)
```bash
brew install pango cairo gdk-pixbuf libffi
```

#### Ubuntu/Debian
```bash
sudo apt-get update
sudo apt-get install -y \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libgdk-pixbuf2.0-0 \
    libffi-dev \
    shared-mime-info
```

#### Fedora/RHEL/CentOS
```bash
sudo dnf install -y \
    pango \
    cairo \
    gdk-pixbuf2 \
    libffi-devel
```

#### Arch Linux
```bash
sudo pacman -S pango cairo gdk-pixbuf2 libffi
```

#### Windows
Install GTK3 runtime from: https://github.com/tschoonj/GTK-for-Windows-Runtime-Environment-Installer

#### Verification
After installing dependencies, verify WeasyPrint works:
```bash
python3 -c "from weasyprint import HTML; print('WeasyPrint OK')"
```

#### Alternative to PDF
If system dependencies are too complex, use these alternatives:
- **site-zip**: Compressed archive for distribution
- **Browser Print**: Open site → Print → Save as PDF
- **Go binaries**: Self-contained documentation server
- **Electron apps**: Native desktop applications

## Command-Line Options

| Option | Description | Default |
|--------|-------------|---------|
| `--config` | Path to unified config file | **Required** |
| `--target` | Target(s) to build (mkdocs, site, electron, go, pdf, all) | `mkdocs` |
| `--electron-build` | Build Electron apps (override config) | `false` |
| `--electron-platforms` | Platforms to build (mac,win,linux,all) | From config |
| `--go-platforms` | Go platforms (darwin/amd64, linux/amd64, etc.) | From config |
| `--list-targets` | List available targets and exit | - |
| `--version` | Show version and exit | - |

## How It Works

Each target passed to `--target` runs its own build function:

1. **mkdocs**: cleans `output_dir`, syncs `index.md` + content dirs + assets, generates `mkdocs.yml`, then runs `mkdocs build` (if `auto_build`)
2. **site**: stages content in a temp dir and runs `mkdocs build --site-dir <output_dir>`
3. **site-zip**: builds `site` first if missing, then zips it
4. **combined-html**: builds `site` first if missing, then flattens all pages into one HTML file with a generated TOC
5. **pdf**: builds `combined-html` first, then renders it to PDF via Playwright/Chromium
6. **electron**: builds a static site, generates `main.js`/`package.json`, and (unless disabled) runs `npm install` + `electron-builder`
7. **go**: builds a static site, embeds it in `templates/static_web_server.go`, and cross-compiles a binary per platform

Every run also increments `version.current` (per `auto_increment`) and persists it back to the config file, regardless of which targets are selected.

## Use Cases

### Multi-Location Documentation

Perfect for projects where documentation lives in multiple directories:

```
project/
├── docs/                    # Primary docs source
│   ├── ARCHITECTURE/
│   ├── BUSINESS/
│   └── DEVELOPMENT/
├── mkdocs/                  # Ephemeral build dir (gitignored)
│   └── docs/               # Synced content
└── mkdocs.yml              # MkDocs config
```

### Preprocessing Pipeline

Use as part of a documentation build pipeline:

```bash
# 1. Sync and prepare docs
uv run scripts/sbin/mkdocs-build --config mkdocs-build.json

# 2. Serve for development
uv run mkdocs serve

# 3. Build for production
uv run mkdocs build
```

### CI/CD Integration

Integrate into your CI/CD workflow:

```yaml
# .github/workflows/docs.yml
- name: Build documentation
  run: |
    uv run scripts/sbin/mkdocs-build --config mkdocs-build.json
    uv run mkdocs build
```

## Example Workflow

```bash
# Initial setup
mkdir -p docs
cat > docs/mkdocs-build.json << EOF
{
  "version": { "current": "1.0.0", "auto_increment": "patch" },
  "project": { "name": "My Docs" },
  "source": { "docs_dir": ".", "content_dirs": ["ARCHITECTURE", "BUSINESS"] },
  "targets": {
    "mkdocs": { "enabled": true, "output_dir": "../mkdocs" }
  }
}
EOF

# Build documentation
uv run scripts/sbin/mkdocs-build --config docs/mkdocs-build.json

# Serve locally
cd mkdocs && uv run mkdocs serve
```

## Best Practices

1. **Gitignore build directory**: Add your build directory to `.gitignore`
2. **Use config file**: Prefer JSON config over CLI args for consistency
3. **Separate assets**: Keep reusable assets in a dedicated directory
4. **Version control source**: Only commit source docs, not build output

## Troubleshooting

### Build directory not cleaned

**Problem**: Stale files remain in an output directory

**Solution**: The `mkdocs` target always removes its `output_dir` before rebuilding, and `site` does so by default (`clean_build: true`). If files still linger, delete the output directory manually and rebuild:
```bash
rm -rf mkdocs   # or whichever output_dir you configured
uv run scripts/sbin/mkdocs-build --config docs/mkdocs-build.json
```

### Assets not copying

**Problem**: Static assets (CSS, JS) not found

**Solution**: Check `assets_dir` and `asset_subdirs` in config:
```json
{
  "assets_dir": ".mkdocs-assets",
  "asset_subdirs": ["assets", "javascripts", "stylesheets"]
}
```

### MkDocs build fails

**Problem**: MkDocs build errors after sync

**Solution**: Build just the `mkdocs` target, then debug directly with MkDocs:
```bash
uv run scripts/sbin/mkdocs-build --config docs/mkdocs-build.json --target mkdocs
cd mkdocs
uv run mkdocs build --verbose
```

## Related Tools

- **`mkdocs-server`** - Serve MkDocs documentation
- **`convert-to-mkdocs`** - Convert a website mirror into an MkDocs project (supports `--with-portable` for a relocatable site)
- **`mkdocs-test`** - Validate a portable documentation site before distribution

## See Also

- [MkDocs Documentation](https://www.mkdocs.org/)
- [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/)
