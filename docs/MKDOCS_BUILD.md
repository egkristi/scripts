# mkdocs-build v2.0

Multi-target build system for MkDocs documentation with unified configuration.

## Overview

`mkdocs-build` is a unified build system that supports multiple output targets from a single configuration file. Build ephemeral MkDocs directories, static websites, and Electron desktop applications all from one command.

## Key Features

- ✅ **Multi-target builds** - mkdocs, site, electron from one config
- ✅ **Unified configuration** - Single JSON file replaces mkdocs.yml, version.json, build config
- ✅ **Version management** - Built-in version tracking with auto-increment
- ✅ **Dynamic mkdocs.yml** - Generated from unified config
- ✅ **Electron apps** - Desktop application generation with cross-platform support
- ✅ **Static sites** - Direct static website output

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

## Command-Line Options

| Option | Description | Default |
|--------|-------------|---------|
| `--config` | Path to unified config file | **Required** |
| `--target` | Target(s) to build (mkdocs, site, electron, all) | `mkdocs` |
| `--electron-build` | Build Electron apps (override config) | `false` |
| `--electron-platforms` | Platforms to build (mac,win,linux,all) | From config |
| `--list-targets` | List available targets and exit | - |
| `--version` | Show version and exit | - |

## How It Works

1. **Clean**: Removes existing build directory
2. **Create**: Creates fresh build directory structure
3. **Copy Root Files**: Copies specified root files (README, LICENSE, etc.)
4. **Sync Content**: Copies content directories to build location
5. **Copy Assets**: Copies static assets (CSS, JS, etc.)
6. **Build**: Runs `mkdocs build` (unless `--no-build` specified)

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
cat > mkdocs-build.json << EOF
{
  "source_dir": "docs",
  "build_dir": "mkdocs",
  "docs_subdir": "docs",
  "content_dirs": ["ARCHITECTURE", "BUSINESS"]
}
EOF

# Build documentation
uv run scripts/sbin/mkdocs-build --config mkdocs-build.json

# Serve locally
uv run mkdocs serve

# Clean build directory
uv run scripts/sbin/mkdocs-build --clean-only
```

## Best Practices

1. **Gitignore build directory**: Add your build directory to `.gitignore`
2. **Use config file**: Prefer JSON config over CLI args for consistency
3. **Separate assets**: Keep reusable assets in a dedicated directory
4. **Version control source**: Only commit source docs, not build output

## Troubleshooting

### Build directory not cleaned

**Problem**: Old files remain in build directory

**Solution**: Use `--clean-only` to manually clean:
```bash
uv run scripts/sbin/mkdocs-build --clean-only
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

**Solution**: Use `--no-build` to sync only, then debug:
```bash
uv run scripts/sbin/mkdocs-build --no-build
cd mkdocs
uv run mkdocs build --verbose
```

## Related Tools

- **`mkdocs-server`** - Serve MkDocs documentation
- **`mkdocs-portable`** - Create portable documentation sites
- **`mkdocs-portable-test`** - Test portable documentation

## See Also

- [MkDocs Documentation](https://www.mkdocs.org/)
- [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/)
