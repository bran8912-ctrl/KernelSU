# KernelSU Modules Directory

This directory contains KernelSU-compatible modules that are integrated into the repository for Samsung Galaxy S21+ root verification and testing.

## Available Modules

### Meta-Hybrid v2.0.25

**Type**: Metamodule  
**Purpose**: Advanced hybrid mount system for KernelSU modules  
**Location**: `modules/Meta-Hybrid-v2.0.25/`

Meta-Hybrid is a specialized metamodule that provides:
- Hybrid overlay filesystem for system modifications
- 2GB ext4 image for module storage
- Multi-partition support (system, vendor, product, etc.)
- Web-based management interface
- Compatible with Samsung Galaxy S21+ devices

**Quick Start**:
1. Install KernelSU on your S21+ ([BUILD_GUIDE_S21_PLUS.md](../docs/BUILD_GUIDE_S21_PLUS.md))
2. Read the [MODULE-INSTALL.md](MODULE-INSTALL.md) guide
3. Install via KernelSU Manager or ADB

**Documentation**:
- 📖 [Complete Installation Guide](MODULE-INSTALL.md)
- 🔧 [S21+ Build Guide](../docs/BUILD_GUIDE_S21_PLUS.md)
- ⚡ [Quick Start Guide](../QUICKSTART.md)

## What is a Module?

A KernelSU module is a ZIP file that contains:
- `module.prop` - Module metadata
- Installation scripts (customize.sh, etc.)
- System modifications or binaries
- Optional web UI assets

Modules allow you to modify the system without actually modifying system partitions, making changes reversible and safe.

## What is a Metamodule?

A **metamodule** is a special module that:
- Marked with `metamodule=1` in module.prop
- Controls HOW other modules are mounted
- Only ONE can be active at a time
- Uses special hooks (metainstall.sh, metamount.sh, metauninstall.sh)
- Runs before regular modules during boot

Meta-Hybrid is a metamodule that provides advanced mounting capabilities beyond KernelSU's default module system.

## Directory Structure

```
modules/
├── README.md                           # This file
├── MODULE-INSTALL.md                   # Detailed installation guide
└── Meta-Hybrid-v2.0.25/               # Meta-Hybrid module files
    ├── module.prop                     # Module metadata
    ├── customize.sh                    # Installation script
    ├── metainstall.sh                  # Metamodule install hook (KernelSU)
    ├── metamount.sh                    # Metamodule mount hook (KernelSU)
    ├── metauninstall.sh                # Metamodule uninstall hook (KernelSU)
    ├── uninstall.sh                    # Module uninstaller
    ├── post-fs-data.sh                 # Early boot script (Magisk compat)
    ├── service.sh                      # Late boot script (Magisk compat)
    ├── config.toml                     # Default configuration
    ├── binaries/                       # Architecture-specific binaries
    │   ├── arm64-v8a/
    │   │   └── meta-hybrid             # For S21+ and most Android devices
    │   ├── x86_64/
    │   │   └── meta-hybrid             # For x86_64 emulators
    │   └── riscv64/
    │       └── meta-hybrid             # For RISC-V devices
    ├── tools/
    │   └── mkfs.erofs                  # EROFS filesystem tool
    └── webroot/                        # Web UI assets
        ├── index.html
        └── assets/
```

## Installation Guide

### Prerequisites

Before installing any module:

1. **KernelSU Installed**: Must have working KernelSU
   ```bash
   adb shell su -c "echo KernelSU works"
   ```

2. **Bootloader Unlocked**: Samsung S21+ bootloader must be unlocked
   ```bash
   adb shell getprop ro.boot.verifiedbootstate
   ```

3. **Sufficient Storage**: At least 3GB free in `/data`
   ```bash
   adb shell df -h /data
   ```

4. **Backup**: Always backup your current setup
   ```bash
   # Backup boot.img and data before proceeding
   ```

### Installation Methods

#### Method 1: KernelSU Manager (Recommended)

1. Open KernelSU Manager app
2. Navigate to "Modules" section
3. Tap the "+" button
4. Select the module ZIP file
5. Wait for installation
6. Reboot device

#### Method 2: ADB Installation

```bash
# Push module to device
adb push modules/Meta-Hybrid-v2.0.25 /data/adb/modules/meta-hybrid

# Set permissions
adb shell su -c "chown -R 0:0 /data/adb/modules/meta-hybrid"
adb shell su -c "chmod -R 0755 /data/adb/modules/meta-hybrid"

# Reboot
adb reboot
```

#### Method 3: From ZIP File

If you need to create a ZIP for installation:

```bash
cd modules/Meta-Hybrid-v2.0.25
zip -r ../Meta-Hybrid-v2.0.25.zip *
# Install the ZIP through KernelSU Manager
```

## Verification

After installation, verify the module is working:

```bash
# Check module is loaded
adb shell su -c "ls -la /data/adb/modules/meta-hybrid/"

# For Meta-Hybrid specifically
adb shell su -c "cat /data/adb/meta-hybrid/daemon.log"

# Check in KernelSU Manager
# Should show "Hybrid Mount v2.0.25" as enabled
```

## Module-Specific Documentation

Each module may have additional documentation:

- **Meta-Hybrid**: See [MODULE-INSTALL.md](MODULE-INSTALL.md) for complete guide
  - Installation steps
  - Configuration options
  - Script explanations
  - Troubleshooting
  - Samsung S21+ specific notes

## Troubleshooting

### Module Not Showing in Manager

```bash
# Check if module directory exists
adb shell su -c "ls -la /data/adb/modules/"

# Look for disable flag
adb shell su -c "ls /data/adb/modules/*/disable"

# Remove disable flag if present
adb shell su -c "rm /data/adb/modules/meta-hybrid/disable"

# Reboot
adb reboot
```

### Module Causes Bootloop

```bash
# Boot to recovery mode (Volume Up + Power)
# Mount /data partition
adb shell mount /data

# Disable the module
adb shell touch /data/adb/modules/meta-hybrid/disable

# Or remove completely
adb shell rm -rf /data/adb/modules/meta-hybrid

# Reboot
adb reboot
```

### Module Not Working After Reboot

```bash
# Check module status
adb shell su -c "cat /data/adb/modules/meta-hybrid/module.prop"

# Check for errors in logs
adb logcat -d | grep -i kernelsu

# For Meta-Hybrid, check daemon log
adb shell su -c "cat /data/adb/meta-hybrid/daemon.log"
```

## Samsung S21+ Specific Notes

### Variants Supported
- SM-G996B/DS (Exynos 2100)
- SM-G996U/U1 (Snapdragon 888)

### Architecture
- All S21+ devices use **arm64-v8a**
- Meta-Hybrid will automatically select the correct binary during installation

### Knox Considerations
- Knox counter already tripped by bootloader unlock
- Modules won't further impact Knox
- Samsung Health, Secure Folder won't work (Knox dependent)

### SafetyNet/Play Integrity
- Meta-Hybrid may be detected by banking apps
- Use hiding modules like Shamiko with Meta-Hybrid
- Configure module to hide KernelSU from specific apps

### OTA Updates
- OTA updates will remove KernelSU and all modules
- After OTA, reinstall KernelSU
- Modules can then be restored from backups

## Best Practices

1. **One Module at a Time**: Install and test modules individually
2. **Read Documentation**: Check module-specific docs before installing
3. **Keep Backups**: Maintain working boot.img backup
4. **Test After Reboot**: Always verify functionality after installation
5. **Monitor Logs**: Check logs for errors after first boot
6. **Disable Before Troubleshooting**: Disable modules to isolate issues

## Safety Guidelines

⚠️ **Important Safety Notes**:

- Modules have full system access - only install trusted modules
- Always backup before installing new modules
- Keep stock firmware ready for recovery
- Test modules on a device you can afford to lose data on
- Some modules may conflict with each other
- Metamodules (like Meta-Hybrid) take control of all module mounting

## Related Documentation

- 📖 [BUILD_GUIDE_S21_PLUS.md](../docs/BUILD_GUIDE_S21_PLUS.md) - KernelSU installation for S21+
- 📖 [MODULE-INSTALL.md](MODULE-INSTALL.md) - Meta-Hybrid detailed guide
- 📖 [S21_PLUS_GUIDE_SUMMARY.md](../S21_PLUS_GUIDE_SUMMARY.md) - Quick reference
- 📖 [QUICKSTART.md](../QUICKSTART.md) - Fast-track guide
- 🌐 [KernelSU Official Docs](https://kernelsu.org/guide/module.html) - Module development

## Getting Help

1. **Check Logs**: Always check logs first for error messages
2. **Read Documentation**: Module-specific docs contain troubleshooting sections
3. **Community Support**:
   - [KernelSU Telegram](https://t.me/KernelSU)
   - [XDA S21+ Forums](https://forum.xda-developers.com/f/samsung-galaxy-s21-s21-s21-ultra.12089/)
   - [GitHub Issues](https://github.com/tiann/KernelSU/issues)

## Contributing

To add a new module to this directory:

1. Create a new directory: `modules/<module-name>-<version>/`
2. Include all module files (module.prop, scripts, binaries, etc.)
3. Update this README.md with module information
4. Create or update module-specific documentation
5. Test on Samsung S21+ before submitting
6. Submit a pull request with:
   - Module description
   - Installation instructions
   - Compatibility information
   - Test results

## License

Individual modules may have their own licenses. Check each module directory for license information.

- **Meta-Hybrid**: See module repository for license
- **This Documentation**: GPL-3.0-or-later (part of KernelSU project)

---

**Last Updated**: January 11, 2026  
**For**: Samsung Galaxy S21+ KernelSU Integration  
**Version**: 1.0
