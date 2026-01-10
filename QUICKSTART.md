# KernelSU Quick Start Guide

Get KernelSU running on your Android device in minutes.

## 🔍 Device Check Helper (Optional)

Before starting, you can use our helper script to check your device compatibility:

```bash
# Connect your device with USB debugging enabled
./scripts/check_device.sh
```

This will:
- Detect your device model and kernel version
- Check if your bootloader is unlocked
- Recommend the best installation method
- Provide device-specific guide links

## 🚀 Quick Install (For Supported Devices)

### Step 1: Check Compatibility
1. Download and install [KernelSU Manager APK](https://github.com/tiann/KernelSU/releases)
2. Open the app:
   - **"Not installed"** = Your device is supported! Continue below.
   - **"Unsupported"** = You need to build a custom kernel (see device-specific guides)

### Step 2: Install KernelSU

#### Option A: Using Manager (Easiest)
1. Open KernelSU Manager
2. Tap the install button (top right)
3. Choose "Direct install" (if you have temporary root) or "Select a file"
4. Follow on-screen instructions
5. Reboot

#### Option B: Using Pre-built Boot Images
1. Check your kernel version:
   ```bash
   adb shell uname -r
   # Example: 5.10.43-android12-9-00001-g1234567890ab
   # Your KMI is: android12-5.10
   ```

2. Download matching boot image from [Releases](https://github.com/tiann/KernelSU/releases)
   - Most devices use `lz4` compression
   - Xiaomi devices typically use `gz` or `uncompressed`

3. Flash via fastboot:
   ```bash
   adb reboot bootloader
   fastboot boot boot-android12-5.10-lz4.img  # Test first
   # If it works:
   fastboot flash boot boot-android12-5.10-lz4.img
   fastboot reboot
   ```

## 📱 Device-Specific Guides

For detailed instructions for your specific device:

- **[Samsung Galaxy S21+](docs/BUILD_GUIDE_S21_PLUS.md)** - Complete guide for S21+ (all variants)
- More device guides coming soon...

## 📚 Full Documentation

- [Complete Installation Guide](https://kernelsu.org/guide/installation.html)
- [How to Build](https://kernelsu.org/guide/how-to-build.html)
- [Non-GKI Integration](https://kernelsu.org/guide/how-to-integrate-for-non-gki.html)
- [FAQ](https://kernelsu.org/guide/faq.html)

## ⚠️ Important Notes

1. **Backup First**: Always backup your data and stock boot.img
2. **Bootloader**: Must be unlocked (this wipes data)
3. **Knox/SafetyNet**: Will be tripped/broken by unlocking bootloader
4. **Warranty**: Rooting typically voids warranty

## 🆘 Need Help?

- **Telegram**: [@KernelSU](https://t.me/KernelSU)
- **Issues**: [GitHub Issues](https://github.com/tiann/KernelSU/issues)
- **Docs**: [Official Website](https://kernelsu.org/)

## 🔧 Common Issues

### Bootloop after flashing?
- Flash back to stock boot.img using fastboot
- Try a different compression format (gz instead of lz4)
- Check KMI version matches your device

### Manager shows "Unsupported"?
- Your device needs a custom kernel build
- Check [Unofficially Supported Devices](https://kernelsu.org/guide/unofficially-support-devices.html)
- See device-specific guides above

### Root not working?
- Open Manager and grant root to your app
- Check App Profile settings
- Run `adb shell su -c "echo test"` to verify

---

**Quick Command Reference:**

```bash
# Check device info
adb shell uname -r                          # Kernel version
adb shell getprop ro.product.model          # Device model
adb shell getprop ro.build.version.release  # Android version

# Install/Flash
adb reboot bootloader                       # Reboot to fastboot
fastboot boot boot.img                      # Test boot (temporary)
fastboot flash boot boot.img                # Flash permanently
fastboot reboot                             # Reboot device

# Verify root
adb shell su -v                             # Check KernelSU version
```

For detailed guides, see the [docs](docs/) folder or visit [kernelsu.org](https://kernelsu.org).
