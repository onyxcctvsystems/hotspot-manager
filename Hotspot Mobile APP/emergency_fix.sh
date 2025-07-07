#!/bin/bash
# Emergency fix script for data binding issue
# Run this directly on your VPS

echo "🔧 EMERGENCY DATA BINDING FIX"
echo "=============================="

# Navigate to project root
cd /root/hotspot-manager

# Pull the latest changes from GitHub
echo "📥 Pulling latest changes from GitHub..."
git pull origin main

# Navigate to Android project
cd "Hotspot Mobile APP/android"

# Check current build.gradle content
echo "🔍 Current build.gradle buildFeatures section:"
grep -A 10 -B 2 "buildFeatures" app/build.gradle

# Check if data binding is enabled
if grep -q "dataBinding true" app/build.gradle; then
    echo "✅ Data binding is already enabled"
else
    echo "❌ Data binding is NOT enabled - fixing now..."
    
    # Create backup
    cp app/build.gradle app/build.gradle.backup
    
    # Method 1: Try to add dataBinding to existing buildFeatures
    if grep -q "buildFeatures" app/build.gradle; then
        echo "🔧 Adding dataBinding to existing buildFeatures..."
        sed -i '/buildFeatures {/,/}/ {
            /viewBinding true/a\        dataBinding true
        }' app/build.gradle
    else
        echo "🔧 Adding complete buildFeatures section..."
        # Add buildFeatures section after kotlinOptions
        sed -i '/kotlinOptions {/,/}/ {
            /}/a\    buildFeatures {\n        viewBinding true\n        dataBinding true\n    }
        }' app/build.gradle
    fi
    
    echo "✅ Data binding configuration added"
fi

# Verify the fix
echo "🔍 Updated build.gradle buildFeatures section:"
grep -A 10 -B 2 "buildFeatures" app/build.gradle

# Clean and rebuild
echo "🧹 Cleaning previous build..."
./gradlew clean

echo "🔨 Building project..."
./gradlew build

if [ $? -eq 0 ]; then
    echo "✅ BUILD SUCCESSFUL!"
    echo "🎉 Data binding issue fixed!"
else
    echo "❌ Build still failed. Let's check the build.gradle manually..."
    echo "Current buildFeatures section:"
    grep -A 15 -B 5 "buildFeatures" app/build.gradle
fi
