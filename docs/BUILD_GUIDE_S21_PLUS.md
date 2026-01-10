# Building KernelSU for Samsung Galaxy S21+ 

This guide will help you build and install KernelSU on your Samsung Galaxy S21+ device.

## Table of Contents
1. [Device Information](#device-information)
2. [Prerequisites](#prerequisites)
3. [Step 1: Check Device Compatibility](#step-1-check-device-compatibility)
4. [Step 2: Installation Methods](#step-2-installation-methods)
5. [Method A: Using Pre-built Images (Recommended)](#method-a-using-pre-built-images-recommended)
6. [Method B: Building Custom Kernel (Advanced)](#method-b-building-custom-kernel-advanced)
7. [Post-Installation](#post-installation)
8. [Troubleshooting](#troubleshooting)

## Device Information

**Samsung Galaxy S21+** comes in two variants:
- **SM-G996B/DS** (Exynos 2100) - International
- **SM-G996U/U1** (Snapdragon 888) - US/China

**Key Specifications:**
- Android version: 11, 12, 13, 14 (depends on your update)
- Kernel version: Typically 5.4 or 5.10 (check with `uname -r`)
- Architecture: arm64-v8a

## Prerequisites

### Required Tools
1. **ADB and Fastboot** installed on your PC
   - Download: [Android SDK Platform Tools](https://developer.android.com/studio/releases/platform-tools)
   - Or install via package manager:
     - Ubuntu/Debian: `sudo apt install adb fastboot`
     - macOS: `brew install android-platform-tools`
     - Windows: Download from link above

2. **USB Drivers** (Windows only)
   - Samsung USB drivers: Download from Samsung's website

3. **Unlocked Bootloader**
   - **WARNING**: Unlocking bootloader will WIPE ALL DATA
   - Go to Settings → About Phone → Tap "Build Number" 7 times
   - Go to Settings → Developer Options → Enable "OEM Unlocking"
   - Reboot to Download Mode: Power off, then hold Volume Up + Volume Down while plugging USB
   - Long press Volume Up to unlock bootloader

### Backup Your Data
- **CRITICAL**: Backup all important data before proceeding
- Backup your stock `boot.img` or full firmware using Samsung Odin
- Download stock firmware from [Sammobile](https://www.sammobile.com/) or [Frija](https://forum.xda-developers.com/t/tool-frija-samsung-firmware-downloader-checker.3910594/)

## Step 1: Check Device Compatibility

1. **Install KernelSU Manager** to check compatibility:
   ```bash
   # Download latest manager APK from GitHub releases
   # https://github.com/tiann/KernelSU/releases
   
   # Install the APK
   adb install KernelSU_*.apk
   ```

2. **Open the Manager app** and check the status:
   - **"Not installed"** - Your device supports GKI mode (proceed to Method A)
   - **"Unsupported"** - Your device needs custom kernel (proceed to Method B)

3. **Check your kernel version**:
   ```bash
   adb shell uname -r
   # Example output: 5.10.43-android12-9-00001-g1234567890ab
   ```

## Step 2: Installation Methods

Based on your device check, choose the appropriate method:

## Method A: Using Pre-built Images (Recommended)

This method works if the Manager shows "Not installed" (GKI compatible).

### Option 1: LKM Mode (Recommended for S21+)

LKM (Loadable Kernel Module) mode is the easiest and safest method:

1. **Using Manager (Easiest)**:
   - If you have temporary root or want to upgrade, open KernelSU Manager
   - Click the install icon (top right)
   - Choose "Select a file" and select your `boot.img` (or `init_boot.img` for Android 13+)
   - Manager will patch and provide a file to flash
   - Flash using Odin or `adb sideload`

2. **Using ksud Command Line**:
   ```bash
   # Download ksud from releases
   # https://github.com/tiann/KernelSU/releases
   
   # Extract boot.img from your firmware
   # For Android 13+: extract init_boot.img instead
   
   # Patch the image
   ./ksud boot-patch -b boot.img --kmi android12-5.10
   
   # Flash the patched image
   adb reboot bootloader
   fastboot flash boot kernelsu_boot.img
   fastboot reboot
   ```

### Option 2: GKI Mode

1. **Download the correct boot image**:
   - Go to [KernelSU Releases](https://github.com/tiann/KernelSU/releases)
   - Find your kernel version (e.g., `android12-5.10`)
   - Download the boot image matching your compression format:
     - `boot-<version>-lz4.img.gz` (most common for Samsung)
     - `boot-<version>-gz.img.gz`
     - Try `lz4` first, if bootloop occurs, try `gz`

2. **Extract and flash**:
   ```bash
   # Extract the downloaded file
   gunzip boot-android12-5.10-lz4.img.gz
   
   # Reboot to download mode
   adb reboot bootloader
   
   # Try booting first (safer - no permanent change)
   fastboot boot boot-android12-5.10-lz4.img
   
   # If it boots successfully, flash permanently
   adb reboot bootloader
   fastboot flash boot boot-android12-5.10-lz4.img
   fastboot reboot
   ```

## Method B: Building Custom Kernel (Advanced)

If your device shows "Unsupported", you need to build a custom kernel.

### Prerequisites for Building
- Linux environment (Ubuntu 20.04+ recommended) or WSL2
- 16GB+ RAM (or enable swap)
- 100GB+ free disk space
- Build tools:
  ```bash
  sudo apt update
  sudo apt install -y bc bison build-essential ccache curl \
    flex g++-multilib gcc-multilib git gnupg gperf imagemagick \
    lib32ncurses5-dev lib32readline-dev lib32z1-dev liblz4-tool \
    libncurses5 libncurses5-dev libsdl1.2-dev libssl-dev \
    libxml2 libxml2-utils lzop pngcrush rsync schedtool \
    squashfs-tools xsltproc zip zlib1g-dev python3
  ```

### Get Samsung Kernel Source

1. **Find your exact kernel source**:
   - Visit [Samsung Open Source Release Center](https://opensource.samsung.com/)
   - Search for your exact model (e.g., SM-G996B for S21+ Exynos)
   - Download kernel source matching your build number

2. **Extract the kernel source**:
   ```bash
   # Extract the downloaded tar file
   tar -xvf SM-G996B_*.tar.gz
   cd Kernel
   ```

3. **Identify your kernel version**:
   ```bash
   # Check Makefile for version info
   head -n 5 Makefile
   ```

### Integrate KernelSU into Kernel

**IMPORTANT**: Since KernelSU v1.0, non-GKI support was dropped. You must use **v0.9.5** for Samsung devices:

1. **Add KernelSU to kernel source**:
   ```bash
   cd /path/to/kernel/source
   curl -LSs "https://raw.githubusercontent.com/tiann/KernelSU/main/kernel/setup.sh" | bash -s v0.9.5
   ```

2. **Configure kernel for KernelSU**:
   ```bash
   # Find your defconfig
   # Usually in: arch/arm64/configs/vendor/*_defconfig
   # For S21+: likely exynos2100_defconfig or similar
   
   # Edit the defconfig file and add:
   echo "CONFIG_KSU=y" >> arch/arm64/configs/your_defconfig
   
   # Enable KPROBES if not already enabled
   echo "CONFIG_KPROBES=y" >> arch/arm64/configs/your_defconfig
   echo "CONFIG_HAVE_KPROBES=y" >> arch/arm64/configs/your_defconfig
   echo "CONFIG_KPROBE_EVENTS=y" >> arch/arm64/configs/your_defconfig
   ```

3. **Build the kernel**:
   ```bash
   # Set up environment
   export ARCH=arm64
   export SUBARCH=arm64
   
   # For Exynos (if you have the correct toolchain)
   export CROSS_COMPILE=aarch64-linux-gnu-
   # Or download Samsung's toolchain from the source package
   
   # Clean previous builds
   make clean && make mrproper
   
   # Load defconfig
   make your_defconfig
   
   # Build kernel image
   make -j$(nproc)
   
   # The output will be at: arch/arm64/boot/Image or Image.gz
   ```

### Create Flashable Boot Image

1. **Extract your stock boot.img**:
   ```bash
   # Get boot.img from your device or stock firmware
   adb pull /dev/block/by-name/boot stock_boot.img
   # OR extract from AP_*.tar.md5 firmware file
   ```

2. **Install magiskboot**:
   ```bash
   # Download from https://github.com/topjohnwu/Magisk/releases
   wget https://github.com/topjohnwu/Magisk/releases/download/v27.0/Magisk-v27.0.apk
   unzip Magisk-v27.0.apk lib/arm64-v8a/libmagiskboot.so
   mv lib/arm64-v8a/libmagiskboot.so magiskboot
   chmod +x magiskboot
   ```

3. **Repack boot image with new kernel**:
   ```bash
   # Unpack stock boot
   ./magiskboot unpack stock_boot.img
   
   # Replace kernel
   cp /path/to/kernel/arch/arm64/boot/Image ./kernel
   # OR if compressed: 
   # cp /path/to/kernel/arch/arm64/boot/Image.gz ./kernel
   
   # Repack
   ./magiskboot repack stock_boot.img
   
   # Output will be: new-boot.img
   ```

4. **Flash the new boot image**:
   ```bash
   adb reboot bootloader
   fastboot flash boot new-boot.img
   fastboot reboot
   ```

## Post-Installation

### 1. Verify Installation

```bash
# Check if KernelSU is running
adb shell su -v
# Should show KernelSU version

# Check kernel version
adb shell uname -r
# Should show your kernel version

# Open KernelSU Manager app
# Should show "Working" or "Installed"
```

### 2. Install Metamodule (for system modifications)

If you want to use modules that modify `/system`:

1. Download meta-overlayfs from releases
2. Install via Manager → Modules
3. Reboot

See [Metamodule Guide](https://kernelsu.org/guide/metamodule.html) for details.

### 3. Configure Root Access

1. Open KernelSU Manager
2. Grant root to apps you trust
3. Configure App Profiles for security

## Troubleshooting

### Device won't boot (Bootloop)

1. **Immediate recovery**:
   ```bash
   # Boot to download mode (Volume Up + Volume Down + USB)
   # Flash stock boot.img
   fastboot flash boot stock_boot.img
   fastboot reboot
   ```

2. **Common causes**:
   - Wrong compression format (try different boot image format)
   - Kernel version mismatch (verify KMI)
   - Broken kprobe (if custom building, see below)

3. **For custom kernel builders**:
   - If bootloop with KernelSU, test without by commenting out in `kernel/ksu.c`:
     ```c
     // ksu_sucompat_init()
     // ksu_ksud_init()
     ```
   - If boots without these, kprobe might be broken - use manual integration instead

### Manager shows "Unsupported"

- Your device needs custom kernel (Method B)
- Check [Unofficially supported devices](https://kernelsu.org/guide/unofficially-support-devices.html)
- Look for XDA threads for your device

### Root not working

```bash
# Check KernelSU status
adb shell su -c "echo test"

# Check if ksud is running
adb shell ps -A | grep ksud

# Check kernel logs
adb shell dmesg | grep -i ksu
```

### Wrong kernel compression format

If you get bootloop with GKI image:

1. Samsung typically uses `lz4` or `gz`
2. Extract and check original boot.img:
   ```bash
   ./magiskboot unpack stock_boot.img
   # Check output for compression type
   ```
3. Download matching format from KernelSU releases

### SafetyNet / Play Integrity fails

KernelSU may affect SafetyNet. Use:
- Hide KernelSU Manager
- Use modules like Shamiko or similar
- Check [Module guide](https://kernelsu.org/guide/module.html)

## Additional Resources

- **Official Documentation**: https://kernelsu.org/
- **GitHub Releases**: https://github.com/tiann/KernelSU/releases
- **Telegram Support**: https://t.me/KernelSU
- **XDA Forums**: Search for "KernelSU S21" or your specific model

## Important Notes

1. **Knox Counter**: Unlocking bootloader and rooting will trip Samsung Knox permanently. Some Samsung features will stop working (Samsung Pass, Secure Folder, etc.)

2. **OTA Updates**: After rooting, you cannot install OTA updates directly. You must:
   - Flash full stock firmware to update
   - Or use LKM mode with "Install to inactive slot" feature

3. **Warranty**: Rooting voids warranty in most regions

4. **Security**: Root access is powerful - only grant to trusted apps

5. **Backups**: Always keep a backup of:
   - Stock boot.img
   - Full firmware package
   - Important data

## Quick Reference Commands

```bash
# Check device info
adb shell getprop ro.product.model
adb shell getprop ro.build.version.release
adb shell uname -r

# Reboot to different modes
adb reboot bootloader    # Fastboot mode
adb reboot download      # Download mode (Samsung)
adb reboot recovery      # Recovery mode

# Flash boot image
fastboot flash boot boot.img
fastboot boot boot.img   # Temporary boot (safer for testing)

# Check root
adb shell su -v
```

## Support

If you encounter issues:
1. Check this troubleshooting section
2. Search [GitHub Issues](https://github.com/tiann/KernelSU/issues)
3. Ask in [Telegram group](https://t.me/KernelSU)
4. Post in XDA forums with full device info and logs

---

**Last Updated**: January 2026
**KernelSU Version**: Based on latest release
**Target Device**: Samsung Galaxy S21+ (All Variants)
