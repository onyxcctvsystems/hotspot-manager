#!/bin/bash

# 🚀 Auto-Navigate to Android Project and Build
# This script finds the correct Android project directory and builds the APK

echo "🔍 Auto-finding Android project directory..."

# Function to find Android project
find_android_project() {
    locations=(
        "~/hotspot-manager/Hotspot Mobile APP/android"
        "~/hotspot-manager/android"
        "~/hotspot-project/android"
        "./android"
        "."
    )
    
    for location in "${locations[@]}"; do
        expanded_location=$(eval echo "$location")
        if [ -f "$expanded_location/gradlew" ] && [ -f "$expanded_location/app/build.gradle" ]; then
            echo "✅ Found Android project: $expanded_location"
            echo "$expanded_location"
            return 0
        fi
    done
    
    echo "❌ Android project not found!"
    return 1
}

# Find and navigate to Android project
android_dir=$(find_android_project)

if [ $? -eq 0 ]; then
    echo "🚀 Navigating to: $android_dir"
    cd "$android_dir"
    
    echo "📍 Current directory: $(pwd)"
    echo "📁 Contents:"
    ls -la
    
    echo ""
    echo "🔧 Making gradlew executable..."
    chmod +x gradlew
    
    echo ""
    echo "📋 Available Gradle tasks:"
    ./gradlew tasks | grep -E "(assembleDebug|build|clean)" | head -10
    
    echo ""
    echo "🏗️ Building APK..."
    ./gradlew clean
    ./gradlew assembleDebug
    
    if [ $? -eq 0 ]; then
        echo "✅ BUILD SUCCESSFUL!"
        echo "📱 APK location: $(find . -name "*.apk" -type f | head -1)"
    else
        echo "❌ Build failed. Running diagnostics..."
        ./gradlew assembleDebug --info | tail -20
    fi
else
    echo "❌ Could not find Android project directory!"
    echo "🔍 Searching for gradlew files..."
    find ~ -name "gradlew" -type f 2>/dev/null | head -5
fi
