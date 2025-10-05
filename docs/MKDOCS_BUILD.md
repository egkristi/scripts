# mkdocs-build

Build MkDocs documentation from a primary source directory with ephemeral build folder support.

## Overview

`mkdocs-build` creates an ephemeral MkDocs build directory by syncing content from a primary documentation source. The build directory can be safely deleted and regenerated at any time, making it perfect for projects where documentation lives in multiple locations or needs preprocessing.

## Key Features

- ✅ **Ephemeral build directory** - Rebuilds from scratch on each run
- ✅ **Auto-detection** - Automatically detects content directories if not specified
- ✅ **Asset management** - Copies static assets (CSS, JS, fonts, etc.)
- ✅ **Flexible configuration** - Configure via CLI or JSON config file
- ✅ **MkDocs integration** - Automatically runs `mkdocs build` after sync

## Installation

No installation required! The script uses uv's inline dependencies:

```bash
# Just run it directly
uv run scripts/sbin/mkdocs-build --help
```

## Usage

### Basic Usage

```bash
# Use with config file (recommended)
uv run scripts/sbin/mkdocs-build --config mkdocs-build.json

# Use with command-line arguments
uv run scripts/sbin/mkdocs-build \
  --source-dir docs \
  --build-dir mkdocs \
  --docs-subdir docs

# Clean only (remove build directory)
uv run scripts/sbin/mkdocs-build --clean-only

# Sync files without running mkdocs build
uv run scripts/sbin/mkdocs-build --no-build

# Silent mode
uv run scripts/sbin/mkdocs-build --config mkdocs-build.json --silent
```

### Configuration File

Create a `mkdocs-build.json` file in your project root:

```json
{
  "source_dir": "docs",
  "build_dir": "mkdocs",
  "docs_subdir": "docs",
  "mkdocs_config": "mkdocs.yml",
  "root_files": ["README.md", "LICENSE.md"],
  "content_dirs": ["ARCHITECTURE", "BUSINESS", "DEVELOPMENT", "OKR", "LEGAL"],
  "assets_dir": ".mkdocs-assets",
  "asset_subdirs": ["assets", "javascripts", "stylesheets"]
}
```

## Configuration Options

### Required Options

| Option | Description |
|--------|-------------|
| `--source-dir` | Primary documentation source directory |
| `--build-dir` | Ephemeral build directory (will be recreated) |

### Optional Options

| Option | Description | Default |
|--------|-------------|---------|
| `--docs-subdir` | Subdirectory within build-dir for docs | `docs` |
| `--mkdocs-config` | Path to mkdocs.yml file | `mkdocs.yml` |
| `--config` | Path to JSON configuration file | - |
| `--clean-only` | Only clean the build directory | `false` |
| `--no-build` | Sync files but don't run mkdocs build | `false` |
| `--silent` | Suppress output messages | `false` |

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
