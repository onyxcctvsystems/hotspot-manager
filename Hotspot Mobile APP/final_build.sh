#!/bin/bash
# 🚀 Final APK Build Script for Hostinger VPS
# Run this on your VPS to complete the build and generate APK

echo "🚀 Starting final APK build process..."
echo "============================================="

# Navigate to project directory
cd ~/hotspot-manager/Hotspot\ Mobile\ APP/android

# Pull latest changes
echo "📥 Pulling latest changes from GitHub..."
git pull origin main

# Clean build
echo "🧹 Cleaning previous build..."
./gradlew clean

# Build the app
echo "🔨 Building the app..."
./gradlew build

# Generate APK
echo "📱 Generating APK..."
./gradlew assembleDebug

# Check if APK was generated
echo "============================================="
echo "🔍 Checking for generated APK..."
if [ -f "app/build/outputs/apk/debug/app-debug.apk" ]; then
    echo "✅ APK GENERATED SUCCESSFULLY!"
    echo "============================================="
    echo "📱 APK Details:"
    ls -la app/build/outputs/apk/debug/app-debug.apk
    echo ""
    echo "📏 APK Size:"
    du -h app/build/outputs/apk/debug/app-debug.apk
    echo ""
    echo "🎯 APK Location:"
    echo "$(pwd)/app/build/outputs/apk/debug/app-debug.apk"
    echo ""
    echo "📥 To download to your Windows machine:"
    echo "scp root@$(hostname -I | awk '{print $1}'):$(pwd)/app/build/outputs/apk/debug/app-debug.apk ."
    echo ""
    echo "🎉 BUILD COMPLETE! Your APK is ready!"
else
    echo "❌ APK not found. Check build output above for errors."
    echo "Try running: ./gradlew assembleDebug --info"
fi

echo "============================================="
