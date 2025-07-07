#!/bin/bash
# 🔧 FINAL PROJECT STRUCTURE FIX: Correct Android project structure and build APK

echo "🔧 Final Project Structure Fix..."
echo "============================================="

# Navigate to project directory
cd ~/hotspot-manager/Hotspot\ Mobile\ APP/android

# Check current project structure
echo "🔍 Current project structure:"
ls -la
echo ""
echo "Available Gradle tasks:"
./gradlew tasks --all | grep -i assemble

# Check if app directory exists
if [ ! -d "app" ]; then
    echo "❌ ERROR: app directory not found!"
    echo "📋 Current directory contents:"
    ls -la
    echo ""
    echo "🔍 Looking for Android project structure..."
    find . -name "*.gradle" -type f
    echo ""
    exit 1
fi

# Verify settings.gradle includes app module
echo "🔍 Checking settings.gradle..."
cat settings.gradle

# Check if settings.gradle properly includes the app module
if ! grep -q "include ':app'" settings.gradle; then
    echo "🔧 Fixing settings.gradle..."
    cat > settings.gradle << 'EOF'
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}
dependencyResolutionManagement {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.name = "HotspotManager"
include ':app'
EOF
    echo "✅ settings.gradle updated"
fi

# Check app/build.gradle exists and is correct
if [ ! -f "app/build.gradle" ]; then
    echo "❌ ERROR: app/build.gradle not found!"
    exit 1
fi

echo "🔍 Checking app/build.gradle..."
head -5 app/build.gradle

# Verify the app module structure
echo "🔍 Checking app module structure..."
ls -la app/
ls -la app/src/main/

# Check if AndroidManifest.xml exists
if [ ! -f "app/src/main/AndroidManifest.xml" ]; then
    echo "❌ ERROR: AndroidManifest.xml not found!"
    echo "📁 app/src/main/ contents:"
    ls -la app/src/main/
    exit 1
fi

# Clean and sync project
echo "🧹 Cleaning project..."
./gradlew clean

# Check available tasks again
echo "🔍 Available tasks after clean:"
./gradlew tasks | grep -i assemble

# Try to build the project
echo "🔨 Building the project..."
./gradlew build

# If build successful, try to assemble debug APK
if [ $? -eq 0 ]; then
    echo "✅ Build successful! Assembling debug APK..."
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
        echo "🎉 SUCCESS! Your APK is ready!"
        echo "============================================="
    else
        echo "❌ APK not found. Check app/build/outputs/apk/debug/ directory:"
        ls -la app/build/outputs/apk/debug/ 2>/dev/null || echo "Directory doesn't exist"
    fi
else
    echo "❌ Build failed. Checking project structure..."
    echo ""
    echo "🔍 Project root contents:"
    ls -la
    echo ""
    echo "🔍 App module contents:"
    ls -la app/
    echo ""
    echo "🔍 Available Gradle tasks:"
    ./gradlew tasks --all
fi

echo "============================================="
