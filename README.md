# Scripts - System Binaries

Generic, reusable scripts for documentation and development workflows.

## Available Scripts

### `mkdocs-build`

Build MkDocs documentation from a primary source directory with ephemeral build folder support.

**Purpose**: Creates an ephemeral MkDocs build directory by syncing content from a primary documentation source. The build directory can be safely deleted and regenerated at any time.

**Usage**:
```bash
# Use with config file
uv run scripts/sbin/mkdocs-build --config mkdocs-build.json

# Use with command-line arguments
uv run scripts/sbin/mkdocs-build --source-dir docs --build-dir mkdocs

# Clean only (remove build directory)
uv run scripts/sbin/mkdocs-build --clean-only

# Sync files without running mkdocs build
uv run scripts/sbin/mkdocs-build --no-build
```

**Config File Example** (`mkdocs-build.json`):
```json
{
  "source_dir": "docs",
  "build_dir": "mkdocs",
  "docs_subdir": "docs",
  "mkdocs_config": "mkdocs.yml",
  "root_files": ["README.md", "LICENSE.md"],
  "content_dirs": ["ARCHITECTURE", "BUSINESS", "DEVELOPMENT"],
  "assets_dir": ".mkdocs-assets",
  "asset_subdirs": ["assets", "javascripts", "stylesheets"]
}
```

**Features**:
- Rebuilds build directory from scratch on each run
- Auto-detects content directories if not specified
- Copies static assets (CSS, JS, fonts, etc.)
- Runs `mkdocs build` automatically
- Configurable via CLI or JSON config file

---

### `mkdocs-server`

Serve MkDocs documentation with automatic setup and dependency management.

**Purpose**: Provides a convenient development server for MkDocs projects with automatic configuration and inline dependencies.

**Usage**:
```bash
# Serve current project
uv run scripts/sbin/mkdocs-server --project-root .

# Custom host and port
uv run scripts/sbin/mkdocs-server --project-root . --host 0.0.0.0 --port 8080

# Serve with custom docs directory
uv run scripts/sbin/mkdocs-server --project-root . --docs-subdir content

# Silent mode
uv run scripts/sbin/mkdocs-server --project-root . --silent
```

**Features**:
- Self-contained with inline dependencies (mkdocs, mkdocs-material)
- Automatically creates minimal mkdocs.yml if missing
- Creates placeholder docs/index.md if needed
- Flexible host and port configuration
- Works with any MkDocs project structure

---

### `convert-to-mkdocs`

Convert mirrored HTML websites into MkDocs-compatible documentation.

**Purpose**: Transforms mirrored websites (created by `mirror-site` or similar tools) into properly structured MkDocs documentation sites.

**Usage**:
```bash
# Convert a mirrored site
uv run scripts/sbin/convert-to-mkdocs \
  --mirror-folder docs-mirror \
  --output-folder mkdocs-site \
  --base-url https://docs.example.com/ \
  --write-config

# Create portable MkDocs project
uv run scripts/sbin/convert-to-mkdocs \
  --mirror-folder ./mirror \
  --output-folder ./site \
  --with-portable \
  --write-config
```

**Features**:
- Converts HTML pages to Markdown with embedded HTML
- Rewrites internal links for offline browsing
- Generates MkDocs configuration automatically
- Creates portable projects with run scripts
- Supports mirror index files for metadata

---

## Integration

These scripts are designed to be used as a git submodule in your projects:

```bash
# Add as submodule
git submodule add https://github.com/egkristi/scripts.git scripts

# Initialize in existing repo
git submodule update --init --recursive
```

## Requirements

- Python 3.8+
- [uv](https://docs.astral.sh/uv/) package manager
- MkDocs and plugins (installed via project dependencies)

## License

See the main repository LICENSE file.
