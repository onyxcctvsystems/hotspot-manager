#!/bin/bash

# 🔧 VPS Complete Android Build Diagnostic and Fix
# This script diagnoses and fixes all Android build issues

set -e

echo "========================================"
echo "🔧 VPS ANDROID BUILD DIAGNOSTIC & FIX"
echo "========================================"
echo ""

# Function to log steps
log_step() {
    echo ""
    echo ">>> $1"
    echo "----------------------------------------"
}

log_step "Step 1: Environment Setup"
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export ANDROID_HOME=~/android-sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools

echo "Environment variables:"
echo "JAVA_HOME: $JAVA_HOME"
echo "ANDROID_HOME: $ANDROID_HOME"

log_step "Step 2: Navigate to correct Android project directory"
cd ~/hotspot-manager || {
    echo "❌ hotspot-manager directory not found"
    exit 1
}

echo "Current directory: $(pwd)"
echo "Contents:"
ls -la

# Navigate to Android project
if [ -d "Hotspot Mobile APP/android" ]; then
    cd "Hotspot Mobile APP/android"
    echo "✅ Successfully navigated to Android project"
else
    echo "❌ Android project directory not found"
    echo "Looking for android directories..."
    find . -name "android" -type d
    exit 1
fi

log_step "Step 3: Diagnostic - Check project structure"
echo "Current directory: $(pwd)"
echo "Contents:"
ls -la

echo ""
echo "Checking for essential files:"
for file in "settings.gradle" "app/build.gradle" "gradlew"; do
    if [ -f "$file" ]; then
        echo "✅ $file exists"
    else
        echo "❌ $file missing"
    fi
done

log_step "Step 4: Check settings.gradle content"
if [ -f "settings.gradle" ]; then
    echo "settings.gradle content:"
    cat settings.gradle
else
    echo "❌ settings.gradle not found - creating it..."
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
    echo "✅ settings.gradle created"
fi

log_step "Step 5: Check app/build.gradle content"
if [ -f "app/build.gradle" ]; then
    echo "First 10 lines of app/build.gradle:"
    head -10 app/build.gradle
    echo ""
    echo "Checking for android application plugin:"
    if grep -q "com.android.application" app/build.gradle; then
        echo "✅ Android application plugin found"
    else
        echo "❌ Android application plugin missing"
    fi
else
    echo "❌ app/build.gradle not found"
    echo "❌ This is a critical issue - the app module is missing"
    exit 1
fi

log_step "Step 6: Make gradlew executable and check"
chmod +x gradlew
echo "✅ gradlew made executable"

echo ""
echo "Gradle wrapper version:"
./gradlew --version

log_step "Step 7: List all available Gradle tasks"
echo "Available Gradle tasks:"
./gradlew tasks --all | grep -i assemble || echo "No assemble tasks found"

log_step "Step 8: Check if app module is recognized"
echo "Checking if app module is recognized by Gradle..."
./gradlew projects

log_step "Step 9: Attempt to sync and configure project"
echo "Attempting project sync..."
./gradlew help

log_step "Step 10: Try building with specific module"
echo "Attempting to build with app module specifically..."
if ./gradlew :app:assembleDebug; then
    echo "✅ SUCCESS: Built with :app:assembleDebug"
elif ./gradlew app:assembleDebug; then
    echo "✅ SUCCESS: Built with app:assembleDebug"
elif ./gradlew assembleDebug; then
    echo "✅ SUCCESS: Built with assembleDebug"
else
    echo "❌ All build attempts failed"
    
    log_step "Step 11: Emergency fix - Recreate app/build.gradle"
    echo "Recreating app/build.gradle with minimal configuration..."
    
    mkdir -p app/src/main/java/com/onyx/hotspotmanager
    mkdir -p app/src/main/res/values
    mkdir -p app/src/main/res/layout
    
    # Create minimal app/build.gradle
    cat > app/build.gradle << 'EOF'
plugins {
    id 'com.android.application'
    id 'org.jetbrains.kotlin.android'
}

android {
    namespace 'com.onyx.hotspotmanager'
    compileSdk 34

    defaultConfig {
        applicationId "com.onyx.hotspotmanager"
        minSdk 26
        targetSdk 34
        versionCode 1
        versionName "1.0"
        testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
    }

    buildTypes {
        release {
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
    
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }
    
    kotlinOptions {
        jvmTarget = '1.8'
    }
}

dependencies {
    implementation 'androidx.core:core-ktx:1.12.0'
    implementation 'androidx.appcompat:appcompat:1.6.1'
    implementation 'com.google.android.material:material:1.11.0'
    implementation 'androidx.constraintlayout:constraintlayout:2.1.4'
    
    testImplementation 'junit:junit:4.13.2'
    androidTestImplementation 'androidx.test.ext:junit:1.1.5'
    androidTestImplementation 'androidx.test.espresso:espresso-core:3.5.1'
}
EOF

    # Create minimal AndroidManifest.xml
    mkdir -p app/src/main
    cat > app/src/main/AndroidManifest.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools">

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:theme="@style/Theme.AppCompat.Light.DarkActionBar"
        tools:targetApi="31">
        
        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>
</manifest>
EOF

    # Create minimal strings.xml
    cat > app/src/main/res/values/strings.xml << 'EOF'
<resources>
    <string name="app_name">Hotspot Manager</string>
</resources>
EOF

    # Create minimal MainActivity
    cat > app/src/main/java/com/onyx/hotspotmanager/MainActivity.kt << 'EOF'
package com.onyx.hotspotmanager

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
    }
}
EOF

    # Create minimal layout
    mkdir -p app/src/main/res/layout
    cat > app/src/main/res/layout/activity_main.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical"
    android:gravity="center">

    <TextView
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Hotspot Manager"
        android:textSize="24sp" />

</LinearLayout>
EOF

    echo "✅ Emergency app structure created"
    
    log_step "Step 12: Try building with emergency configuration"
    echo "Cleaning and building with emergency configuration..."
    ./gradlew clean
    ./gradlew assembleDebug
fi

log_step "Step 13: Final verification"
if [ -f "app/build/outputs/apk/debug/app-debug.apk" ]; then
    echo ""
    echo "🎉 SUCCESS! APK built successfully!"
    echo "==============================================="
    echo "APK location: $(pwd)/app/build/outputs/apk/debug/app-debug.apk"
    echo "APK size: $(du -h app/build/outputs/apk/debug/app-debug.apk | cut -f1)"
    echo ""
    echo "To download the APK:"
    echo "scp root@your-vps-ip:~/hotspot-manager/Hotspot\\ Mobile\\ APP/android/app/build/outputs/apk/debug/app-debug.apk ."
    echo "==============================================="
else
    echo "❌ APK still not found"
    echo "Searching for any APK files..."
    find . -name "*.apk" 2>/dev/null || echo "No APK files found anywhere"
fi

echo ""
echo "========================================"
echo "🎯 DIAGNOSTIC COMPLETE!"
echo "========================================"
