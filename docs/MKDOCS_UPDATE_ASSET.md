# mkdocs-update-asset

Update JavaScript and CSS assets for MkDocs projects from CDNs and GitHub releases.

## Overview

`mkdocs-update-asset` automatically fetches and updates JavaScript/CSS assets (like Mermaid, MathJax) for MkDocs projects. It checks for the latest versions, downloads them, and optionally tests MkDocs build compatibility.

## Key Features

- ✅ **Auto-update** - Fetches latest versions from GitHub releases
- ✅ **Version tracking** - Tracks installed versions to avoid redundant downloads
- ✅ **Build testing** - Optionally tests MkDocs build after update
- ✅ **Multiple assets** - Supports Mermaid, MathJax, and more
- ✅ **Force update** - Can force update even if latest version is installed

## Installation

No installation required! The script is a standalone bash script:

```bash
# Just run it directly
scripts/sbin/mkdocs-update-asset --help
```

## Usage

### Basic Usage

```bash
# Update Mermaid
scripts/sbin/mkdocs-update-asset \
  --asset-type mermaid \
  --assets-dir docs/assets/js

# Update MathJax
scripts/sbin/mkdocs-update-asset \
  --asset-type mathjax \
  --assets-dir docs/assets/js

# Force update even if latest version installed
scripts/sbin/mkdocs-update-asset \
  --asset-type mermaid \
  --assets-dir docs/assets/js \
  --force

# Skip build test
scripts/sbin/mkdocs-update-asset \
  --asset-type mermaid \
  --assets-dir docs/assets/js \
  --skip-build-test
```

## Command-Line Options

| Option | Description | Default |
|--------|-------------|---------|
| `--asset-type` | Asset to update (mermaid, mathjax) | `mermaid` |
| `--assets-dir` | Directory to store assets | **Required** |
| `--force` | Force update even if latest version installed | `false` |
| `--skip-build-test` | Skip MkDocs build test after update | `false` |
| `--help` | Show help message | - |

## Supported Assets

### Mermaid

Diagram and flowchart library for Markdown.

- **Source**: [mermaid-js/mermaid](https://github.com/mermaid-js/mermaid)
- **File**: `mermaid.min.js`
- **CDN**: unpkg.com

```bash
scripts/sbin/mkdocs-update-asset \
  --asset-type mermaid \
  --assets-dir docs/assets/js
```

### MathJax

Mathematical notation rendering library.

- **Source**: [mathjax/MathJax](https://github.com/mathjax/MathJax)
- **File**: `mathjax.min.js`
- **CDN**: cdn.jsdelivr.net

```bash
scripts/sbin/mkdocs-update-asset \
  --asset-type mathjax \
  --assets-dir docs/assets/js
```

## How It Works

1. **Check Latest Version**: Queries GitHub API for latest release
2. **Compare Versions**: Checks if update is needed (unless `--force`)
3. **Download Asset**: Downloads from CDN (unpkg or jsdelivr)
4. **Save Version**: Stores version info in `.{asset}-version` file
5. **Test Build**: Optionally runs MkDocs build test

## Version Tracking

The script creates a version file to track installed versions:

```bash
# Example: .mermaid-version
11.4.0
```

This prevents unnecessary re-downloads when the latest version is already installed.

## Example Workflows

### Update Mermaid in MkDocs Project

```bash
# Update to latest Mermaid
scripts/sbin/mkdocs-update-asset \
  --asset-type mermaid \
  --assets-dir docs/assets/js

# Output:
# 🔍 Checking for latest mermaid release...
# 📦 Latest mermaid version: v11.4.0
# 📈 Updating from v11.3.0 to v11.4.0
# ⬇️  Downloading from: https://unpkg.com/mermaid@11.4.0/dist/mermaid.min.js
# ✅ Successfully downloaded mermaid v11.4.0
# 📁 File size: 2.1M
# 🔨 Testing MkDocs build...
# ✅ MkDocs build successful with mermaid v11.4.0
# 🎉 mermaid successfully updated to v11.4.0
```

### Force Update

```bash
# Force update even if already on latest
scripts/sbin/mkdocs-update-asset \
  --asset-type mermaid \
  --assets-dir docs/assets/js \
  --force
```

### CI/CD Integration

```yaml
# .github/workflows/update-assets.yml
name: Update Assets

on:
  schedule:
    - cron: '0 0 * * 0'  # Weekly on Sunday
  workflow_dispatch:

jobs:
  update:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Update Mermaid
        run: |
          scripts/sbin/mkdocs-update-asset \
            --asset-type mermaid \
            --assets-dir docs/assets/js
      
      - name: Create PR if updated
        if: success()
        uses: peter-evans/create-pull-request@v5
        with:
          title: 'chore: update Mermaid to latest version'
          commit-message: 'chore: update Mermaid asset'
```

### Automated Updates

```bash
#!/bin/bash
# update-all-assets.sh

# Update Mermaid
scripts/sbin/mkdocs-update-asset \
  --asset-type mermaid \
  --assets-dir docs/assets/js

# Update MathJax
scripts/sbin/mkdocs-update-asset \
  --asset-type mathjax \
  --assets-dir docs/assets/js

echo "All assets updated!"
```

## Output Examples

### Already Up to Date

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  MkDocs Asset Updater - mermaid
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔍 Checking for latest mermaid release...
📦 Latest mermaid version: v11.4.0
✅ Already using latest version (v11.4.0)
```

### Successful Update

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  MkDocs Asset Updater - mermaid
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔍 Checking for latest mermaid release...
📦 Latest mermaid version: v11.4.0
📈 Updating from v11.3.0 to v11.4.0
⬇️  Downloading from: https://unpkg.com/mermaid@11.4.0/dist/mermaid.min.js
✅ Successfully downloaded mermaid v11.4.0
📁 File size: 2.1M
🔨 Testing MkDocs build...
✅ MkDocs build successful with mermaid v11.4.0

🎉 mermaid successfully updated to v11.4.0
   Location: docs/assets/js/mermaid.min.js
```

## Troubleshooting

### GitHub API rate limit

**Problem**: `Failed to fetch latest version from GitHub`

**Solution**: Wait for rate limit reset or use GitHub token:
```bash
export GITHUB_TOKEN=your_token_here
scripts/sbin/mkdocs-update-asset --asset-type mermaid --assets-dir docs/assets/js
```

### Download fails

**Problem**: `Failed to download asset`

**Solution**: Check network connection and CDN availability:
```bash
# Test CDN manually
curl -I https://unpkg.com/mermaid@latest/dist/mermaid.min.js
```

### Build test fails

**Problem**: `MkDocs build failed`

**Solution**: Skip build test and debug separately:
```bash
scripts/sbin/mkdocs-update-asset \
  --asset-type mermaid \
  --assets-dir docs/assets/js \
  --skip-build-test

# Then debug MkDocs build
mkdocs build --verbose
```

## Best Practices

1. **Version control**: Commit version files (`.mermaid-version`) to track updates
2. **Test builds**: Don't skip build tests in production
3. **Automate updates**: Use CI/CD for regular asset updates
4. **Pin versions**: For stability, consider pinning specific versions

## Adding New Assets

To add support for new assets, edit the script and add a new case:

```bash
case "$ASSET_TYPE" in
    your-asset)
        GITHUB_REPO="owner/repo"
        ASSET_FILE="your-asset.min.js"
        USE_GITHUB_RELEASE=true
        ;;
esac
```

Then add the download URL logic:

```bash
case "$ASSET_TYPE" in
    your-asset)
        DOWNLOAD_URL="https://cdn.example.com/your-asset@${LATEST_VERSION}/dist/your-asset.min.js"
        ;;
esac
```

## Related Tools

- **`mkdocs-build`** - Build MkDocs documentation
- **`mkdocs-server`** - Serve MkDocs documentation
- **`mkdocs-portable`** - Create portable documentation sites

## See Also

- [Mermaid Documentation](https://mermaid.js.org/)
- [MathJax Documentation](https://www.mathjax.org/)
- [unpkg CDN](https://unpkg.com/)
- [jsDelivr CDN](https://www.jsdelivr.com/)
