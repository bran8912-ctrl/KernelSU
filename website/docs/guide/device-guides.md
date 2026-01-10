# Device-Specific Build Guides

This section contains detailed build and installation guides for specific Android devices.

## Why Device-Specific Guides?

While KernelSU provides general installation instructions, some devices require specific steps, considerations, or workarounds. These guides help you successfully install KernelSU on your specific device.

## Available Guides

### Samsung Devices

#### [Samsung Galaxy S21+ (All Variants)](build-s21-plus.md)
**Models**: SM-G996B/DS (Exynos), SM-G996U/U1 (Snapdragon)  
**Status**: Full guide available  
**Covers**: LKM mode, GKI mode, custom kernel building for both Exynos and Snapdragon variants

---

## Don't See Your Device?

If your device isn't listed here:

1. **Check Official Support**: Install [KernelSU Manager](https://github.com/tiann/KernelSU/releases) to see if your device is officially supported
   - "Not installed" = Supported, follow [general installation guide](installation.md)
   - "Unsupported" = Needs custom kernel build

2. **Check Unofficially Supported Devices**: See the [unofficially supported devices list](unofficially-support-devices.md) for community-maintained kernels

3. **General Guides**:
   - [Installation Guide](installation.md) - For GKI devices
   - [How to Build](how-to-build.md) - For GKI kernel building
   - [Non-GKI Integration](how-to-integrate-for-non-gki.md) - For older/custom kernels

4. **Get Help**:
   - Search [XDA Forums](https://forum.xda-developers.com/) for your device + "KernelSU"
   - Ask in [KernelSU Telegram](https://t.me/KernelSU)
   - Check [GitHub Issues](https://github.com/tiann/KernelSU/issues)

## Contributing Device Guides

Have you successfully installed KernelSU on a device not listed here? Consider contributing a guide!

### What to Include

A good device guide should include:
- Device specifications (model numbers, chipset, Android version)
- Compatibility check steps
- Step-by-step installation instructions
- Device-specific quirks or requirements
- Troubleshooting section
- Links to resources (kernel source, stock firmware, etc.)

### How to Contribute

1. Fork the repository
2. Create your guide in `website/docs/guide/build-[device-name].md`
3. Follow the template of existing device guides
4. Add your guide to this index page
5. Submit a pull request

## Template

Use the [Samsung Galaxy S21+ guide](build-s21-plus.md) as a template for creating new device guides.

## Common Device Categories

### GKI Devices (Android 12+)
Most Pixel, OnePlus, and modern devices with GKI 2.0 support. Generally work with pre-built images.

### Samsung Devices  
May require specific kernels due to Knox and security features. Often need custom builds.

### Xiaomi Devices
Usually GKI compatible, but may need specific boot image compression formats.

### OnePlus Devices
Often GKI compatible. May need specific steps for bootloader unlocking.

### OPPO/Realme Devices
Bootloader unlocking may be difficult. Check device-specific forums.

### Custom ROM Devices
If running LineageOS, PixelExperience, etc., usually easier to install KernelSU.

---

**Note**: These guides are community-maintained. Always backup your data before attempting any modifications to your device.
