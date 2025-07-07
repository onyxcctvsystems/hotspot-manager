#!/bin/bash

# 🚀 VPS Quick Start Script for Android Build
# Run this script on your VPS to complete the Android project setup

echo "========================================"
echo "🚀 ANDROID PROJECT VPS QUICK START"
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
    echo "❌ Project directory not found. Cloning from GitHub..."
    git clone https://github.com/onyxcctvsystems/hotspot-manager.git
    cd hotspot-manager
}

log_step "Step 2: Pull latest changes from GitHub"
git pull origin main

log_step "Step 3: Navigate to Android project"
cd "Hotspot Mobile APP/android" || {
    echo "❌ Android directory not found"
    exit 1
}

log_step "Step 4: Make build verification script executable"
chmod +x vps_complete_build_verification.sh

log_step "Step 5: Run comprehensive build verification"
echo "🔧 Running comprehensive Android build verification..."
./vps_complete_build_verification.sh

echo ""
echo "========================================"
echo "🎯 QUICK START COMPLETE!"
echo "========================================"
echo ""
echo "If the build was successful, your APK is at:"
echo "~/hotspot-manager/Hotspot Mobile APP/android/app/build/outputs/apk/debug/app-debug.apk"
echo ""
echo "To download via VS Code Server:"
echo "1. Navigate to the APK file in the file explorer"
echo "2. Right-click and select 'Download'"
echo ""
echo "To download via SCP:"
echo "scp root@your-vps-ip:~/hotspot-manager/Hotspot\\ Mobile\\ APP/android/app/build/outputs/apk/debug/app-debug.apk ."
echo ""
echo "🎉 Your Android app is ready!"
