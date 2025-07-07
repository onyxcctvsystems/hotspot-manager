# 🚀 VPS Quick Commands Reference

## Current Status: "assembleDebug task not found"
This error occurs because you're in the wrong directory on the VPS.

## 📍 Directory Issue Fix

### Step 1: Find Your Location
```bash
pwd
ls -la
```

### Step 2: Navigate to Correct Directory
The correct directory should be:
```bash
cd ~/hotspot-manager/Hotspot\ Mobile\ APP/android
```

Or try these alternatives:
```bash
cd ~/hotspot-manager/android
cd ~/hotspot-project/android
```

### Step 3: Verify You're in the Right Place
```bash
pwd
ls -la
# You should see: gradlew, app/, settings.gradle
```

### Step 4: Test Gradle Tasks
```bash
chmod +x gradlew
./gradlew tasks
```

### Step 5: Build APK
```bash
./gradlew clean
./gradlew assembleDebug
```

## 🔧 Automated Solutions

### Option 1: Run Diagnostic Script
```bash
chmod +x vps_directory_diagnostic.sh
./vps_directory_diagnostic.sh
```

### Option 2: Auto-Build Script
```bash
chmod +x vps_auto_build.sh
./vps_auto_build.sh
```

### Option 3: Manual Recovery
```bash
cd ~
find . -name "gradlew" -type f 2>/dev/null
# Navigate to the directory that contains gradlew
```

## 🆘 If Project is Missing

### Re-clone the repository:
```bash
cd ~
rm -rf hotspot-manager
git clone https://github.com/onyxcctvsystems/hotspot-manager.git
cd hotspot-manager/Hotspot\ Mobile\ APP/android
chmod +x gradlew
./gradlew assembleDebug
```

## ✅ Success Indicators

You'll know you're in the right place when:
- `./gradlew tasks` shows assembleDebug
- `ls -la` shows: gradlew, app/, settings.gradle
- `pwd` shows something like: `/home/user/hotspot-manager/Hotspot Mobile APP/android`

## 📱 APK Location (after successful build)
```bash
find . -name "*.apk" -type f
# Usually in: ./app/build/outputs/apk/debug/app-debug.apk
```
