#!/bin/bash

# Quick Path Fix and Build Script
# This script fixes the path issues and builds your Android app

echo "🔧 Quick Path Fix and Build Script"
echo "=================================="

# Check current location
echo "📍 Current directory: $(pwd)"

# Try to find the correct Android project directory
echo "🔍 Looking for Android project..."

ANDROID_PROJECT_DIR=""

# Check common locations
if [ -d "/root/hotspot-manager/Hotspot Mobile APP/android" ]; then
    ANDROID_PROJECT_DIR="/root/hotspot-manager/Hotspot Mobile APP/android"
    echo "✅ Found Android project at: $ANDROID_PROJECT_DIR"
elif [ -d "/root/hotspot-manager/android" ]; then
    ANDROID_PROJECT_DIR="/root/hotspot-manager/android"
    echo "✅ Found Android project at: $ANDROID_PROJECT_DIR"
else
    echo "🔍 Searching for gradlew file..."
    GRADLEW_PATH=$(find /root -name "gradlew" -type f 2>/dev/null | grep -v ".gradle" | head -1)
    if [ -n "$GRADLEW_PATH" ]; then
        ANDROID_PROJECT_DIR=$(dirname "$GRADLEW_PATH")
        echo "✅ Found Android project at: $ANDROID_PROJECT_DIR"
    else
        echo "❌ Cannot find Android project"
        echo "📂 Available directories in /root/hotspot-manager:"
        ls -la /root/hotspot-manager/ 2>/dev/null || echo "hotspot-manager directory not found"
        exit 1
    fi
fi

# Navigate to the Android project
echo "📂 Navigating to: $ANDROID_PROJECT_DIR"
cd "$ANDROID_PROJECT_DIR" || {
    echo "❌ Failed to navigate to Android project directory"
    exit 1
}

echo "📍 Current directory: $(pwd)"
echo "📋 Directory contents:"
ls -la

# Check if gradlew exists and make it executable
if [ -f "gradlew" ]; then
    echo "🔧 Making gradlew executable..."
    chmod +x gradlew
else
    echo "❌ gradlew not found in current directory"
    exit 1
fi

# Check Java
echo "☕ Checking Java..."
java -version

# Check if app directory exists
if [ ! -d "app" ]; then
    echo "❌ app directory not found"
    echo "📂 Available directories:"
    ls -la
    exit 1
fi

# Set environment variables
echo "🔧 Setting environment variables..."
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export ANDROID_HOME=~/android-sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools

# Clean previous builds
echo "🧹 Cleaning previous builds..."
./gradlew clean

# Build the APK
echo "🔨 Building debug APK..."
./gradlew assembleDebug --info

BUILD_EXIT_CODE=$?

echo ""
echo "📊 BUILD RESULT:"
echo "================"

if [ $BUILD_EXIT_CODE -eq 0 ]; then
    echo "✅ BUILD SUCCESSFUL!"
    
    # Find APK
    APK_PATH=$(find . -name "app-debug.apk" -type f | head -1)
    if [ -n "$APK_PATH" ]; then
        echo "📱 APK found at: $APK_PATH"
        echo "📊 APK size: $(ls -lh "$APK_PATH" | awk '{print $5}')"
        echo "🕐 Build completed: $(date)"
        
        # Get server IP
        SERVER_IP=$(curl -s ifconfig.me 2>/dev/null || hostname -I | awk '{print $1}')
        
        echo ""
        echo "🎉 SUCCESS! Your Android app is ready!"
        echo "====================================="
        echo "📥 Download APK to Windows:"
        echo "scp root@$SERVER_IP:\"$PWD/$APK_PATH\" ."
        echo ""
        echo "📱 Or download using the full path:"
        echo "scp root@$SERVER_IP:\"$PWD/$APK_PATH\" ./app-debug.apk"
        echo ""
        echo "🎯 APK is ready for testing!"
        
    else
        echo "⚠️ APK not found, searching..."
        find . -name "*.apk" -type f 2>/dev/null || echo "No APK files found"
    fi
else
    echo "❌ BUILD FAILED"
    echo "🔍 Last few lines of output might contain the error"
    echo "💡 Try running the build with more verbose output:"
    echo "./gradlew assembleDebug --stacktrace --debug"
fi

echo ""
echo "📋 Build completed with exit code: $BUILD_EXIT_CODE"
exit $BUILD_EXIT_CODE
