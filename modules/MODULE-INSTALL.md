# Meta-Hybrid v2.0.25 Module Installation Guide

## Overview

Meta-Hybrid is a KernelSU metamodule that provides advanced hybrid mount capabilities for Android devices. This guide is specifically tailored for Samsung Galaxy S21+ users who need root verification and module management.

## What is Meta-Hybrid?

Meta-Hybrid (Hybrid Mount) is a **metamodule** for KernelSU that:
- Provides flexible mounting strategies for system partitions
- Creates a hybrid overlay filesystem for modules
- Manages module installations in an ext4 image file
- Supports both KernelSU and Magisk-compatible environments
- Includes a web-based management interface

### Key Features

- **Hybrid Mount Technology**: Combines traditional and modern mounting techniques
- **Multi-Architecture Support**: Works on arm64-v8a, x86_64, and riscv64
- **Dynamic Module Management**: 2GB ext4 image for storing module files
- **Partition Handling**: Supports system, vendor, product, system_ext, odm, oem, and apex
- **Web UI**: Built-in web interface for module management (accessible via localhost)
- **KernelSU Integration**: Native metamodule support with dedicated hooks

## What is a Metamodule?

A **metamodule** in KernelSU is a special type of module marked with `metamodule=1` in `module.prop`. Key characteristics:

- **Single Active Metamodule**: Only ONE metamodule can be active at a time
- **Early Execution**: Runs before regular modules during boot
- **Mount Control**: Has full control over how modules are mounted
- **Special Hooks**: Uses `metainstall.sh`, `metamount.sh`, and `metauninstall.sh` scripts
- **Symlink Creation**: KernelSU creates `/data/adb/metamodule` symlink pointing to the active metamodule

## Samsung Galaxy S21+ Compatibility

### Supported Variants
- **SM-G996B/DS** (Exynos 2100) - International ✅
- **SM-G996U/U1** (Snapdragon 888) - US/China ✅

### Requirements
- KernelSU installed and working (see [BUILD_GUIDE_S21_PLUS.md](../docs/BUILD_GUIDE_S21_PLUS.md))
- Android 11, 12, 13, or 14
- Kernel version 5.4 or 5.10
- Unlocked bootloader
- At least 3GB free space in `/data` partition

### Verification Steps

Before installing Meta-Hybrid, verify your KernelSU installation:

```bash
# 1. Check KernelSU is installed
adb shell su -c "echo KernelSU works"

# 2. Verify kernel version
adb shell uname -r

# 3. Check available space
adb shell df -h /data

# 4. Verify architecture
adb shell getprop ro.product.cpu.abi
```

Expected outputs:
- Command 1: Should print "KernelSU works"
- Command 2: Should show 5.4.x or 5.10.x
- Command 3: Should show at least 3GB available
- Command 4: Should show "arm64-v8a"

## Installation Methods

### Method 1: Using KernelSU Manager (Recommended)

1. **Open KernelSU Manager** app on your S21+

2. **Navigate to Modules** section

3. **Install from ZIP**:
   - Tap the floating action button (+)
   - Select `Meta-Hybrid-v2.0.25.zip` from storage
   - Wait for installation to complete

4. **Reboot** your device

5. **Verify Installation**:
   - Open KernelSU Manager
   - Check Modules section for "Hybrid Mount v2.0.25"
   - Status should show "✓" (enabled)

### Method 2: ADB Installation (Manual)

```bash
# 1. Push the ZIP file to device
adb push Meta-Hybrid-v2.0.25.zip /sdcard/

# 2. Install using ksud
adb shell su -c "ksud module install /sdcard/Meta-Hybrid-v2.0.25.zip"

# 3. Reboot
adb reboot

# 4. Verify installation
adb shell su -c "ls -la /data/adb/modules/"
```

### Method 3: Local Installation (From Repository)

If you have the repository cloned:

```bash
cd /home/runner/work/KernelSU/KernelSU

# Copy module files to device
adb push modules/Meta-Hybrid-v2.0.25 /data/adb/modules/meta-hybrid

# Set proper permissions
adb shell su -c "chown -R 0:0 /data/adb/modules/meta-hybrid"
adb shell su -c "chmod -R 0755 /data/adb/modules/meta-hybrid"
adb shell su -c "chmod 0644 /data/adb/modules/meta-hybrid/*.prop"
adb shell su -c "chmod 0644 /data/adb/modules/meta-hybrid/*.toml"

# Reboot
adb reboot
```

## Installation Process Details

### What Happens During Installation

1. **customize.sh** runs first:
   - Extracts module files from ZIP
   - Detects device architecture (arm64-v8a for S21+)
   - Copies appropriate binary to module directory
   - Sets up base directory at `/data/adb/meta-hybrid`
   - Creates default `config.toml` if not exists
   - Creates 2GB `modules.img` (ext4, no journal) if not exists

2. **metainstall.sh** runs (KernelSU-specific):
   - Handles partition directories (system, vendor, product, etc.)
   - Moves partition directories from `system/` to root level
   - Cleans up empty system directory
   - Registers as KernelSU metamodule

3. **File Structure Created**:
   ```
   /data/adb/modules/meta-hybrid/
   ├── meta-hybrid              # Binary daemon (architecture-specific)
   ├── module.prop              # Module metadata
   ├── config.toml              # Configuration file
   ├── metainstall.sh           # Metamodule install hook
   ├── metamount.sh             # Metamodule mount hook
   ├── metauninstall.sh         # Metamodule uninstall hook
   ├── customize.sh             # Installation script
   ├── uninstall.sh             # Module uninstaller
   ├── tools/
   │   └── mkfs.erofs           # EROFS filesystem creator
   └── webroot/                 # Web UI assets
       ├── index.html
       └── assets/
   
   /data/adb/meta-hybrid/
   ├── config.toml              # Active configuration
   ├── modules.img              # 2GB ext4 image for modules
   ├── mnt/                     # Mount point for modules.img
   └── daemon.log               # Daemon log file
   ```

## Configuration

### config.toml Settings

Default configuration at `/data/adb/meta-hybrid/config.toml`:

```toml
moduledir = "/data/adb/modules/"
mountsource = "KSU"
verbose = false
partitions = []
```

**Configuration Options**:

- `moduledir`: Directory where modules are stored
  - Default: `/data/adb/modules/`
  - Don't change unless you know what you're doing

- `mountsource`: Root solution being used
  - `"KSU"` for KernelSU (default for S21+ with KernelSU)
  - `"MAGISK"` for Magisk compatibility mode

- `verbose`: Enable detailed logging
  - `false` (default) - Normal logging
  - `true` - Debug logging (useful for troubleshooting)

- `partitions`: Custom partition list
  - `[]` (default) - Auto-detect all partitions
  - Add specific partitions: `["system", "vendor"]`

### Customizing Configuration

```bash
# Edit config on device
adb shell su -c "vi /data/adb/meta-hybrid/config.toml"

# Or push edited config from PC
adb push config.toml /data/adb/meta-hybrid/config.toml

# Reboot to apply changes
adb reboot
```

## Script Explanations

### metainstall.sh

**Purpose**: Handles module installation as a KernelSU metamodule

**Key Actions**:
1. Sets environment variables (`KSU_HAS_METAMODULE`, `KSU_METAMODULE`)
2. Processes partition directories
3. Moves directories from `/system/<partition>` to `/<partition>`
4. Removes empty `/system` directory to skip system mount

**Why It Matters**: This script ensures module files are organized correctly for KernelSU's metamodule mount system.

### metamount.sh

**Purpose**: Starts the meta-hybrid daemon during boot

**Key Actions**:
1. Creates base directory `/data/adb/meta-hybrid`
2. Clears old log file
3. Starts `meta-hybrid` binary
4. Logs output to `daemon.log`
5. Notifies KernelSU when mounting complete

**Why It Matters**: This is the heart of the metamodule - it mounts the modules.img and makes all modules available.

### metauninstall.sh

**Purpose**: Cleans up when a module using meta-hybrid is removed

**Key Actions**:
1. Checks if mount point exists
2. Removes module directory from modules.img
3. Preserves the modules.img file itself

**Why It Matters**: Ensures clean removal of individual modules without breaking the metamodule system.

### uninstall.sh

**Purpose**: Removes the Meta-Hybrid metamodule completely

**Key Actions**:
1. Unmounts modules.img if mounted
2. Removes base directory `/data/adb/meta-hybrid`
3. Removes all module files

**Why It Matters**: Complete cleanup when you want to remove Meta-Hybrid entirely.

### customize.sh

**Purpose**: Handles initial installation from ZIP

**Key Actions**:
1. Detects device architecture
2. Copies correct binary (arm64-v8a for S21+)
3. Creates 2GB modules.img if needed
4. Sets up configuration
5. Removes compatibility scripts based on root solution

**Why It Matters**: Ensures correct installation for your specific device and root solution.

## Verification and Testing

### Verify Installation

```bash
# 1. Check module is loaded
adb shell su -c "ls -la /data/adb/modules/meta-hybrid/"

# 2. Verify metamodule symlink
adb shell su -c "ls -la /data/adb/metamodule"
# Should point to: /data/adb/modules/meta-hybrid

# 3. Check daemon is running
adb shell su -c "cat /data/adb/meta-hybrid/daemon.log"

# 4. Verify modules.img exists and is mounted
adb shell su -c "ls -lh /data/adb/meta-hybrid/modules.img"
adb shell su -c "mount | grep modules.img"

# 5. Check KernelSU Manager
# Open app → Modules → Should show "Hybrid Mount v2.0.25"
```

### Test Module Functionality

```bash
# 1. Install a test module through KernelSU Manager
# Any KernelSU-compatible module will work

# 2. Check if module appears in hybrid mount
adb shell su -c "ls /data/adb/meta-hybrid/mnt/"

# 3. Verify module is mounted
adb shell su -c "mount | grep meta-hybrid"
```

## Troubleshooting for S21+

### Module Not Showing in Manager

**Symptoms**: Meta-Hybrid doesn't appear in KernelSU Manager modules list

**Solutions**:
```bash
# 1. Check if module directory exists
adb shell su -c "ls -la /data/adb/modules/ | grep meta"

# 2. Verify module.prop is present
adb shell su -c "cat /data/adb/modules/meta-hybrid/module.prop"

# 3. Check for disable flag
adb shell su -c "ls /data/adb/modules/meta-hybrid/disable"
# If exists, remove it: rm /data/adb/modules/meta-hybrid/disable

# 4. Force module rescan
adb reboot
```

### Installation Fails

**Symptoms**: ZIP installation fails in KernelSU Manager

**Solutions**:
```bash
# 1. Check available space
adb shell df -h /data
# Need at least 3GB free

# 2. Check KernelSU version
adb shell su -c "ksud -V"
# Should be v0.7.0 or newer for metamodule support

# 3. Try manual installation method
# See "Method 2: ADB Installation" above

# 4. Check installation logs
adb shell su -c "logcat -d | grep -i kernelsu"
```

### Daemon Not Starting

**Symptoms**: daemon.log shows errors or is empty

**Solutions**:
```bash
# 1. Check daemon log
adb shell su -c "cat /data/adb/meta-hybrid/daemon.log"

# 2. Verify binary exists and is executable
adb shell su -c "ls -la /data/adb/modules/meta-hybrid/meta-hybrid"
# Should show: -rwxr-xr-x (755 permissions)

# 3. Test binary manually
adb shell su -c "/data/adb/modules/meta-hybrid/meta-hybrid --help"

# 4. Check for SELinux denials
adb shell su -c "dmesg | grep -i avc | grep meta-hybrid"

# 5. Ensure proper architecture
adb shell su -c "file /data/adb/modules/meta-hybrid/meta-hybrid"
# Should show: ARM aarch64 (for S21+)
```

### modules.img Not Created

**Symptoms**: modules.img file missing or empty

**Solutions**:
```bash
# 1. Check if file exists
adb shell su -c "ls -lh /data/adb/meta-hybrid/modules.img"

# 2. Manually create it
adb shell su -c "cd /data/adb/meta-hybrid && truncate -s 2G modules.img"
adb shell su -c "mkfs.ext4 -O ^has_journal /data/adb/meta-hybrid/modules.img"

# 3. Verify creation
adb shell su -c "file /data/adb/meta-hybrid/modules.img"
# Should show: Linux ext4 filesystem

# 4. Reboot to mount it
adb reboot
```

### Bootloop After Installation

**Symptoms**: Device stuck in boot animation after installing Meta-Hybrid

**Recovery Steps**:
```bash
# Boot to recovery mode (Volume Up + Power)

# Option 1: ADB in recovery (if available)
adb shell mount /data
adb shell rm /data/adb/modules/meta-hybrid/disable
adb shell touch /data/adb/modules/meta-hybrid/disable
adb reboot

# Option 2: Format data (LAST RESORT - LOSES ALL DATA)
# Use Samsung Odin to flash stock firmware

# Prevention: Always backup boot.img before modifying root
```

### Web UI Not Accessible

**Symptoms**: Cannot access Meta-Hybrid web interface

**Solutions**:
```bash
# 1. Check if daemon is running
adb shell su -c "ps -A | grep meta-hybrid"

# 2. Check log for port number
adb shell su -c "cat /data/adb/meta-hybrid/daemon.log | grep -i port"

# 3. Set up port forwarding
adb forward tcp:8080 tcp:8080  # Adjust port if needed

# 4. Access in browser
# Open: http://localhost:8080

# 5. Verify web files exist
adb shell su -c "ls /data/adb/modules/meta-hybrid/webroot/"
```

### Other Modules Not Working

**Symptoms**: After installing Meta-Hybrid, other modules stop working

**Diagnosis**:
```bash
# 1. Check if modules are in the image
adb shell su -c "ls /data/adb/meta-hybrid/mnt/"

# 2. Verify mount is successful
adb shell su -c "mount | grep meta-hybrid"

# 3. Check individual module status
adb shell su -c "ls /data/adb/modules/*/disable"

# 4. Review daemon log
adb shell su -c "tail -100 /data/adb/meta-hybrid/daemon.log"
```

**Solution**: Disable verbose logging in config.toml and reboot:
```bash
adb shell su -c "sed -i 's/verbose = true/verbose = false/' /data/adb/meta-hybrid/config.toml"
adb reboot
```

## Uninstallation

### Method 1: Through KernelSU Manager

1. Open KernelSU Manager
2. Go to Modules section
3. Find "Hybrid Mount"
4. Tap and select "Uninstall"
5. Reboot device

### Method 2: Manual Uninstall via ADB

```bash
# 1. Disable module
adb shell su -c "touch /data/adb/modules/meta-hybrid/disable"

# 2. Reboot to safe mode
adb reboot

# 3. Remove module completely
adb shell su -c "rm -rf /data/adb/modules/meta-hybrid"
adb shell su -c "rm -rf /data/adb/meta-hybrid"

# 4. Reboot normally
adb reboot
```

### Method 3: Recovery Mode Uninstall

If device won't boot:

1. Boot to recovery (Volume Up + Power)
2. Mount `/data` partition
3. Use ADB:
   ```bash
   adb shell mount /data
   adb shell rm -rf /data/adb/modules/meta-hybrid
   adb shell rm -rf /data/adb/meta-hybrid
   adb reboot
   ```

## Best Practices for S21+

### Before Installation

1. ✅ **Backup Everything**: Full system backup using TWRP or Samsung Smart Switch
2. ✅ **Verify KernelSU**: Ensure KernelSU is working properly
3. ✅ **Check Space**: Ensure 3GB+ free in `/data`
4. ✅ **Update Firmware**: Install latest Samsung firmware for your region
5. ✅ **Test in Safe Mode**: If unsure, install with other modules disabled

### After Installation

1. ✅ **Monitor Logs**: Check daemon.log after first boot
2. ✅ **Test Functionality**: Verify root access still works
3. ✅ **Install Gradually**: Add modules one at a time
4. ✅ **Keep Backups**: Maintain backup of working boot.img
5. ✅ **Document Issues**: Note any problems for troubleshooting

### Samsung-Specific Considerations

- **Knox**: Already tripped by unlocking bootloader (no additional impact)
- **SafetyNet**: Meta-Hybrid may be detected by banking apps
  - Solution: Use hiding modules like "Shamiko" or "Zygisk-Assistant"
- **Samsung Health**: Won't work with rooted device (Knox dependency)
- **OTA Updates**: Install to inactive slot or flash full firmware
- **Secure Folder**: Will not function (Knox dependency)

## Advanced Usage

### Custom Partition Configuration

Edit `/data/adb/meta-hybrid/config.toml` to specify partitions:

```toml
moduledir = "/data/adb/modules/"
mountsource = "KSU"
verbose = true  # Enable for debugging
partitions = ["system", "vendor", "product"]  # Only mount these
```

### Debug Mode

Enable verbose logging for troubleshooting:

```bash
adb shell su -c "sed -i 's/verbose = false/verbose = true/' /data/adb/meta-hybrid/config.toml"
adb reboot
adb shell su -c "cat /data/adb/meta-hybrid/daemon.log"
```

### Expanding modules.img

If 2GB is not enough:

```bash
# 1. Boot to recovery or disable module
adb shell su -c "touch /data/adb/modules/meta-hybrid/disable"
adb reboot

# 2. Backup existing image
adb pull /data/adb/meta-hybrid/modules.img modules.img.backup

# 3. Resize the image
adb shell su -c "truncate -s 4G /data/adb/meta-hybrid/modules.img"
adb shell su -c "e2fsck -f /data/adb/meta-hybrid/modules.img"
adb shell su -c "resize2fs /data/adb/meta-hybrid/modules.img"

# 4. Enable module and reboot
adb shell su -c "rm /data/adb/modules/meta-hybrid/disable"
adb reboot
```

## Performance Considerations

### Impact on Boot Time

- **First Boot**: +5-10 seconds (modules.img creation and mounting)
- **Subsequent Boots**: +2-3 seconds (mounting existing image)
- **With Many Modules**: +1 second per 10 modules (approximately)

### Storage Usage

- **Base Module**: ~10 MB
- **modules.img**: 2 GB (sparse, grows as modules are added)
- **Logs**: < 1 MB (rotated automatically)
- **Web UI Assets**: ~1 MB

### Memory Usage

- **Daemon**: 5-10 MB RAM
- **Mounted Modules**: Depends on individual module size
- **Typical Total**: 20-50 MB additional RAM usage

## Support and Resources

### Getting Help

1. **Check Logs First**:
   ```bash
   adb shell su -c "cat /data/adb/meta-hybrid/daemon.log"
   adb logcat -d | grep -i "meta-hybrid"
   ```

2. **Official Resources**:
   - Meta-Hybrid GitHub: [YuzakiKokuban/meta-hybrid_mount](https://github.com/YuzakiKokuban/meta-hybrid_mount)
   - KernelSU Telegram: [t.me/KernelSU](https://t.me/KernelSU)
   - XDA S21+ Forum: [forum.xda-developers.com](https://forum.xda-developers.com/f/samsung-galaxy-s21-s21-s21-ultra.12089/)

3. **Submit Issues**:
   - Provide device info (model, Android version, kernel version)
   - Include daemon.log and relevant logcat output
   - Describe steps to reproduce the problem

### Related Documentation

- [BUILD_GUIDE_S21_PLUS.md](../docs/BUILD_GUIDE_S21_PLUS.md) - Complete S21+ KernelSU guide
- [S21_PLUS_GUIDE_SUMMARY.md](../S21_PLUS_GUIDE_SUMMARY.md) - Quick reference
- [QUICKSTART.md](../QUICKSTART.md) - Fast-track installation guide
- [KernelSU Official Docs](https://kernelsu.org/guide/module.html) - Module development

## Frequently Asked Questions

### Q: Is Meta-Hybrid required for KernelSU?
**A**: No, KernelSU works without it. Meta-Hybrid is an optional metamodule that provides advanced mounting features.

### Q: Can I use Meta-Hybrid with other metamodules?
**A**: No, only ONE metamodule can be active at a time. You must choose one.

### Q: Will this void my S21+ warranty?
**A**: Warranty was voided when you unlocked the bootloader. This doesn't make it worse.

### Q: Can I uninstall it later?
**A**: Yes, see the Uninstallation section above. Your device will return to standard KernelSU module mounting.

### Q: Does it work with Magisk?
**A**: Meta-Hybrid is designed for KernelSU but has a compatibility mode. However, it's optimized for KernelSU.

### Q: Will it survive OTA updates?
**A**: No, you'll need to reinstall KernelSU after OTA. Meta-Hybrid can then be reinstalled from Manager.

### Q: Can I resize modules.img later?
**A**: Yes, see "Expanding modules.img" in the Advanced Usage section.

### Q: What if I want to switch back to regular mounting?
**A**: Simply uninstall Meta-Hybrid. KernelSU will automatically revert to its default mounting method.

## Version Information

- **Module Version**: v2.0.25
- **Version Code**: 119
- **Release Date**: January 10, 2026
- **Compatible KernelSU**: v0.7.0+
- **Tested On**: Samsung Galaxy S21+ (SM-G996B/DS, SM-G996U/U1)
- **Android Versions**: 11, 12, 13, 14
- **Architecture**: arm64-v8a (primary), x86_64, riscv64

## Credits and License

**Meta-Hybrid Module**:
- Developed by: Hybrid Mount Developers
- GitHub: [YuzakiKokuban/meta-hybrid_mount](https://github.com/YuzakiKokuban/meta-hybrid_mount)
- License: Check repository for licensing terms

**This Guide**:
- Created for: KernelSU S21+ Integration
- Last Updated: January 11, 2026
- Maintained by: KernelSU Documentation Team

## Changelog

### v2.0.25 (2026-01-10)
- Current version included in this repository
- Multi-architecture support (arm64-v8a, x86_64, riscv64)
- Web UI for module management
- KernelSU metamodule integration
- 2GB modules.img with ext4 (no journal)
- Improved partition handling

---

**Need More Help?**

- 📖 Check [BUILD_GUIDE_S21_PLUS.md](../docs/BUILD_GUIDE_S21_PLUS.md) for KernelSU installation
- 💬 Join [KernelSU Telegram](https://t.me/KernelSU) for community support
- 🐛 Report issues on [GitHub](https://github.com/tiann/KernelSU/issues)
- 📱 Visit [XDA Forums](https://forum.xda-developers.com/f/samsung-galaxy-s21-s21-s21-ultra.12089/) for S21+ specific discussions

**Remember**: Always backup your data before making system modifications!
