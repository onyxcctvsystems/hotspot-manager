#!/bin/bash
# 🚀 VPS Build Fix Script - Resolve git conflicts and build APK

echo "🚀 Starting VPS Build Fix..."
echo "============================================="

# Navigate to project directory
cd ~/hotspot-manager/Hotspot\ Mobile\ APP/android

echo "📋 Current directory: $(pwd)"

# Stash local changes to avoid merge conflicts
echo "💾 Stashing local changes..."
git stash

# Pull the latest changes
echo "📥 Pulling latest changes from GitHub..."
git pull origin main

# Apply the stashed changes (if any)
echo "🔄 Applying stashed changes..."
git stash pop || echo "No stash to pop"

# Verify the build.gradle has the correct Compose version
echo "🔍 Checking Compose version in build.gradle..."
grep -n "kotlinCompilerExtensionVersion" app/build.gradle

# If still showing old version, force update the file
if grep -q "kotlinCompilerExtensionVersion '1.3.2'" app/build.gradle; then
    echo "❌ Found old Compose version 1.3.2, fixing..."
    sed -i "s/kotlinCompilerExtensionVersion '1.3.2'/kotlinCompilerExtensionVersion = '1.5.8'/g" app/build.gradle
    echo "✅ Updated Compose version to 1.5.8"
fi

# Also check for the older format and fix it
if grep -q "kotlinCompilerExtensionVersion '1.5.4'" app/build.gradle; then
    echo "❌ Found old Compose version 1.5.4, fixing..."
    sed -i "s/kotlinCompilerExtensionVersion '1.5.4'/kotlinCompilerExtensionVersion = '1.5.8'/g" app/build.gradle
    echo "✅ Updated Compose version to 1.5.8"
fi

# Verify the fix
echo "🔍 Verifying Compose version fix..."
grep -A 2 -B 2 "kotlinCompilerExtensionVersion" app/build.gradle

# Clean build directory
echo "🧹 Cleaning build directory..."
./gradlew clean

# Build the project
echo "🔨 Building the project..."
./gradlew build

# If build successful, generate APK
if [ $? -eq 0 ]; then
    echo "✅ Build successful! Generating APK..."
    ./gradlew assembleDebug
    
    # Check if APK was generated
    if [ -f "app/build/outputs/apk/debug/app-debug.apk" ]; then
        echo "============================================="
        echo "🎉 APK GENERATED SUCCESSFULLY!"
        echo "============================================="
        echo "📱 APK Details:"
        ls -la app/build/outputs/apk/debug/app-debug.apk
        echo ""
        echo "📏 APK Size:"
        du -h app/build/outputs/apk/debug/app-debug.apk
        echo ""
        echo "🎯 Full APK Path:"
        echo "$(pwd)/app/build/outputs/apk/debug/app-debug.apk"
        echo ""
        echo "📥 To download to your Windows machine:"
        echo "scp root@$(hostname -I | awk '{print $1}'):$(pwd)/app/build/outputs/apk/debug/app-debug.apk ."
        echo ""
        echo "🎉 BUILD COMPLETE! Your APK is ready!"
        echo "============================================="
    else
        echo "❌ APK not found. Build may have failed."
    fi
else
    echo "❌ Build failed. Check output above for errors."
    echo "🔍 Running diagnostic check..."
    echo "Current build.gradle composeOptions:"
    grep -A 5 -B 5 "composeOptions" app/build.gradle
fi

echo "============================================="
