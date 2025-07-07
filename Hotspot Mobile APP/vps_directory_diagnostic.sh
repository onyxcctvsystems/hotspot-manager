#!/bin/bash

# 🔍 VPS Directory Diagnostic and Fix Script
# This script helps identify and fix directory issues on the VPS

echo "============================================="
echo "🔍 VPS Directory Diagnostic Tool"
echo "============================================="

# Function to check if we're in the right directory
check_android_project() {
    local dir="$1"
    echo "Checking directory: $dir"
    
    if [ -f "$dir/gradlew" ] && [ -f "$dir/app/build.gradle" ] && [ -f "$dir/settings.gradle" ]; then
        echo "✅ Found Android project structure in: $dir"
        return 0
    else
        echo "❌ Not an Android project directory: $dir"
        return 1
    fi
}

# Show current location
echo "📍 Current directory: $(pwd)"
echo "📁 Contents of current directory:"
ls -la

echo ""
echo "🔍 Looking for Android project directories..."

# Check common locations
locations=(
    "."
    "./android"
    "../android"
    "~/hotspot-manager"
    "~/hotspot-manager/android"
    "~/hotspot-manager/Hotspot Mobile APP"
    "~/hotspot-manager/Hotspot Mobile APP/android"
    "~/hotspot-project"
    "~/hotspot-project/android"
)

correct_dir=""

for location in "${locations[@]}"; do
    expanded_location=$(eval echo "$location")
    if [ -d "$expanded_location" ]; then
        echo ""
        echo "🔍 Checking: $expanded_location"
        if check_android_project "$expanded_location"; then
            correct_dir="$expanded_location"
            break
        fi
    fi
done

if [ -n "$correct_dir" ]; then
    echo ""
    echo "🎯 FOUND CORRECT ANDROID PROJECT DIRECTORY:"
    echo "   $correct_dir"
    echo ""
    echo "📋 To navigate to the correct directory, run:"
    echo "   cd \"$correct_dir\""
    echo ""
    echo "🔧 Or run this command to auto-navigate and test:"
    echo "   cd \"$correct_dir\" && pwd && ls -la && ./gradlew tasks | head -20"
else
    echo ""
    echo "❌ Could not find Android project directory!"
    echo ""
    echo "🔍 Let's search more thoroughly..."
    echo "Looking for gradlew files in home directory:"
    find ~ -name "gradlew" -type f 2>/dev/null | head -10
    
    echo ""
    echo "Looking for build.gradle files:"
    find ~ -name "build.gradle" -type f 2>/dev/null | head -10
    
    echo ""
    echo "Looking for settings.gradle files:"
    find ~ -name "settings.gradle" -type f 2>/dev/null | head -10
fi

echo ""
echo "============================================="
echo "🎯 QUICK ACTIONS:"
echo "============================================="

# If we found the directory, provide quick navigation
if [ -n "$correct_dir" ]; then
    echo "1. Navigate to correct directory:"
    echo "   cd \"$correct_dir\""
    echo ""
    echo "2. Test Gradle tasks:"
    echo "   ./gradlew tasks"
    echo ""
    echo "3. Build APK:"
    echo "   ./gradlew assembleDebug"
    echo ""
    echo "4. Auto-navigate and build (copy-paste this):"
    echo "   cd \"$correct_dir\" && ./gradlew clean && ./gradlew assembleDebug"
else
    echo "🔧 RECOVERY OPTIONS:"
    echo ""
    echo "1. Re-clone the repository:"
    echo "   cd ~"
    echo "   rm -rf hotspot-manager"
    echo "   git clone https://github.com/onyxcctvsystems/hotspot-manager.git"
    echo "   cd hotspot-manager"
    echo ""
    echo "2. Check if project exists elsewhere:"
    echo "   find ~ -name \"*.gradle\" -type f 2>/dev/null"
fi

echo ""
echo "============================================="
echo "🚀 NEXT STEPS:"
echo "============================================="
echo "1. Run the navigation command above"
echo "2. Verify you can see gradle tasks: ./gradlew tasks"
echo "3. Build the APK: ./gradlew assembleDebug"
echo "4. If issues persist, re-clone the project"
echo "============================================="
