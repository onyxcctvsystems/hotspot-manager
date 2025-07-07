#!/bin/bash

# 🎯 VPS Directory Fix Script
# This script helps you find and switch to the correct project directory

echo "============================================="
echo "🔍 VPS Directory Diagnostic & Fix Script"
echo "============================================="

# Check current location
echo "📍 Current directory:"
pwd
echo ""

# Show current directory contents
echo "📁 Current directory contents:"
ls -la
echo ""

# Look for the hotspot-manager directory
echo "🔍 Looking for hotspot-manager directory..."
if [ -d "$HOME/hotspot-manager" ]; then
    echo "✅ Found hotspot-manager directory at: $HOME/hotspot-manager"
    cd "$HOME/hotspot-manager"
    echo "📁 Contents of hotspot-manager:"
    ls -la
    echo ""
    
    # Check for the Android project structure
    if [ -d "Hotspot Mobile APP" ]; then
        echo "✅ Found 'Hotspot Mobile APP' directory"
        cd "Hotspot Mobile APP"
        echo "📁 Contents of 'Hotspot Mobile APP':"
        ls -la
        echo ""
        
        if [ -d "android" ]; then
            echo "✅ Found 'android' directory - this is your correct project directory!"
            cd "android"
            echo "📁 Contents of android directory:"
            ls -la
            echo ""
            
            # Check for essential Android files
            if [ -f "settings.gradle" ]; then
                echo "✅ Found settings.gradle"
            else
                echo "❌ Missing settings.gradle"
            fi
            
            if [ -f "gradlew" ]; then
                echo "✅ Found gradlew"
            else
                echo "❌ Missing gradlew"
            fi
            
            if [ -d "app" ]; then
                echo "✅ Found app directory"
                if [ -f "app/build.gradle" ]; then
                    echo "✅ Found app/build.gradle"
                else
                    echo "❌ Missing app/build.gradle"
                fi
            else
                echo "❌ Missing app directory"
            fi
            
            echo ""
            echo "🎯 CORRECT PROJECT DIRECTORY:"
            echo "$(pwd)"
            echo ""
            echo "📋 To switch to this directory, run:"
            echo "cd ~/hotspot-manager/\"Hotspot Mobile APP\"/android"
            echo ""
            echo "🔨 Then test the build with:"
            echo "./gradlew tasks"
            echo "./gradlew assembleDebug"
            
        else
            echo "❌ No 'android' directory found in 'Hotspot Mobile APP'"
        fi
    else
        echo "❌ No 'Hotspot Mobile APP' directory found"
    fi
else
    echo "❌ No hotspot-manager directory found at $HOME/hotspot-manager"
    echo ""
    echo "🔍 Searching for hotspot-manager in other locations..."
    find /root -name "hotspot-manager" -type d 2>/dev/null || echo "Not found in /root"
    find /home -name "hotspot-manager" -type d 2>/dev/null || echo "Not found in /home"
fi

echo ""
echo "============================================="
echo "🎯 SUMMARY:"
echo "============================================="
echo "The correct directory structure should be:"
echo "~/hotspot-manager/Hotspot Mobile APP/android/"
echo ""
echo "If you're not in this directory, that's why you're getting:"
echo "'Task 'assembleDebug' not found in root project'"
echo ""
echo "✅ SOLUTION: Navigate to the correct directory:"
echo "cd ~/hotspot-manager/\"Hotspot Mobile APP\"/android"
echo ""
echo "Then run:"
echo "./gradlew tasks    # To see available tasks"
echo "./gradlew assembleDebug  # To build the APK"
echo "============================================="
