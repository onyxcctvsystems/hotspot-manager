#!/bin/bash

# One-Click Android Build Script for VPS
# This script will build your Android app and provide download instructions

echo "🚀 Android App Build Script - Starting..."
echo "========================================"

# Check if we're in the right directory
if [ ! -d "/root/hotspot-manager" ]; then
    echo "📥 Cloning project from GitHub..."
    cd /root
    git clone https://github.com/onyxcctvsystems/hotspot-manager.git
    cd hotspot-manager
else
    echo "📂 Project found, pulling latest changes..."
    cd /root/hotspot-manager
    git pull origin main
fi

# Navigate to Android project
echo "📍 Navigating to Android project..."
cd "Hotspot Mobile APP/android" || {
    echo "❌ Error: Cannot find Android project directory"
    echo "Directory structure:"
    ls -la
    exit 1
}

echo "📍 Current directory: $(pwd)"
echo "📋 Project contents:"
ls -la

# Check Java installation
echo "☕ Checking Java installation..."
java -version
if [ $? -ne 0 ]; then
    echo "❌ Java not found, installing..."
    sudo apt update
    sudo apt install -y openjdk-17-jdk
    export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
    export PATH=$PATH:$JAVA_HOME/bin
fi

# Check Android SDK
echo "🤖 Checking Android SDK..."
if [ ! -d "$HOME/android-sdk" ]; then
    echo "📥 Installing Android SDK..."
    mkdir -p ~/android-sdk/cmdline-tools
    cd ~/android-sdk/cmdline-tools
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
    unzip -q commandlinetools-linux-9477386_latest.zip
    mv cmdline-tools latest
    export ANDROID_HOME=~/android-sdk
    export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
    export PATH=$PATH:$ANDROID_HOME/platform-tools
    yes | sdkmanager --licenses > /dev/null 2>&1
    sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0" > /dev/null 2>&1
    cd /root/hotspot-manager/"Hotspot Mobile APP"/android
fi

# Make gradlew executable
echo "🔧 Setting up Gradle wrapper..."
chmod +x gradlew

# Run build fixes if needed
echo "🛠️  Running build fixes..."
if [ -f "vps_final_apk_build.sh" ]; then
    chmod +x vps_final_apk_build.sh
    echo "Running final build fix script..."
    ./vps_final_apk_build.sh
else
    echo "🧹 Cleaning previous builds..."
    ./gradlew clean
    
    echo "🔨 Building debug APK..."
    ./gradlew assembleDebug --info
fi

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
        SERVER_IP=$(curl -s ifconfig.me || hostname -I | awk '{print $1}')
        
        echo ""
        echo "🎉 SUCCESS! Your Android app is ready!"
        echo "====================================="
        echo "📥 Download APK to Windows:"
        echo "scp root@$SERVER_IP:$(pwd)/$APK_PATH ."
        echo ""
        echo "📱 Install on Android device:"
        echo "1. Enable Developer Options (Settings → About → Tap Build Number 7 times)"
        echo "2. Enable USB Debugging (Settings → Developer Options)"
        echo "3. Transfer APK to device and install"
        echo ""
        echo "🎯 Ready for testing!"
        
    else
        echo "⚠️  APK not found, searching..."
        find . -name "*.apk" -type f
    fi
else
    echo "❌ BUILD FAILED"
    echo "🔍 Check errors above and try running fix scripts"
fi

echo ""
echo "📋 Build completed with exit code: $BUILD_EXIT_CODE"
exit $BUILD_EXIT_CODE
