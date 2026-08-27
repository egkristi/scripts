# Scripts - System Binaries

Generic, reusable scripts for documentation and development workflows.

## Available Scripts

### `mkdocs-build`

Multi-target MkDocs build system (v2.0) driven by a single unified JSON config.

**Purpose**: Builds one or more output targets (ephemeral `mkdocs` dir, static `site`, `site-zip` archive, `combined-html`, `pdf`, `electron` desktop app, `go` static-binary server) from one config file. See [docs/MKDOCS_BUILD.md](docs/MKDOCS_BUILD.md) for full details.

**Usage**:
```bash
# Build the default target (mkdocs)
uv run scripts/sbin/mkdocs-build --config docs/mkdocs-build.json

# Build a specific target
uv run scripts/sbin/mkdocs-build --config docs/mkdocs-build.json --target site

# Build multiple / all enabled targets
uv run scripts/sbin/mkdocs-build --config docs/mkdocs-build.json --target mkdocs,site
uv run scripts/sbin/mkdocs-build --config docs/mkdocs-build.json --target all

# List configured targets
uv run scripts/sbin/mkdocs-build --config docs/mkdocs-build.json --list-targets
```

**Config File Example** (`docs/mkdocs-build.json`):
```json
{
  "version": { "current": "1.0.0", "auto_increment": "patch" },
  "project": { "name": "My Docs", "description": "Documentation", "author": "Author Name" },
  "source": {
    "docs_dir": ".",
    "content_dirs": ["ARCHITECTURE", "BUSINESS"],
    "assets_dir": ".mkdocs-assets",
    "asset_subdirs": ["assets", "javascripts", "stylesheets"]
  },
  "targets": {
    "mkdocs": { "enabled": true, "output_dir": "../mkdocs" },
    "site": { "enabled": true, "output_dir": "../site" },
    "electron": { "enabled": false, "output_dir": "../desktop-app" }
  }
}
```

**Features**:
- Multiple output targets from one config: `mkdocs`, `site`, `site-zip`, `combined-html`, `pdf`, `electron`, `go`
- Auto-detects content directories if not specified
- Copies static assets (CSS, JS, fonts, etc.)
- Built-in version tracking with auto-increment on every build
- Dynamically generates `mkdocs.yml` from the unified config

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
