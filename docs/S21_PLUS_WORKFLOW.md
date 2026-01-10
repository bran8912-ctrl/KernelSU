# �� Complete Workflow for S21+ Users

## Your Device: Samsung Galaxy S21+

Follow this step-by-step workflow to successfully install KernelSU on your Samsung Galaxy S21+.

## Phase 1: Preparation (30 minutes)

### Step 1: Install Required Tools
```bash
# On Ubuntu/Debian
sudo apt update
sudo apt install adb fastboot

# On macOS
brew install android-platform-tools

# On Windows
# Download from https://developer.android.com/studio/releases/platform-tools
# Extract and add to PATH
```

### Step 2: Backup Everything
- [ ] Backup all photos, videos, documents
- [ ] Backup app data (Google Backup, Samsung Cloud)
- [ ] Note down all installed apps
- [ ] Save all important files to PC/cloud

### Step 3: Download Stock Firmware
- Go to https://www.sammobile.com/samsung/galaxy-s21-plus-5g/
- Find your exact model (SM-G996B or SM-G996U)
- Download latest firmware
- Keep it safe for emergency recovery

## Phase 2: Device Check (5 minutes)

### Step 1: Enable USB Debugging
```
Settings → About Phone → Software Information
Tap "Build Number" 7 times
Back → Developer Options → Enable USB Debugging
```

### Step 2: Run Device Checker
```bash
cd KernelSU
./scripts/check_device.sh
```

**Read the output carefully!** It will tell you:
- Your device model
- Kernel version
- If bootloader is unlocked
- Which installation method to use

## Phase 3: Unlock Bootloader (15 minutes)

⚠️ **WARNING: This WIPES all data!**

### Step 1: Enable OEM Unlock
```
Settings → Developer Options → Enable "OEM Unlocking"
```

### Step 2: Reboot to Download Mode
```bash
# Power off device completely
# Hold Volume Up + Volume Down
# While holding, plug in USB cable
# Screen shows warning - this is normal
```

### Step 3: Unlock
```
Long press Volume Up button
Wait for device to wipe and reboot
```

### Step 4: Re-enable USB Debugging
```
Go through setup (skip Google account for now)
Enable USB debugging again (same as before)
```

## Phase 4: Install KernelSU (20 minutes)

### Check Your Path

Run the device checker again:
```bash
./scripts/check_device.sh
```

### Path A: GKI Compatible Device

If checker says "GKI compatible":

1. **Download Manager APK**
   - https://github.com/tiann/KernelSU/releases
   - Install: `adb install KernelSU_*.apk`

2. **Verify in Manager**
   - Open app
   - Should say "Not installed"

3. **Download Boot Image**
   - Note your KMI (e.g., android12-5.10)
   - Download: `boot-android12-5.10-lz4.img.gz`
   - Extract: `gunzip boot-*.img.gz`

4. **Flash Boot Image**
   ```bash
   adb reboot bootloader
   
   # Test first (safer)
   fastboot boot boot-android12-5.10-lz4.img
   
   # If it boots successfully:
   adb reboot bootloader
   fastboot flash boot boot-android12-5.10-lz4.img
   fastboot reboot
   ```

### Path B: Custom Kernel Needed

If checker says "Custom kernel needed":

1. **Read the Full Guide**
   - Open: `docs/BUILD_GUIDE_S21_PLUS.md`
   - Section: "Method B: Building Custom Kernel"

2. **Get Kernel Source**
   - Samsung Open Source: https://opensource.samsung.com/
   - Search for your exact model + build number

3. **Follow Build Instructions**
   - Install build tools
   - Integrate KernelSU v0.9.5
   - Compile kernel
   - Create boot image
   - Flash

## Phase 5: Verification (5 minutes)

### Step 1: Check Root
```bash
adb shell su -v
# Should show KernelSU version
```

### Step 2: Open Manager
- Open KernelSU Manager app
- Should show "Working" or "Installed"
- Check version number

### Step 3: Test Root
- Grant root to a test app (e.g., Terminal)
- Run `su` command
- Should get root shell (#)

## Phase 6: Post-Installation (10 minutes)

### Install Metamodule (Optional)
If you need system modification support:
1. Download meta-overlayfs from releases
2. Install via Manager → Modules
3. Reboot

### Configure App Profiles
1. Open Manager
2. Go to each app you want to root
3. Grant root permission
4. Configure profile (optional)

### Hide Manager (Optional)
For SafetyNet/banking apps:
1. Manager → Settings
2. Hide Manager option
3. Follow instructions

## Troubleshooting

### Bootloop after flashing?
```bash
# Reboot to download mode (Volume Up + Down + USB)
# Or fastboot mode
adb reboot bootloader
fastboot flash boot stock_boot.img
fastboot reboot
```

### Root not working?
```bash
# Check logs
adb shell dmesg | grep -i ksu

# Check ksud process
adb shell ps -A | grep ksud
```

### Need more help?
1. Read troubleshooting section in docs/BUILD_GUIDE_S21_PLUS.md
2. Search https://github.com/tiann/KernelSU/issues
3. Ask in https://t.me/KernelSU

## Time Estimates

- **Total time**: 1-2 hours for GKI path
- **Total time**: 3-5 hours for custom kernel path
- **Experience needed**: 
  - GKI: Beginner (just follow commands)
  - Custom kernel: Advanced (need Linux knowledge)

## Success Checklist

- [x] Device backed up
- [x] Stock firmware downloaded
- [x] Bootloader unlocked
- [x] KernelSU installed
- [x] Root working
- [x] Manager shows "Working"
- [x] Test app has root access

## What's Next?

- Install Magisk modules (compatible ones)
- Configure app profiles for security
- Install metamodule if needed
- Hide root from banking apps
- Enjoy your rooted S21+! 🎉

## Important Reminders

1. **Knox is tripped** - Can't undo
2. **SafetyNet broken** - Use hiding methods
3. **Warranty voided** - In most regions
4. **OTA updates** - Won't work normally
5. **Keep stock firmware** - For emergencies

---

For detailed explanations of each step, see:
- QUICKSTART.md (quick reference)
- docs/BUILD_GUIDE_S21_PLUS.md (complete guide)
- S21_PLUS_GUIDE_SUMMARY.md (overview)
