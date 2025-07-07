#!/bin/bash
# 🚨 EMERGENCY GIT CONFLICT FIX: Resolve merge conflicts and build APK

echo "🚨 Emergency Git Conflict Fix..."
echo "============================================="

# Navigate to project directory
cd ~/hotspot-manager/Hotspot\ Mobile\ APP/android

# Abort any ongoing merge
echo "🛑 Aborting any ongoing merge..."
git merge --abort 2>/dev/null || echo "No merge to abort"

# Reset any local changes
echo "🔄 Resetting local changes..."
git reset --hard HEAD

# Force pull the latest version
echo "📥 Force pulling latest changes..."
git pull origin main --force

# Create a clean build.gradle with the correct Compose version
echo "🔧 Creating clean build.gradle..."
cat > app/build.gradle << 'EOF'
plugins {
    id 'com.android.application'
    id 'org.jetbrains.kotlin.android'
    id 'kotlin-kapt'
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
    
    buildFeatures {
        viewBinding true
        dataBinding true
        compose true
    }
    
    composeOptions {
        kotlinCompilerExtensionVersion = '1.5.8'
    }
}

dependencies {
    implementation 'androidx.core:core-ktx:1.12.0'
    implementation 'androidx.appcompat:appcompat:1.6.1'
    implementation 'com.google.android.material:material:1.11.0'
    implementation 'androidx.constraintlayout:constraintlayout:2.1.4'
    implementation 'androidx.lifecycle:lifecycle-livedata-ktx:2.7.0'
    implementation 'androidx.lifecycle:lifecycle-viewmodel-ktx:2.7.0'
    implementation 'androidx.navigation:navigation-fragment-ktx:2.7.6'
    implementation 'androidx.navigation:navigation-ui-ktx:2.7.6'
    implementation 'androidx.drawerlayout:drawerlayout:1.2.0'
    
    // Compose BOM - manages all Compose library versions
    implementation platform('androidx.compose:compose-bom:2024.02.00')
    implementation 'androidx.compose.ui:ui'
    implementation 'androidx.compose.ui:ui-graphics'
    implementation 'androidx.compose.ui:ui-tooling-preview'
    implementation 'androidx.compose.material3:material3'
    implementation 'androidx.activity:activity-compose:1.8.2'
    
    // Testing
    testImplementation 'junit:junit:4.13.2'
    androidTestImplementation 'androidx.test.ext:junit:1.1.5'
    androidTestImplementation 'androidx.test.espresso:espresso-core:3.5.1'
    androidTestImplementation platform('androidx.compose:compose-bom:2024.02.00')
    androidTestImplementation 'androidx.compose.ui:ui-test-junit4'
    debugImplementation 'androidx.compose.ui:ui-tooling'
    debugImplementation 'androidx.compose.ui:ui-test-manifest'
}
EOF

# Verify the file is clean
echo "✅ Verifying clean build.gradle..."
echo "First 10 lines:"
head -10 app/build.gradle

echo "Compose version line:"
grep -n "kotlinCompilerExtensionVersion" app/build.gradle

# Clean all build artifacts
echo "🧹 Cleaning build artifacts..."
./gradlew clean

# Test build
echo "🔨 Testing build..."
./gradlew build

# If successful, generate APK
if [ $? -eq 0 ]; then
    echo "✅ Build successful! Generating APK..."
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
        echo "❌ APK not found. Build may have failed."
    fi
else
    echo "❌ Build failed. Check output above for errors."
fi

echo "============================================="
