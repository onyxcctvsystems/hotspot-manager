# 🚀 VPS Quick Fix Commands
# Copy and paste these commands on your VPS to fix the data binding issue

# 1. Navigate to your project directory
cd /root/hotspot-manager

# 2. Pull the latest changes (includes the data binding fix)
git pull origin main

# 3. Navigate to Android project
cd "Hotspot Mobile APP/android"

# 4. Verify data binding is enabled
grep -A 3 -B 3 "dataBinding" app/build.gradle

# 5. Clean and rebuild
./gradlew clean
./gradlew build

# 6. Generate APK
./gradlew assembleDebug

# 7. Check APK location
ls -la app/build/outputs/apk/debug/

# 🎯 Alternative: Use the automated build script
# chmod +x ../vps_build.sh
# ../vps_build.sh

# 📋 Expected output after successful build:
# ✅ BUILD SUCCESSFUL
# ✅ APK generated at: app/build/outputs/apk/debug/app-debug.apk
