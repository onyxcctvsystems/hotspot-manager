#!/bin/bash

# 🔧 VPS Git & Build Fix Script
# This script fixes the divergent branches issue and sets up the build properly

set -e

echo "========================================"
echo "🔧 VPS GIT & BUILD FIX SCRIPT"
echo "========================================"
echo ""

# Function to log steps
log_step() {
    echo ""
    echo ">>> $1"
    echo "----------------------------------------"
}

log_step "Step 1: Navigate to project directory"
cd ~/hotspot-manager || {
    echo "❌ Project directory not found. Cloning fresh..."
    git clone https://github.com/onyxcctvsystems/hotspot-manager.git
    cd hotspot-manager
}

log_step "Step 2: Check current git status"
echo "Current git status:"
git status

log_step "Step 3: Fix divergent branches issue"
echo "Configuring git to use merge strategy..."
git config pull.rebase false

echo "Resetting local changes and pulling fresh..."
git reset --hard HEAD
git clean -fd
git pull origin main

log_step "Step 4: Navigate to Android project"
cd "Hotspot Mobile APP/android" || {
    echo "❌ Android directory not found"
    echo "Available directories:"
    ls -la ../
    exit 1
}

log_step "Step 5: Check for build verification script"
if [ -f "vps_complete_build_verification.sh" ]; then
    echo "✅ Build verification script found"
    chmod +x vps_complete_build_verification.sh
else
    echo "❌ Build verification script not found"
    echo "Creating build verification script..."
    
    # Create the build verification script
    cat > vps_complete_build_verification.sh << 'EOF'
#!/bin/bash

# VPS Android Build Verification Script
set -e

echo "=== Android Build Verification ==="
echo "Date: $(date)"
echo "Working directory: $(pwd)"

# Check Java
echo ""
echo ">>> Checking Java Installation"
if command -v java >/dev/null 2>&1; then
    java -version
    echo "✅ Java is available"
else
    echo "❌ Java not found. Installing..."
    sudo apt update
    sudo apt install -y openjdk-17-jdk
fi

# Set JAVA_HOME
echo ""
echo ">>> Setting JAVA_HOME"
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
echo "JAVA_HOME: $JAVA_HOME"

# Check Android SDK
echo ""
echo ">>> Checking Android SDK"
if [ -d "$HOME/android-sdk" ]; then
    echo "✅ Android SDK found"
    export ANDROID_HOME=$HOME/android-sdk
    export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools
else
    echo "❌ Android SDK not found"
    echo "Installing Android SDK..."
    mkdir -p ~/android-sdk/cmdline-tools
    cd ~/android-sdk/cmdline-tools
    wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
    unzip commandlinetools-linux-9477386_latest.zip
    mv cmdline-tools latest
    export ANDROID_HOME=$HOME/android-sdk
    export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools
    cd ~/hotspot-manager/Hotspot\ Mobile\ APP/android
fi

# Check project structure
echo ""
echo ">>> Checking Project Structure"
echo "Current directory: $(pwd)"
ls -la

# Make gradlew executable
echo ""
echo ">>> Making Gradle wrapper executable"
chmod +x gradlew

# Check Gradle
echo ""
echo ">>> Checking Gradle"
./gradlew --version

# Clean build
echo ""
echo ">>> Cleaning previous build"
./gradlew clean

# Build APK
echo ""
echo ">>> Building debug APK"
./gradlew assembleDebug

# Check result
echo ""
echo ">>> Checking build result"
if [ -f "app/build/outputs/apk/debug/app-debug.apk" ]; then
    echo "✅ SUCCESS: APK built successfully!"
    echo "APK location: app/build/outputs/apk/debug/app-debug.apk"
    echo "APK size: $(du -h app/build/outputs/apk/debug/app-debug.apk | cut -f1)"
else
    echo "❌ APK not found"
    echo "Looking for APK files..."
    find . -name "*.apk" 2>/dev/null || echo "No APK files found"
fi

echo ""
echo "=== Build verification completed ==="
EOF

    chmod +x vps_complete_build_verification.sh
    echo "✅ Build verification script created"
fi

log_step "Step 6: Run build verification"
echo "🔧 Running comprehensive build verification..."
./vps_complete_build_verification.sh

echo ""
echo "========================================"
echo "🎉 VPS FIX COMPLETE!"
echo "========================================"
echo ""
echo "If the build was successful, your APK is at:"
echo "~/hotspot-manager/Hotspot Mobile APP/android/app/build/outputs/apk/debug/app-debug.apk"
echo ""
echo "To download the APK:"
echo "1. Via VS Code Server: Navigate to the APK file and download"
echo "2. Via SCP: scp root@your-vps-ip:~/hotspot-manager/Hotspot\\ Mobile\\ APP/android/app/build/outputs/apk/debug/app-debug.apk ."
echo ""
echo "🎉 Your Android app is ready!"
