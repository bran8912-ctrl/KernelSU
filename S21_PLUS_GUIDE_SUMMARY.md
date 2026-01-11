# Samsung Galaxy S21+ KernelSU Installation - Complete Solution

## Overview

This repository now contains comprehensive documentation and tools to help you build and run KernelSU on your Samsung Galaxy S21+ Android device.

## What's New

### 📚 Documentation

1. **[QUICKSTART.md](QUICKSTART.md)** - Fast-track guide to get KernelSU running
   - Quick compatibility check steps
   - Pre-built image installation
   - Device-specific guide references
   - Common troubleshooting tips

2. **[docs/BUILD_GUIDE_S21_PLUS.md](docs/BUILD_GUIDE_S21_PLUS.md)** - Complete S21+ Guide (415 lines)
   - Device information for all S21+ variants (Exynos/Snapdragon)
   - Prerequisites and required tools
   - Step-by-step installation for both GKI and non-GKI
   - Custom kernel building instructions
   - Post-installation configuration
   - Comprehensive troubleshooting section

3. **[website/docs/guide/device-guides.md](website/docs/guide/device-guides.md)** - Device Guide Index
   - Centralized hub for all device-specific guides
   - Template for contributing new device guides
   - Common device categories

### 📦 Modules

**[modules/Meta-Hybrid-v2.0.25](modules/Meta-Hybrid-v2.0.25/)** - Hybrid Mount Metamodule
- Advanced module mounting system for KernelSU
- 2GB ext4 image for module storage
- Multi-partition support (system, vendor, product, etc.)
- Web-based management interface
- Complete installation guide: [modules/MODULE-INSTALL.md](modules/MODULE-INSTALL.md)
- S21+ verified and tested

### 🛠️ Tools

**[scripts/check_device.sh](scripts/check_device.sh)** - Automated Device Checker
- Detects device model and kernel version
- Identifies KMI for GKI compatibility
- Checks bootloader lock status
- Provides installation method recommendations
- Generates device info report for troubleshooting
- Works on Linux, macOS, and Windows (Git Bash/WSL)

## Quick Start for S21+ Users

### Step 1: Check Your Device

```bash
# Connect your S21+ with USB debugging enabled
./scripts/check_device.sh
```

This will tell you:
- Your exact device model
- Kernel version and KMI
- Whether you need GKI or custom kernel
- Next steps specific to your device

### Step 2: Follow Your Path

**If Script Says "GKI Compatible":**
1. Download KernelSU Manager from [Releases](https://github.com/tiann/KernelSU/releases)
2. Open app to verify "Not installed" status
3. Download matching boot image (usually `boot-android12-5.10-lz4.img.gz`)
4. Flash using fastboot (see QUICKSTART.md)

**If Script Says "Custom Kernel Needed":**
1. Follow [docs/BUILD_GUIDE_S21_PLUS.md](docs/BUILD_GUIDE_S21_PLUS.md)
2. Section "Method B: Building Custom Kernel"
3. Use KernelSU v0.9.5 (last non-GKI version)

### Step 3: Root Verification with Meta-Hybrid (Optional)

After KernelSU is installed, you can enhance your module management with Meta-Hybrid:

1. **Install Meta-Hybrid Module**:
   - Open KernelSU Manager
   - Go to Modules section
   - Install from `modules/Meta-Hybrid-v2.0.25/` directory
   - Or install the original ZIP file

2. **Verify Installation**:
   ```bash
   adb shell su -c "ls -la /data/adb/modules/meta-hybrid/"
   adb shell su -c "cat /data/adb/meta-hybrid/daemon.log"
   ```

3. **Use Advanced Features**:
   - 2GB ext4 storage for modules
   - Web-based management interface
   - Hybrid mount for better compatibility
   - Multi-partition support

4. **Complete Guide**: See [modules/MODULE-INSTALL.md](modules/MODULE-INSTALL.md) for:
   - Detailed installation steps
   - Configuration options
   - Troubleshooting for S21+
   - Script explanations

## Installation Methods Covered

### Method A: LKM Mode (Recommended)
- Easiest for most users
- Keeps original kernel
- Easy OTA updates
- No permanent boot partition changes

### Method B: GKI Mode  
- Replace kernel with KernelSU GKI
- Works when LKM isn't supported
- Universal compatibility

### Method C: Custom Kernel Build
- For non-GKI devices
- Complete control
- Required for older kernels

## Important Warnings

### ⚠️ Before You Start

1. **Backup Everything**: Unlocking bootloader WIPES your device
2. **Knox Counter**: Will be permanently tripped (Samsung-specific features break)
3. **Warranty**: Rooting voids warranty in most regions
4. **SafetyNet**: Banking apps may not work (use hiding methods)
5. **Stock Firmware**: Download and keep a copy for recovery

### 🔓 Bootloader Unlock Required

Samsung S21+ bootloader unlock:
1. Enable Developer Options (tap Build Number 7x)
2. Enable OEM Unlocking in Developer Options
3. Power off device
4. Hold Volume Up + Volume Down, plug in USB
5. Long press Volume Up to unlock
6. **This WIPES all data!**

## What Makes This Guide Special

### For S21+ Specifically:
- ✅ Covers both Exynos 2100 and Snapdragon 888 variants
- ✅ Model numbers: SM-G996B/DS, SM-G996U/U1
- ✅ Android 11, 12, 13, 14 considerations
- ✅ Samsung-specific bootloader unlock process
- ✅ Knox and SafetyNet implications
- ✅ Download mode vs Fastboot mode
- ✅ Compression format recommendations (lz4/gz)

### General Improvements:
- ✅ Automated device detection script
- ✅ Clear decision tree for installation method
- ✅ Multiple installation paths
- ✅ Extensive troubleshooting section
- ✅ Links to external resources (firmware, tools, forums)
- ✅ Quick reference commands
- ✅ Safety warnings at critical steps

## Troubleshooting Quick Reference

| Issue | Solution |
|-------|----------|
| Bootloop after flash | Flash stock boot.img back, try different compression |
| Manager shows "Unsupported" | Need custom kernel build (Method B) |
| Bootloader locked | Must unlock first (see guide) |
| Wrong compression format | Try lz4 → gz → uncompressed |
| Root not working | Check Manager app profile settings |
| OTA breaks root | Use LKM mode, install to inactive slot |

## File Structure

```
KernelSU/
├── QUICKSTART.md                          # Quick start for all devices
├── S21_PLUS_GUIDE_SUMMARY.md             # This file - complete overview
├── docs/
│   ├── README.md                          # Updated with device guide links
│   └── BUILD_GUIDE_S21_PLUS.md           # Complete S21+ guide
├── modules/
│   ├── README.md                          # Modules directory overview
│   ├── MODULE-INSTALL.md                  # Meta-Hybrid installation guide
│   └── Meta-Hybrid-v2.0.25/              # Meta-Hybrid metamodule
│       ├── module.prop                    # Module metadata
│       ├── customize.sh                   # Installation script
│       ├── metainstall.sh                 # KernelSU metamodule install
│       ├── metamount.sh                   # KernelSU metamodule mount
│       ├── metauninstall.sh               # KernelSU metamodule uninstall
│       ├── binaries/                      # Architecture-specific binaries
│       │   └── arm64-v8a/meta-hybrid     # For S21+ devices
│       └── webroot/                       # Web UI assets
├── website/docs/guide/
│   ├── device-guides.md                   # Device guide index
│   └── build-s21-plus.md                  # S21+ guide (website copy)
└── scripts/
    ├── README.md                          # Scripts documentation
    └── check_device.sh                    # Device detection helper
```

## Resources

### Official Documentation
- 🌐 [KernelSU Website](https://kernelsu.org/)
- 📖 [General Installation Guide](https://kernelsu.org/guide/installation.html)
- 🔨 [How to Build Guide](https://kernelsu.org/guide/how-to-build.html)
- 🧩 [Non-GKI Integration](https://kernelsu.org/guide/how-to-integrate-for-non-gki.html)

### Downloads
- 📱 [KernelSU Manager APK](https://github.com/tiann/KernelSU/releases)
- 💿 [Boot Images](https://github.com/tiann/KernelSU/releases)
- 🔧 [ksud Tool](https://github.com/tiann/KernelSU/releases)

### Samsung S21+ Specific
- 📥 [Stock Firmware (Sammobile)](https://www.sammobile.com/samsung/galaxy-s21-plus-5g/)
- 🛠️ [Frija Firmware Downloader](https://forum.xda-developers.com/t/tool-frija-samsung-firmware-downloader-checker.3910594/)
- 💬 [XDA S21+ Forums](https://forum.xda-developers.com/f/samsung-galaxy-s21-s21-s21-ultra.12089/)

### Support
- 💬 [Telegram Group](https://t.me/KernelSU)
- 🐛 [GitHub Issues](https://github.com/tiann/KernelSU/issues)
- 📱 [XDA Forums](https://forum.xda-developers.com/)

## Contributing

Found this guide helpful? Consider:
- ⭐ Starring the repository
- 🐛 Reporting issues or improvements
- 📝 Contributing guides for other devices
- 💬 Helping others in Telegram/forums

### Adding Device Guides

See [website/docs/guide/device-guides.md](website/docs/guide/device-guides.md) for:
- Template and requirements
- How to structure device guides
- Contribution process

## FAQ

**Q: Will this work on S21/S21 Ultra?**  
A: The guide is specifically for S21+, but the process is similar. Check your exact model and kernel version.

**Q: Can I undo this?**  
A: Yes, flash stock boot.img to remove KernelSU. Knox counter cannot be reset.

**Q: What about OTA updates?**  
A: LKM mode supports "install to inactive slot". Otherwise, flash full stock firmware to update.

**Q: Is this safe?**  
A: Rooting always has risks. Follow the guide carefully, backup everything, keep stock firmware ready.

**Q: Which variant do I have?**  
A: Run `./scripts/check_device.sh` or check Settings → About Phone → Model Number.

## Version History

- **v1.0** (2026-01) - Initial comprehensive S21+ guide
  - Added QUICKSTART.md
  - Added BUILD_GUIDE_S21_PLUS.md
  - Added device-guides.md index
  - Added check_device.sh helper script
  - Updated docs/README.md with device guide links

## License

This documentation is part of the KernelSU project:
- Documentation: GPL-3.0-or-later
- KernelSU kernel code: GPL-2.0-only

## Credits

- **KernelSU Team**: For the amazing kernel-based root solution
- **Samsung Open Source**: For providing kernel source code
- **XDA Community**: For guides and support
- **Contributors**: Everyone who helped test and improve these guides

---

**Last Updated**: January 10, 2026  
**KernelSU Version**: Latest (check [releases](https://github.com/tiann/KernelSU/releases))  
**Document Version**: 1.0  

For the latest version of this guide, visit: [docs/BUILD_GUIDE_S21_PLUS.md](docs/BUILD_GUIDE_S21_PLUS.md)
