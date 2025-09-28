# Installation Guide

## Quick Start (Recommended)

**Just want to get started?** Run this one command:
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/egkristi/shell-scripts/refs/heads/main/init.sh)"
```

This will automatically set up everything you need. Continue reading for manual installation or troubleshooting.

---

## Platform-Specific Installation

### 🍎 macOS

**Prerequisites:**
```bash
# Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Python (recommended)
brew install python

# Install uv
brew install uv
```

### 🪟 Windows

**Option 1: Modern Windows (10/11 with winget)**
```powershell
# Install Python (recommended)
winget install Python.Python.3.12

# Install uv
winget install astral-sh.uv

# Install bash/shell environment (choose one):
# Option A: Git Bash (lightweight)
winget install Git.Git

# Option B: Windows Subsystem for Linux (full Linux environment)
wsl --install

# Option C: MSYS2 (Unix-like environment)
winget install MSYS2.MSYS2
```

**Option 2: Alternative package managers**
```powershell
# Using Chocolatey
choco install python uv git

# Using Scoop
scoop install python uv git
```

**Shell Setup for Windows:**

*Git Bash (Recommended for beginners):*
- Comes with Git installation
- Provides bash shell on Windows
- Works with most shell scripts

*Windows Subsystem for Linux (WSL):*
```powershell
# Enable WSL and install Ubuntu
wsl --install
# After restart, open Ubuntu from Start Menu
```

*MSYS2 (Advanced users):*
```bash
# After installing MSYS2, open MSYS2 terminal and run:
pacman -S bash zsh git
```

*PowerShell with bash compatibility:*
```powershell
# Install PowerShell 7+ (if not already installed)
winget install Microsoft.PowerShell

# Many scripts work in PowerShell, but bash is recommended
```

### 🐧 Linux

**Ubuntu/Debian:**
```bash
# Install Python first (recommended)
sudo apt update
sudo apt install python3 python3-pip

# Install uv via pipx (recommended)
sudo apt install pipx
pipx install uv

# Or use official installer
curl -LsSf https://astral.sh/uv/install.sh | sh

# Bash is usually pre-installed, install zsh if desired
sudo apt install zsh
```

**Fedora/RHEL/CentOS:**
```bash
# Install Python first (recommended)
sudo dnf install python3 python3-pip

# Install uv via pipx
pip3 install --user pipx
pipx install uv

# Or use official installer
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install zsh if desired
sudo dnf install zsh
```

**Arch Linux:**
```bash
# Install Python first (recommended)
sudo pacman -S python python-pip

# Install uv
sudo pacman -S uv

# Or install from AUR
yay -S uv

# Bash is pre-installed, install zsh if desired
sudo pacman -S zsh
```

---

## Manual Installation Steps

### Step 1: Install Python (Recommended)

**Note:** While uv can automatically manage Python versions, having Python pre-installed is recommended for better performance and reliability.

```bash
# Mac
brew install python

# Windows
winget install Python.Python.3.12

# Linux
sudo apt install python3 python3-pip  # Ubuntu/Debian
sudo dnf install python3 python3-pip  # Fedora/RHEL
sudo pacman -S python python-pip      # Arch
```

### Step 2: Install uv Package Manager

**Package managers (recommended):**
```bash
# Mac
brew install uv

# Windows
winget install astral-sh.uv

# Linux (via pipx)
pipx install uv
```

**Official installer (alternative):**
```bash
# Unix/Mac/Linux
curl -LsSf https://astral.sh/uv/install.sh | sh

# Windows (PowerShell)
irm https://astral.sh/uv/install.ps1 | iex
```

### Step 3: Install Shell Environment

**macOS/Linux:**
- Bash: Usually pre-installed
- Zsh: `brew install zsh` (Mac) or `sudo apt install zsh` (Linux)

**Windows (choose one):**
- **Git Bash**: `winget install Git.Git` (includes bash)
- **WSL**: `wsl --install` (full Linux environment)
- **MSYS2**: `winget install MSYS2.MSYS2` (Unix-like environment)

---

## Troubleshooting

### Windows-Specific Issues

**"bash: command not found"**
- Install Git Bash: `winget install Git.Git`
- Or use WSL: `wsl --install`
- Or run scripts in PowerShell (most work)

**"winget: command not found"**
- Install App Installer from Microsoft Store
- Or use Chocolatey: `choco install uv`
- Or use Scoop: `scoop install uv`

**Scripts don't run in PowerShell**
- Use Git Bash or WSL instead
- Or install bash in PowerShell: `winget install Git.Git`

### General Issues

**"uv: command not found"**
- Restart your terminal after installation
- Check if uv is in PATH: `echo $PATH`
- Reinstall using official installer

**Permission errors**
- On Linux/Mac: Don't use `sudo` with uv
- On Windows: Run terminal as administrator if needed

**Python version issues**
- Let uv manage Python: it will download the right version
- Or install Python manually from python.org

---

## Setup Options

After installing the prerequisites above, choose how to set up the scripts:

### Option 1: Automatic Setup (Recommended)
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/egkristi/shell-scripts/refs/heads/main/init.sh)"
```
This adds scripts to your PATH automatically.

### Option 2: Manual Setup
```bash
git clone https://github.com/egkristi/shell-scripts.git
cd shell-scripts
./init.sh
```

### Option 3: Direct Usage (No Setup)
```bash
# Use scripts directly without PATH modification
./shell-scripts/sbin/script-name [options]
```

---

## How Python Dependencies Work

Python scripts in this collection use **uv's inline dependencies feature** (PEP 723):

✅ **No manual dependency installation required**  
✅ **Automatic virtual environment management**  
✅ **Isolated dependencies per script**  
✅ **Consistent behavior across systems**  
✅ **Only requirement: uv installed**

Dependencies are declared directly in each Python script and automatically installed when the script runs.

### Example Script Structure
```python
#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.8"
# dependencies = [
#     "requests>=2.25.0",
#     "click>=8.0.0",
# ]
# ///
"""
Script description here.
"""

# Your script code here
if __name__ == "__main__":
    main()
```

This means when you run a Python script, uv automatically:
1. Creates an isolated virtual environment
2. Uses your installed Python or downloads the required version if needed
3. Installs the script's dependencies
4. Runs the script in the isolated environment

**Benefits of pre-installing Python:**
- **Faster startup** - No need to download Python on first run
- **Better reliability** - Uses your system's Python installation
- **Consistent behavior** - Same Python version across all scripts

**First run:** A few seconds to set up environment (faster with pre-installed Python)  
**Subsequent runs:** Nearly instant (environment is cached)
