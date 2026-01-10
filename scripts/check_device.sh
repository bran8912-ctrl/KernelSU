#!/bin/bash
# KernelSU Device Check and Setup Helper
# This script helps you determine the best installation method for your device

set -e

BOLD='\033[1m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BOLD}KernelSU Device Check and Setup Helper${NC}"
echo "========================================"
echo ""

# Check if adb is available
if ! command -v adb &> /dev/null; then
    echo -e "${RED}ERROR: ADB is not installed or not in PATH${NC}"
    echo "Please install Android SDK Platform Tools:"
    echo "  - Linux: sudo apt install adb fastboot"
    echo "  - macOS: brew install android-platform-tools"
    echo "  - Windows: Download from https://developer.android.com/studio/releases/platform-tools"
    exit 1
fi

# Check if device is connected
echo -e "${BLUE}Checking for connected devices...${NC}"
if ! adb devices | grep -q "device$"; then
    echo -e "${RED}No device found!${NC}"
    echo "Please:"
    echo "  1. Connect your device via USB"
    echo "  2. Enable USB debugging in Developer Options"
    echo "  3. Accept the USB debugging prompt on your device"
    exit 1
fi

echo -e "${GREEN}Device connected!${NC}"
echo ""

# Get device information
echo -e "${BLUE}Gathering device information...${NC}"
echo ""

DEVICE_MODEL=$(adb shell getprop ro.product.model 2>/dev/null | tr -d '\r')
DEVICE_BRAND=$(adb shell getprop ro.product.brand 2>/dev/null | tr -d '\r')
DEVICE_NAME=$(adb shell getprop ro.product.name 2>/dev/null | tr -d '\r')
ANDROID_VERSION=$(adb shell getprop ro.build.version.release 2>/dev/null | tr -d '\r')
KERNEL_VERSION=$(adb shell uname -r 2>/dev/null | tr -d '\r')
SDK_VERSION=$(adb shell getprop ro.build.version.sdk 2>/dev/null | tr -d '\r')

echo -e "${BOLD}Device Information:${NC}"
echo "  Brand: $DEVICE_BRAND"
echo "  Model: $DEVICE_MODEL"
echo "  Name: $DEVICE_NAME"
echo "  Android: $ANDROID_VERSION (SDK $SDK_VERSION)"
echo "  Kernel: $KERNEL_VERSION"
echo ""

# Extract KMI information
if [[ $KERNEL_VERSION =~ ([0-9]+\.[0-9]+)\.[0-9]+-android([0-9]+)-([0-9]+) ]]; then
    KERNEL_BASE="${BASH_REMATCH[1]}"
    ANDROID_VER="${BASH_REMATCH[2]}"
    KMI_GEN="${BASH_REMATCH[3]}"
    KMI="android${ANDROID_VER}-${KERNEL_BASE}"
    echo -e "${GREEN}KMI detected: $KMI${NC}"
    echo ""
    GKI_COMPATIBLE=true
else
    echo -e "${YELLOW}Could not detect standard KMI format${NC}"
    echo "This might be a non-GKI device or custom kernel"
    echo ""
    GKI_COMPATIBLE=false
fi

# Check bootloader status
echo -e "${BLUE}Checking bootloader status...${NC}"
BOOTLOADER_STATUS=$(adb shell getprop ro.boot.flash.locked 2>/dev/null | tr -d '\r')
if [ "$BOOTLOADER_STATUS" == "0" ]; then
    echo -e "${GREEN}Bootloader: UNLOCKED${NC}"
    BOOTLOADER_UNLOCKED=true
elif [ "$BOOTLOADER_STATUS" == "1" ]; then
    echo -e "${RED}Bootloader: LOCKED${NC}"
    BOOTLOADER_UNLOCKED=false
else
    echo -e "${YELLOW}Bootloader status: UNKNOWN${NC}"
    BOOTLOADER_UNLOCKED=unknown
fi
echo ""

# Provide recommendations
echo -e "${BOLD}Recommendations:${NC}"
echo ""

if [ "$BOOTLOADER_UNLOCKED" != "true" ]; then
    echo -e "${RED}⚠ BOOTLOADER LOCKED${NC}"
    echo "You must unlock your bootloader first!"
    echo ""
    echo "Steps to unlock:"
    echo "  1. Backup ALL data (unlocking wipes device)"
    echo "  2. Enable 'OEM unlocking' in Developer Options"
    echo "  3. Boot to bootloader/fastboot mode"
    echo "  4. Run: fastboot flashing unlock"
    echo ""
    echo -e "${YELLOW}WARNING: This will void warranty and trip Knox/SafetyNet!${NC}"
    echo ""
fi

# Device-specific recommendations
case "$DEVICE_MODEL" in
    "SM-G996"*|*"S21+"*|*"S21 Plus"*)
        echo -e "${GREEN}Samsung Galaxy S21+ Detected!${NC}"
        echo ""
        echo "A detailed guide is available for your device:"
        echo "  docs/BUILD_GUIDE_S21_PLUS.md"
        echo ""
        echo "Quick links:"
        echo "  - View guide: https://github.com/tiann/KernelSU/blob/main/docs/BUILD_GUIDE_S21_PLUS.md"
        echo "  - Download Manager: https://github.com/tiann/KernelSU/releases"
        echo ""
        ;;
    "Pixel "*|"SM-G99"*|"SM-G98"*|"2201"*|"2203"*|"2206"*)
        echo -e "${GREEN}Modern device detected - likely GKI compatible!${NC}"
        echo ""
        ;;
    *)
        echo -e "${YELLOW}Device not specifically recognized${NC}"
        ;;
esac

if [ "$GKI_COMPATIBLE" = true ]; then
    echo -e "${BOLD}Installation Method: GKI Mode (Recommended)${NC}"
    echo ""
    echo "Your device appears to support GKI. Follow these steps:"
    echo ""
    echo "1. Download KernelSU Manager from:"
    echo "   https://github.com/tiann/KernelSU/releases"
    echo ""
    echo "2. Install and open the Manager to verify compatibility"
    echo ""
    echo "3. If supported, download boot image for KMI: ${KMI}"
    echo "   Look for: boot-${KMI}-lz4.img.gz (try lz4 first)"
    echo ""
    echo "4. Flash using fastboot:"
    echo "   adb reboot bootloader"
    echo "   fastboot boot boot.img  # Test first"
    echo "   fastboot flash boot boot.img  # Flash permanently"
    echo "   fastboot reboot"
    echo ""
    echo "See full guide: https://kernelsu.org/guide/installation.html"
else
    echo -e "${BOLD}Installation Method: Custom Kernel Build${NC}"
    echo ""
    echo "Your device appears to need a custom kernel build."
    echo ""
    echo "Steps:"
    echo "1. Find your device's kernel source code"
    echo "2. Follow the non-GKI integration guide"
    echo "3. Build kernel with KernelSU v0.9.5 (last non-GKI version)"
    echo ""
    echo "Guides:"
    echo "  - Non-GKI: https://kernelsu.org/guide/how-to-integrate-for-non-gki.html"
    echo "  - Check device-specific guides in docs/ folder"
fi

echo ""
echo -e "${BOLD}Additional Resources:${NC}"
echo "  - Official docs: https://kernelsu.org/"
echo "  - Quick start: QUICKSTART.md"
echo "  - Telegram: https://t.me/KernelSU"
echo "  - Issues: https://github.com/tiann/KernelSU/issues"
echo ""

# Save device info to file
INFO_FILE="device_info_$(date +%Y%m%d_%H%M%S).txt"
cat > "$INFO_FILE" << EOF
KernelSU Device Information
Generated: $(date)

Brand: $DEVICE_BRAND
Model: $DEVICE_MODEL
Name: $DEVICE_NAME
Android: $ANDROID_VERSION (SDK $SDK_VERSION)
Kernel: $KERNEL_VERSION
EOF

if [ "$GKI_COMPATIBLE" = true ]; then
    echo "KMI: $KMI" >> "$INFO_FILE"
fi

echo "Bootloader: $BOOTLOADER_STATUS" >> "$INFO_FILE"

echo -e "${GREEN}Device info saved to: $INFO_FILE${NC}"
echo ""
echo "Include this file when asking for help in forums or issue tracker."
