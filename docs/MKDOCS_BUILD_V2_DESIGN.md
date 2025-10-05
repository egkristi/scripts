# mkdocs-build v2.0 - Multi-Target Build System Design

## Overview

Consolidate all MkDocs build workflows into a single, powerful `mkdocs-build` script with multi-target support. This eliminates the need for separate `mkdocs-portable` script and provides a unified build interface.

## Goals

1. **Single Entry Point**: One script for all build needs
2. **Multiple Targets**: Support mkdocs, site, electron, and future targets
3. **Unified Configuration**: Single config file combining build settings, mkdocs config, and versioning
4. **Extensible**: Easy to add new targets (PDF, EPUB, etc.)
5. **Efficient**: Build multiple targets in one command

## Architecture

### Build Targets

```python
class BuildTarget(Enum):
    MKDOCS = "mkdocs"      # Ephemeral build directory for development
    SITE = "site"          # Static website output
    ELECTRON = "electron"  # Electron desktop application
    ALL = "all"           # Build all enabled targets
```

### Unified Configuration: `docs/mkdocs-build.json`

All configuration in a single file stored with the documentation source:

```json
{
  "version": {
    "current": "1.0.0",
    "build_count": 42,
    "auto_increment": "patch"
  },
  
  "project": {
    "name": "MyTalent Docs",
    "description": "MyTalent Documentation - Offline Desktop App",
    "author": "MyTalent Team",
    "url": "https://mytalent.example.com"
  },
  
  "source": {
    "docs_dir": ".",
    "content_dirs": ["ARCHITECTURE", "BUSINESS", "DEVELOPMENT", "OKR", "LEGAL"],
    "assets_dir": ".mkdocs-assets",
    "asset_subdirs": ["assets", "javascripts", "stylesheets"]
  },
  
  "mkdocs": {
    "theme": "material",
    "features": [
      "navigation.tabs",
      "navigation.sections",
      "search.highlight"
    ],
    "plugins": ["search", "offline"],
    "extensions": [
      "admonition",
      "pymdownx.superfences",
      "pymdownx.highlight"
    ]
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
      "output_dir": "../desktop-app/mytalent-docs",
      "platforms": ["mac", "win", "linux"],
      "auto_build": false,
      "code_signing": {
        "enabled": false,
        "identity": null
      }
    }
  }
}
```

### File Location

```
docs/
├── mkdocs-build.json      # Single unified config (replaces mkdocs.yml, version.json, mkdocs-build.json)
├── ARCHITECTURE/
├── BUSINESS/
└── .mkdocs-assets/
```

The script generates `mkdocs.yml` dynamically from the config when needed.

## Command-Line Interface

### Basic Usage

```bash
# Build default target (mkdocs) - config in docs/
uv run scripts/sbin/mkdocs-build --config docs/mkdocs-build.json

# Build specific target
uv run scripts/sbin/mkdocs-build --config docs/mkdocs-build.json --target site

# Build multiple targets
uv run scripts/sbin/mkdocs-build --config docs/mkdocs-build.json --target mkdocs,site

# Build all enabled targets
uv run scripts/sbin/mkdocs-build --config docs/mkdocs-build.json --target all

# Build electron with auto-build
uv run scripts/sbin/mkdocs-build --config docs/mkdocs-build.json --target electron --electron-build
```

### New Arguments

| Argument | Description | Default |
|----------|-------------|---------|
| `--target` | Target(s) to build (mkdocs, site, electron, all) | `mkdocs` |
| `--electron-build` | Build Electron apps (override config) | `false` |
| `--electron-platforms` | Platforms to build (mac,win,linux,all) | From config |
| `--list-targets` | List available targets and exit | - |

## Implementation Plan

### Phase 1: Core Multi-Target Support

1. **New Data Classes**
   - `TargetConfig` - Base class for target configuration
   - `MkDocsTargetConfig` - MkDocs-specific config
   - `SiteTargetConfig` - Static site config
   - `ElectronTargetConfig` - Electron app config
   - `BuildConfigV2` - New main config class

2. **Target Builders**
   - `MkDocsBuilder` - Build ephemeral mkdocs directory
   - `SiteBuilder` - Build static website
   - `ElectronBuilder` - Build Electron desktop app

3. **Config Management**
   - `load_unified_config()` - Load and validate unified config
   - `generate_mkdocs_yml()` - Generate mkdocs.yml from config
   - `increment_version()` - Auto-increment version number

### Phase 2: Electron Integration

1. **Port from mkdocs-portable**
   - Version management
   - MkDocs config generation
   - Electron file creation
   - Cross-platform run scripts
   - Build script generation

2. **Electron Builder**
   - Create portable site structure
   - Generate package.json
   - Create electron/main.js
   - Install dependencies (optional)
   - Build for platforms (optional)

### Phase 3: Documentation & Migration

1. **Update Documentation**
   - MKDOCS_BUILD.md - Complete rewrite
   - Migration guide from v1 to v2
   - Electron target documentation

2. **Deprecate mkdocs-portable**
   - Add deprecation warning
   - Redirect to mkdocs-build
   - Update all references

## File Structure

```
scripts/sbin/
├── mkdocs-build          # Enhanced multi-target builder
├── mkdocs-portable       # DEPRECATED - redirects to mkdocs-build
├── mkdocs-portable-test  # Still used for testing
└── mkdocs-update-asset   # Still used for asset updates
```

## Migration Path

### For MyTalent Project

Current (multiple commands):
```bash
# Build docs
uv run scripts/sbin/mkdocs-build --config mkdocs-build.json

# Build electron
uv run scripts/sbin/mkdocs-portable \
  --source-folder mkdocs/docs \
  --target-folder desktop-app/mytalent-docs \
  --site-name "MyTalent Docs" \
  --build-electron
```

New (single command):
```bash
# Build all targets
uv run scripts/sbin/mkdocs-build \
  --config docs/mkdocs-build.json \
  --target all
```

### New Unified Config: `docs/mkdocs-build.json`

Replaces: `mkdocs-build.json`, `mkdocs.yml`, `version.json`

```json
{
  "version": {
    "current": "1.0.0",
    "auto_increment": "patch"
  },
  "project": {
    "name": "MyTalent Docs",
    "description": "MyTalent Documentation",
    "author": "MyTalent Team"
  },
  "source": {
    "docs_dir": ".",
    "content_dirs": ["ARCHITECTURE", "BUSINESS", "DEVELOPMENT", "OKR", "LEGAL"]
  },
  "targets": {
    "mkdocs": {
      "enabled": true,
      "output_dir": "../mkdocs"
    },
    "site": {
      "enabled": true,
      "output_dir": "../site"
    },
    "electron": {
      "enabled": true,
      "output_dir": "../desktop-app/mytalent-docs",
      "platforms": ["mac", "win", "linux"]
    }
  }
}
```

## Benefits

1. **Simplified Workflow**: One command for all builds
2. **Unified Configuration**: Single JSON file replaces mkdocs.yml, version.json, and build config
3. **Source Colocation**: Config lives with documentation source in `docs/`
4. **Better Maintainability**: Single codebase instead of multiple scripts
5. **Extensible**: Easy to add PDF, EPUB, or other targets
6. **Efficient**: Build multiple targets in one pass
7. **Version Management**: Built-in version tracking and auto-increment

## Future Targets

Potential future additions:

- **PDF**: Generate PDF documentation
- **EPUB**: Generate e-book format
- **Confluence**: Export to Confluence
- **Docusaurus**: Convert to Docusaurus format
- **Hugo**: Convert to Hugo format

## Implementation Status

- [ ] Phase 1: Core Multi-Target Support
- [ ] Phase 2: Electron Integration
- [ ] Phase 3: Documentation & Migration
- [ ] Testing & Validation
- [ ] Deployment

## Next Steps

1. Implement Phase 1 (core multi-target support)
2. Test with MyTalent project
3. Implement Phase 2 (Electron integration)
4. Update all documentation
5. Deprecate mkdocs-portable
6. Update MyTalent config to v2.0
