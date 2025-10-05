# mkdocs-portable-test

Test and validate portable MkDocs Electron desktop applications.

## Overview

`mkdocs-portable-test` performs comprehensive testing of portable MkDocs desktop applications created by `mkdocs-portable`. It validates project structure, site content, offline assets, HTTP endpoints, and Electron app functionality.

## Key Features

- ✅ **Comprehensive testing** - Tests all aspects of portable apps
- ✅ **HTTP server testing** - Validates content delivery
- ✅ **Electron validation** - Tests desktop app startup
- ✅ **Build artifact checks** - Verifies distribution files
- ✅ **Quick mode** - Fast validation without Electron startup

## Installation

No installation required! The script uses uv's inline dependencies:

```bash
# Just run it directly
uv run scripts/sbin/mkdocs-portable-test --help
```

## Usage

### Basic Usage

```bash
# Test a portable desktop app
uv run scripts/sbin/mkdocs-portable-test \
  --target-folder desktop-app/mytalent-docs \
  --site-name "MyTalent Docs"

# Quick tests only (skip Electron startup)
uv run scripts/sbin/mkdocs-portable-test \
  --target-folder portable_docs \
  --quick

# Test with custom site subdirectory
uv run scripts/sbin/mkdocs-portable-test \
  --target-folder my-app \
  --site-subdir content
```

## Command-Line Options

| Option | Description | Default |
|--------|-------------|---------|
| `--target-folder` | Target folder containing the portable app | **Required** |
| `--site-subdir` | Subdirectory containing MkDocs source | `mkdocs` |
| `--site-name` | Name of the site for display purposes | `Portable MkDocs App` |
| `--quick` | Run only quick tests (skip Electron startup) | `false` |

## Test Coverage

### Project Structure Tests

Validates that all required files exist:
- ✅ `package.json` - Electron configuration
- ✅ `electron/main.js` - Main process file
- ✅ `mkdocs.yml` - MkDocs configuration
- ✅ Package.json fields (name, version, main, scripts, dependencies)
- ✅ Electron and electron-builder dependencies

### Site Content Tests

Checks MkDocs site content:
- ✅ Essential files (index.md, etc.)
- ✅ MkDocs configuration exists
- ✅ Markdown content files
- ✅ File count and structure

### Offline Assets Tests

Verifies offline asset availability:
- ✅ Asset directories exist
- ✅ JavaScript files
- ✅ Stylesheets
- ✅ Custom assets

### HTTP Endpoint Tests

Starts a test server and validates:
- ✅ Main page loads (HTTP 200)
- ✅ Content is present
- ✅ Search index accessible
- ✅ Search index has documents

### Electron App Startup Tests

Tests the desktop application:
- ✅ Node modules installed
- ✅ Electron app starts successfully
- ✅ Process runs without errors

### Build Artifact Tests

Validates distribution files:
- ✅ `dist/` directory exists
- ✅ Platform-specific artifacts created
- ✅ File sizes are reasonable (>10MB)

## Example Workflows

### Test After Building

```bash
# Build portable app
uv run scripts/sbin/mkdocs-portable \
  --source-folder docs \
  --target-folder desktop-app/my-docs \
  --site-name "My Documentation" \
  --with-electron

# Test the app
uv run scripts/sbin/mkdocs-portable-test \
  --target-folder desktop-app/my-docs \
  --site-name "My Documentation"
```

### Quick Validation

```bash
# Fast validation without Electron startup
uv run scripts/sbin/mkdocs-portable-test \
  --target-folder desktop-app/my-docs \
  --quick
```

### CI/CD Integration

```yaml
# .github/workflows/test-desktop-app.yml
- name: Test desktop application
  run: |
    uv run scripts/sbin/mkdocs-portable-test \
      --target-folder desktop-app/my-docs \
      --site-name "My Documentation"
```

## Test Output

### Successful Test

```
Portable MkDocs App - Test Suite
============================================================

=== Testing Project Structure ===
✅ PASS: File exists: package.json
✅ PASS: File exists: main.js
✅ PASS: package.json has name
✅ PASS: package.json has version
✅ PASS: Has electron dependency
✅ PASS: Has electron-builder dependency

=== Testing Site Content ===
✅ PASS: Site file exists: index.md
✅ PASS: mkdocs.yml exists
✅ PASS: Has markdown content (45 files)

=== Testing Offline Assets ===
✅ PASS: Assets in assets/ (23 files)

=== Starting Test Server ===
✅ PASS: Test server started
    Running on http://localhost:54321

=== Testing HTTP Endpoints ===
✅ PASS: Main page loads
✅ PASS: Main page has content
✅ PASS: Search index accessible
✅ PASS: Search index has documents

=== Testing Electron App Startup ===
✅ PASS: Electron app starts successfully

=== Testing Build Artifacts ===
✅ PASS: Build artifacts created
✅ PASS: Artifact size reasonable: my-app.dmg (103.5MB)

============================================================
TEST SUMMARY
============================================================
Tests passed: 18/18
🎉 All tests passed!
```

### Failed Test

```
❌ FAIL: File exists: package.json
    File not found

============================================================
TEST SUMMARY
============================================================
Tests passed: 15/18
❌ Some tests failed:
  - File exists: package.json: File not found
  - Has electron dependency: package.json not found
  - Electron app starts successfully: Dependencies not installed
```

## Troubleshooting

### Dependencies not installed

**Problem**: `Electron app startup: Dependencies not installed`

**Solution**: Install dependencies first:
```bash
cd desktop-app/my-docs
npm install
```

### Test server fails

**Problem**: `Test server startup: Address already in use`

**Solution**: The script uses a random port, but if issues persist:
```bash
# Kill any processes using port 8000
lsof -ti:8000 | xargs kill -9
```

### Electron startup test fails

**Problem**: `Electron app startup: Process exited early`

**Solution**: Test manually to see error:
```bash
cd desktop-app/my-docs
npm start
```

## Best Practices

1. **Test before distribution**: Always run tests before building final artifacts
2. **Use in CI/CD**: Integrate into automated workflows
3. **Quick mode for iteration**: Use `--quick` during development
4. **Full tests for release**: Run full tests before releases

## Related Tools

- **`mkdocs-portable`** - Create portable documentation sites
- **`mkdocs-build`** - Build MkDocs documentation
- **`mkdocs-server`** - Serve MkDocs documentation

## See Also

- [Electron Documentation](https://www.electronjs.org/)
- [MkDocs Documentation](https://www.mkdocs.org/)
- [electron-builder](https://www.electron.build/)
