# KernelSU Scripts

This directory contains utility scripts for KernelSU development and user assistance.

## User Scripts

### check_device.sh
**Purpose**: Help users identify their device and get installation recommendations

**Usage**:
```bash
./scripts/check_device.sh
```

**Requirements**:
- ADB installed and in PATH
- Device connected with USB debugging enabled
- Works on Linux, macOS, and Windows (with Git Bash/WSL)

**What it does**:
- Detects device model, kernel version, and Android version
- Checks bootloader lock status
- Determines if device is GKI compatible
- Provides installation method recommendations
- Links to device-specific guides
- Saves device info to a file for troubleshooting

## Developer Scripts

### ksubot.py
**Purpose**: Telegram bot for automated release notifications

**Usage**: Used in GitHub Actions workflows to post build artifacts to Telegram

### allowlist.bt
**Purpose**: BPF trace script for debugging allowlist operations

**Usage**: For kernel debugging and development

---

## Contributing

When adding new scripts:
1. Add execute permissions: `chmod +x scripts/your_script.sh`
2. Document the script in this README
3. Add usage examples
4. Test on multiple platforms if applicable
