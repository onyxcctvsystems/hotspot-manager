#!/bin/bash

# 🔧 VPS Quick Fix for Directory Path Issue
# This script fixes the path issue and builds the APK

set -e

echo "========================================"
echo "🔧 VPS DIRECTORY PATH FIX"
echo "========================================"
echo ""

# Function to log steps
log_step() {
    echo ""
    echo ">>> $1"
    echo "----------------------------------------"
}

log_step "Step 1: Navigate to correct project directory"
cd ~/hotspot-manager || {
    echo "❌ Project directory not found"
    exit 1
}

echo "Current directory: $(pwd)"
echo "Contents:"
ls -la

log_step "Step 2: Navigate to Android project (with correct path)"
cd "Hotspot Mobile APP/android" || {
    echo "❌ Android directory not found"
    echo "Looking for Android directories..."
    find . -name "android" -type d
    echo ""
    echo "Available directories in project:"
    ls -la
    exit 1
}

echo "✅ Successfully navigated to Android project"
echo "Current directory: $(pwd)"
echo "Contents:"
ls -la

log_step "Step 3: Set up environment variables"
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export ANDROID_HOME=~/android-sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools

echo "Environment variables set:"
echo "JAVA_HOME: $JAVA_HOME"
echo "ANDROID_HOME: $ANDROID_HOME"

log_step "Step 4: Make Gradle wrapper executable"
chmod +x gradlew
echo "✅ gradlew made executable"

log_step "Step 5: Check Gradle version"
./gradlew --version

log_step "Step 6: Clean previous build"
echo "Cleaning previous build artifacts..."
./gradlew clean

log_step "Step 7: Build debug APK"
echo "Building debug APK..."
./gradlew assembleDebug

log_step "Step 8: Check build result"
if [ -f "app/build/outputs/apk/debug/app-debug.apk" ]; then
    echo ""
    echo "🎉 SUCCESS! APK built successfully!"
    echo "==============================================="
    echo "APK location: $(pwd)/app/build/outputs/apk/debug/app-debug.apk"
    echo "APK size: $(du -h app/build/outputs/apk/debug/app-debug.apk | cut -f1)"
    echo ""
    echo "To download the APK:"
    echo "1. Via VS Code Server: Navigate to the file and download"
    echo "2. Via SCP: scp root@your-vps-ip:~/hotspot-manager/Hotspot\\ Mobile\\ APP/android/app/build/outputs/apk/debug/app-debug.apk ."
    echo "==============================================="
else
    echo "❌ APK not found"
    echo "Checking for any APK files..."
    find . -name "*.apk" 2>/dev/null || echo "No APK files found"
    echo ""
    echo "Build directory contents:"
    ls -la app/build/outputs/ 2>/dev/null || echo "Build outputs directory not found"
fi

echo ""
echo "========================================"
echo "🎯 BUILD PROCESS COMPLETE!"
echo "========================================"
