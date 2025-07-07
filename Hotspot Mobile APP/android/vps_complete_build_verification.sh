#!/bin/bash

# VPS Android Build Verification and Fix Script
# This script ensures the Android project is properly set up on the VPS

set -e

echo "=== Android Project Migration and Build Verification ==="
echo "Date: $(date)"
echo "User: $(whoami)"
echo "Working directory: $(pwd)"

# Function to log steps
log_step() {
    echo ""
    echo ">>> $1"
    echo "----------------------------------------"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

log_step "Step 1: Checking Java Installation"
if command_exists java; then
    java -version
    echo "✓ Java is available"
else
    echo "✗ Java not found. Installing OpenJDK 17..."
    sudo apt update
    sudo apt install -y openjdk-17-jdk
    echo "Java installed. Version:"
    java -version
fi

log_step "Step 2: Setting JAVA_HOME"
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
echo "JAVA_HOME set to: $JAVA_HOME"

log_step "Step 3: Checking Android SDK"
if [ -d "$HOME/android-sdk" ]; then
    echo "✓ Android SDK found at $HOME/android-sdk"
    export ANDROID_HOME=$HOME/android-sdk
    export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools
else
    echo "✗ Android SDK not found. Please install it first."
    exit 1
fi

log_step "Step 4: Navigating to Android Project"
cd $HOME/hotspot-manager/android || {
    echo "✗ Android project directory not found"
    exit 1
}
echo "✓ In Android project directory: $(pwd)"

log_step "Step 5: Checking Project Structure"
echo "Project contents:"
ls -la

echo ""
echo "App directory contents:"
if [ -d "app" ]; then
    ls -la app/
    echo "✓ App directory exists"
else
    echo "✗ App directory missing"
    exit 1
fi

echo ""
echo "Checking essential files:"
for file in "settings.gradle" "app/build.gradle" "gradlew" "gradle/wrapper/gradle-wrapper.properties"; do
    if [ -f "$file" ]; then
        echo "✓ $file exists"
    else
        echo "✗ $file missing"
    fi
done

log_step "Step 6: Making Gradle Wrapper Executable"
chmod +x gradlew
echo "✓ gradlew made executable"

log_step "Step 7: Checking Gradle Tasks"
echo "Available Gradle tasks:"
./gradlew tasks --all | head -30

log_step "Step 8: Testing Build Configuration"
echo "Testing Gradle build configuration..."
./gradlew --version

log_step "Step 9: Cleaning Previous Build"
echo "Cleaning previous build artifacts..."
./gradlew clean

log_step "Step 10: Attempting Debug Build"
echo "Attempting to build debug APK..."
./gradlew assembleDebug

log_step "Step 11: Checking Build Output"
if [ -f "app/build/outputs/apk/debug/app-debug.apk" ]; then
    echo "✓ SUCCESS: APK built successfully!"
    echo "APK location: app/build/outputs/apk/debug/app-debug.apk"
    echo "APK size: $(du -h app/build/outputs/apk/debug/app-debug.apk | cut -f1)"
else
    echo "✗ APK not found. Build may have failed."
    echo "Checking build directory:"
    find app/build -name "*.apk" 2>/dev/null || echo "No APK files found"
fi

log_step "Step 12: Build Summary"
echo "Build completed at: $(date)"
echo "If the build was successful, you can download the APK from:"
echo "$HOME/hotspot-manager/android/app/build/outputs/apk/debug/app-debug.apk"

echo ""
echo "=== Script completed ==="
