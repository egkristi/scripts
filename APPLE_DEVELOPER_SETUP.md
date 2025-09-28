# Apple Developer Code Signing Setup

This guide explains how to configure Apple Developer code signing for the mkdocs-portable script to create properly signed macOS applications.

## Overview

The mkdocs-portable script supports automatic code signing through a configuration file system that:
- Keeps sensitive Apple Developer credentials separate from code
- Is automatically gitignored for security
- Provides fallback to unsigned builds when not configured
- Generates proper entitlements and build configuration

## Quick Setup

### 1. Prerequisites

- **Apple Developer Account** ($99/year) - Required for code signing
- **Developer ID Application Certificate** - Download from Apple Developer portal
- **Certificate installed in Keychain** - Import the .p12 file into Keychain Access

### 2. Configuration

1. **Copy the template:**
   ```bash
   cp apple-developer-config.template.json apple-developer-config.json
   ```

2. **Fill in your details:**
   ```json
   {
     "enabled": true,
     "identity": "Developer ID Application: Your Name (TEAM_ID)",
     "teamId": "ABC123DEF4",
     "appleId": "your.email@example.com",
     "entitlements": {
       "com.apple.security.cs.allow-jit": true,
       "com.apple.security.cs.allow-unsigned-executable-memory": true,
       "com.apple.security.cs.disable-library-validation": true
     }
   }
   ```

3. **Find your certificate identity:**
   - Open **Keychain Access**
   - Look under **My Certificates**
   - Find certificate named: `Developer ID Application: Your Name (TEAM_ID)`
   - Copy the exact name including parentheses

### 3. Build Signed Applications

Once configured, run mkdocs-portable as normal:
```bash
mkdocs-portable --source-folder docs --target-folder output --with-electron --build-electron --site-name "My App"
```

The script will automatically:
- ✅ Detect your Apple Developer configuration
- ✅ Generate proper entitlements.mac.plist
- ✅ Configure electron-builder for code signing
- ✅ Enable hardenedRuntime for security
- ✅ Create properly signed macOS applications

## Configuration Reference

### Required Fields

| Field | Description | Example |
|-------|-------------|---------|
| `enabled` | Enable/disable code signing | `true` |
| `identity` | Certificate name from Keychain | `"Developer ID Application: John Doe (ABC123DEF4)"` |
| `teamId` | Apple Developer Team ID | `"ABC123DEF4"` |

### Optional Fields

| Field | Description | Default |
|-------|-------------|---------|
| `appleId` | Apple ID email (for notarization) | Not used currently |
| `entitlements` | macOS entitlements dictionary | See template |
| `notarization.enabled` | Enable notarization (future) | `false` |

### Entitlements Explained

The default entitlements are required for Electron applications:

```json
{
  "com.apple.security.cs.allow-jit": true,
  "com.apple.security.cs.allow-unsigned-executable-memory": true,
  "com.apple.security.cs.disable-library-validation": true
}
```

- **allow-jit**: Required for JavaScript execution
- **allow-unsigned-executable-memory**: Required for V8 engine
- **disable-library-validation**: Required for Node.js modules

## Finding Your Apple Developer Information

### Team ID
1. Go to [Apple Developer Account](https://developer.apple.com/account/#!/membership/)
2. Look for **Team ID** in the membership section
3. It's a 10-character alphanumeric string (e.g., `ABC123DEF4`)

### Certificate Identity
1. Open **Keychain Access** application
2. Select **My Certificates** category
3. Look for certificate starting with `Developer ID Application:`
4. Copy the complete name including the Team ID in parentheses

### Apple ID
- The email address associated with your Apple Developer account
- Currently used for documentation, future notarization support

## Troubleshooting

### "No identity found" Error
- Verify certificate is installed in Keychain Access
- Check the identity string matches exactly (including spaces and parentheses)
- Ensure certificate hasn't expired

### "Code signing failed" Error
- Verify you have a paid Apple Developer account
- Check that the certificate is valid and not revoked
- Ensure Xcode command line tools are installed: `xcode-select --install`

### Configuration Not Detected
- Verify file is named exactly `apple-developer-config.json`
- Check file is in the same directory as `apple-developer-config.template.json`
- Ensure JSON syntax is valid (use a JSON validator)

### Apps Still Show as Unsigned
- Verify `"enabled": true` in configuration
- Check that identity string is not empty
- Look for error messages during build process

## Security Notes

- ✅ **Configuration file is gitignored** - Won't be committed to repository
- ✅ **Template is safe to commit** - Contains no sensitive information
- ✅ **Credentials stay local** - Never transmitted or stored in code
- ⚠️ **Keep configuration secure** - Contains your Apple Developer identity

## Without Code Signing

If you don't have an Apple Developer account, the script works perfectly without code signing:
- Applications build successfully as unsigned
- Users can run apps with "Right-click → Open"
- Perfect for development, testing, and internal distribution
- No Apple Developer account required

## Future Enhancements

Planned features for the configuration system:
- **Notarization support** - Automatic notarization for App Store distribution
- **Multiple identity support** - Different certificates for different projects
- **Keychain integration** - Direct certificate lookup from Keychain
- **Validation tools** - Built-in certificate verification

---

For questions or issues, refer to the main mkdocs-portable documentation or create an issue in the repository.
