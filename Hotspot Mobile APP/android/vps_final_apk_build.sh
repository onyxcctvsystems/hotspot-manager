#!/bin/bash

# VPS Final APK Build Script
# This script fixes the last remaining Kotlin compilation errors and builds the APK

echo "=== VPS Final APK Build Script ==="
echo "Starting final fixes and APK build..."

# Set correct working directory
cd /root/hotspot-manager/android || {
    echo "Error: Cannot access /root/hotspot-manager/android"
    exit 1
}

echo "=== Current Directory ==="
pwd

echo "=== Checking MainActivity.kt ==="
MAIN_ACTIVITY_PATH="app/src/main/java/com/onyx/hotspotmanager/ui/activity/MainActivity.kt"

if [ ! -f "$MAIN_ACTIVITY_PATH" ]; then
    echo "Error: MainActivity.kt not found at $MAIN_ACTIVITY_PATH"
    echo "Searching for MainActivity.kt..."
    find . -name "MainActivity.kt" -type f
    exit 1
fi

echo "=== Fixing MainActivity.kt references ==="
# Fix any remaining binding references
sed -i 's/binding\.toolbar/findViewById(R.id.toolbar)/g' "$MAIN_ACTIVITY_PATH"
sed -i 's/binding\.appBarMain/findViewById(R.id.toolbar)/g' "$MAIN_ACTIVITY_PATH"

echo "=== Verifying Layout Resources ==="
# Check if required layout files exist
REQUIRED_LAYOUTS=(
    "app/src/main/res/layout/activity_main.xml"
    "app/src/main/res/layout/app_bar_main.xml"
    "app/src/main/res/layout/content_main.xml"
    "app/src/main/res/layout/nav_header_main.xml"
    "app/src/main/res/layout/fragment_dashboard.xml"
)

for layout in "${REQUIRED_LAYOUTS[@]}"; do
    if [ ! -f "$layout" ]; then
        echo "Warning: $layout not found"
    else
        echo "✓ $layout exists"
    fi
done

echo "=== Verifying Resource Files ==="
# Check if required resource files exist
REQUIRED_RESOURCES=(
    "app/src/main/res/values/strings.xml"
    "app/src/main/res/values/colors.xml"
    "app/src/main/res/values/themes.xml"
    "app/src/main/res/values/dimens.xml"
    "app/src/main/res/menu/activity_main_drawer.xml"
    "app/src/main/res/navigation/mobile_navigation.xml"
)

for resource in "${REQUIRED_RESOURCES[@]}"; do
    if [ ! -f "$resource" ]; then
        echo "Warning: $resource not found"
    else
        echo "✓ $resource exists"
    fi
done

echo "=== Cleaning Build Cache ==="
./gradlew clean

echo "=== Running Gradle Build ==="
./gradlew assembleDebug --stacktrace --info

BUILD_EXIT_CODE=$?

echo "=== Build Result ==="
if [ $BUILD_EXIT_CODE -eq 0 ]; then
    echo "✓ Build SUCCESS!"
    
    # Check if APK was generated
    APK_PATH="app/build/outputs/apk/debug/app-debug.apk"
    if [ -f "$APK_PATH" ]; then
        echo "✓ APK generated successfully at: $APK_PATH"
        ls -la "$APK_PATH"
    else
        echo "Warning: APK not found at expected location"
        echo "Searching for APK files..."
        find . -name "*.apk" -type f
    fi
else
    echo "✗ Build FAILED with exit code: $BUILD_EXIT_CODE"
    echo "Please check the error messages above"
fi

echo "=== Final Status ==="
echo "Build completed at: $(date)"
echo "Exit code: $BUILD_EXIT_CODE"

exit $BUILD_EXIT_CODE
