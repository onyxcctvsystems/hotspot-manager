#!/bin/bash

# Final Android Project Migration Script
# This script performs the complete migration from Windows to VPS

set -e

echo "=== Final Android Project Migration to VPS ==="
echo "This script will:"
echo "1. Ensure the project is properly pushed to GitHub"
echo "2. Clone/update the project on the VPS"
echo "3. Set up the complete Android build environment"
echo "4. Build the APK successfully"
echo ""

# Function to log steps
log_step() {
    echo ""
    echo ">>> $1"
    echo "----------------------------------------"
}

log_step "Step 1: Push Latest Changes to GitHub (run on Windows)"
echo "Run these commands on your Windows machine:"
echo "cd \"c:\\Users\\onyxt\\Documents\\OneDrive_onyxcctv_systems\\OneDrive\\Hotspot Project\\Hotspot Mobile APP\""
echo "git add ."
echo "git commit -m \"Final Android project structure for VPS migration\""
echo "git push origin main"
echo ""
echo "Press Enter after you've pushed the changes..."

log_step "Step 2: VPS Setup Commands"
echo "Run these commands on your VPS:"
echo ""
echo "# Navigate to home directory"
echo "cd ~"
echo ""
echo "# Clone or update the repository"
echo "if [ -d \"hotspot-manager\" ]; then"
echo "    cd hotspot-manager"
echo "    git pull origin main"
echo "else"
echo "    git clone https://github.com/yourusername/hotspot-manager.git"
echo "    cd hotspot-manager"
echo "fi"
echo ""
echo "# Make the build verification script executable"
echo "chmod +x android/vps_complete_build_verification.sh"
echo ""
echo "# Run the build verification"
echo "cd android"
echo "./vps_complete_build_verification.sh"
echo ""

log_step "Step 3: Expected Results"
echo "After running the VPS build verification script, you should see:"
echo "✓ Java 17 properly configured"
echo "✓ Android SDK with required components"
echo "✓ Project structure validated"
echo "✓ Gradle wrapper working"
echo "✓ assembleDebug task available"
echo "✓ APK built successfully"
echo ""
echo "The final APK will be located at:"
echo "~/hotspot-manager/android/app/build/outputs/apk/debug/app-debug.apk"

log_step "Step 4: Downloading the APK"
echo "To download the APK to your Windows machine:"
echo "1. Use VS Code's file explorer to navigate to the APK file"
echo "2. Right-click and select 'Download'"
echo "3. Or use SCP: scp user@your-vps-ip:~/hotspot-manager/android/app/build/outputs/apk/debug/app-debug.apk ."

log_step "Step 5: Documentation Update"
echo "Update VPS_VSCODE_SERVER_SETUP.md with the successful build process"

echo ""
echo "=== Migration Script Ready ==="
echo "This script provides the complete migration path from Windows to VPS."
echo "Follow the steps above to complete the migration successfully."
