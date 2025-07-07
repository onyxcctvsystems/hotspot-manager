#!/bin/bash

# VPS Build Script - Run this on your VPS
# This script will pull the latest changes and rebuild the project

echo "🚀 Starting VPS Build Process..."
echo "================================="

# Navigate to the project directory
cd /root/hotspot-manager || {
    echo "❌ Error: Project directory not found!"
    exit 1
}

# Pull latest changes from GitHub
echo "📥 Pulling latest changes from GitHub..."
git pull origin main

# Navigate to Android project
cd "Hotspot Mobile APP/android" || {
    echo "❌ Error: Android project directory not found!"
    exit 1
}

# Check if build.gradle has data binding enabled
echo "🔍 Checking build.gradle configuration..."
if grep -q "dataBinding true" app/build.gradle; then
    echo "✅ Data binding is enabled in build.gradle"
else
    echo "❌ Data binding is NOT enabled in build.gradle"
    echo "🔧 Adding data binding configuration..."
    
    # Create backup
    cp app/build.gradle app/build.gradle.backup
    
    # Add data binding if buildFeatures section exists
    if grep -q "buildFeatures" app/build.gradle; then
        sed -i '/buildFeatures {/,/}/ { /viewBinding true/a\        dataBinding true; }' app/build.gradle
    else
        # Add buildFeatures section if it doesn't exist
        sed -i '/kotlinOptions {/,/}/ { /}/a\    buildFeatures {\n        viewBinding true\n        dataBinding true\n    }; }' app/build.gradle
    fi
    
    echo "✅ Data binding configuration added"
fi

# Clean and build
echo "🧹 Cleaning previous build..."
./gradlew clean

echo "🔨 Building project..."
./gradlew build

# Check if build was successful
if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo "🎉 Generating APK..."
    ./gradlew assembleDebug
    
    if [ $? -eq 0 ]; then
        echo "✅ APK generated successfully!"
        echo "📱 APK Location: app/build/outputs/apk/debug/"
        ls -la app/build/outputs/apk/debug/
    else
        echo "❌ APK generation failed"
    fi
else
    echo "❌ Build failed"
    echo "💡 Try running: ./gradlew build --info"
fi

echo "================================="
echo "🏁 Build process completed!"
