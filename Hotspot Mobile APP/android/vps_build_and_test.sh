#!/bin/bash

# Android App Build and Test Script for VPS
# This script builds the APK and provides testing instructions

echo "🚀 Android App Build and Test Script"
echo "===================================="

# Set working directory
cd /root/hotspot-manager/"Hotspot Mobile APP"/android || {
    echo "❌ Error: Cannot find Android project directory"
    echo "Please ensure you're in the correct directory"
    exit 1
}

echo "📍 Current directory: $(pwd)"

# Check if gradlew exists
if [ ! -f "gradlew" ]; then
    echo "❌ Error: gradlew not found"
    echo "Please run the project setup scripts first"
    exit 1
fi

# Make gradlew executable
chmod +x gradlew

echo "🧹 Cleaning previous build..."
./gradlew clean

echo "🔨 Building debug APK..."
./gradlew assembleDebug

BUILD_EXIT_CODE=$?

echo ""
echo "📋 Build Result:"
echo "================"

if [ $BUILD_EXIT_CODE -eq 0 ]; then
    echo "✅ BUILD SUCCESSFUL!"
    
    # Check if APK was created
    APK_PATH="app/build/outputs/apk/debug/app-debug.apk"
    if [ -f "$APK_PATH" ]; then
        echo "📱 APK Location: $APK_PATH"
        echo "📊 APK Size: $(ls -lh "$APK_PATH" | awk '{print $5}')"
        echo "🕐 Build Time: $(date)"
        
        echo ""
        echo "🎯 TESTING YOUR APP:"
        echo "==================="
        echo "1. Download APK to your Windows machine:"
        echo "   scp root@your-vps-ip:~/hotspot-manager/\"Hotspot Mobile APP\"/android/app/build/outputs/apk/debug/app-debug.apk ."
        echo ""
        echo "2. Install on Android device:"
        echo "   - Enable Developer Options (Settings → About → Tap Build Number 7 times)"
        echo "   - Enable USB Debugging (Settings → Developer Options)"
        echo "   - Transfer APK to device and install via file manager"
        echo "   - Or use ADB: adb install app-debug.apk"
        echo ""
        echo "3. Test basic functionality:"
        echo "   - App launches without crashes"
        echo "   - Navigation drawer works"
        echo "   - Menu items respond"
        echo "   - Basic UI elements display correctly"
        echo ""
        echo "4. Advanced testing:"
        echo "   - Test with/without internet connection"
        echo "   - Try different screen orientations"
        echo "   - Test on different Android versions"
        echo ""
        echo "🔧 Debug tools:"
        echo "   - View logs: adb logcat | grep HotspotManager"
        echo "   - Check performance: adb shell top | grep hotspot"
        echo ""
        echo "📚 For detailed testing guide, see: ANDROID_TESTING_GUIDE.md"
        
    else
        echo "⚠️ APK not found at expected location"
        echo "Searching for APK files..."
        find . -name "*.apk" -type f 2>/dev/null || echo "No APK files found"
    fi
else
    echo "❌ BUILD FAILED (Exit code: $BUILD_EXIT_CODE)"
    echo ""
    echo "🔍 Common solutions:"
    echo "- Check if Java 17 is installed: java -version"
    echo "- Verify Android SDK: \$ANDROID_HOME/platform-tools/adb version"
    echo "- Pull latest changes: git pull origin main"
    echo "- Try project structure fix: ./vps_complete_structure_fix.sh"
fi

echo ""
echo "🎉 Build script completed at: $(date)"
echo "Exit code: $BUILD_EXIT_CODE"

exit $BUILD_EXIT_CODE
