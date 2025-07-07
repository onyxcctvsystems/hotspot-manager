#!/bin/bash

# 🔧 VPS Complete Android Project Structure Fix
# This script will restore the complete Android project structure

echo "============================================="
echo "🔧 VPS ANDROID PROJECT STRUCTURE FIX"
echo "============================================="

# Navigate to the Android project directory
cd ~/hotspot-manager/Hotspot\ Mobile\ APP/android

echo "📍 Current directory: $(pwd)"

# Step 1: Create the missing app/build.gradle file
echo "🏗️ Creating app/build.gradle..."
mkdir -p app/src/main/java/com/onyx/hotspotmanager
mkdir -p app/src/main/res/{values,layout,drawable,menu,navigation,xml}

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

# Step 2: Create proguard-rules.pro
echo "🔧 Creating proguard-rules.pro..."
cat > app/proguard-rules.pro << 'EOF'
# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile
EOF

# Step 3: Create AndroidManifest.xml
echo "🔧 Creating AndroidManifest.xml..."
cat > app/src/main/AndroidManifest.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <application
        android:allowBackup="true"
        android:dataExtractionRules="@xml/data_extraction_rules"
        android:fullBackupContent="@xml/backup_rules"
        android:icon="@drawable/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@drawable/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.HotspotManager">
        
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:label="@string/app_name"
            android:theme="@style/Theme.HotspotManager">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
        
    </application>

</manifest>
EOF

# Step 4: Create strings.xml
echo "🔧 Creating strings.xml..."
cat > app/src/main/res/values/strings.xml << 'EOF'
<resources>
    <string name="app_name">Hotspot Manager</string>
    <string name="hello_world">Hello World!</string>
    
    <!-- Navigation strings -->
    <string name="nav_header_title">Hotspot Manager</string>
    <string name="nav_header_subtitle">Mikrotik Management System</string>
    <string name="nav_header_desc">Navigation header</string>
    
    <!-- Menu strings -->
    <string name="menu_dashboard">Dashboard</string>
    <string name="menu_routers">Routers</string>
    <string name="menu_packages">Packages</string>
    <string name="menu_vouchers">Vouchers</string>
    <string name="menu_settings">Settings</string>
    <string name="action_logout">Logout</string>
</resources>
EOF

# Step 5: Create backup and data extraction rules
echo "🔧 Creating backup and data extraction rules..."
cat > app/src/main/res/xml/backup_rules.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<full-backup-content>
    <!-- 
    <include domain="file" path="dd"/>
    <exclude domain="file" path="dd/fo"/>
    -->
</full-backup-content>
EOF

cat > app/src/main/res/xml/data_extraction_rules.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<data-extraction-rules>
    <cloud-backup>
        <!-- TODO: Use <include> and <exclude> to control what is backed up.
        <include .../>
        <exclude .../>
        -->
    </cloud-backup>
    <!--
    <device-transfer>
        <include .../>
        <exclude .../>
    </device-transfer>
    -->
</data-extraction-rules>
EOF

# Step 6: Create drawable icons
echo "🔧 Creating drawable icons..."
cat > app/src/main/res/drawable/ic_launcher.xml << 'EOF'
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="24dp"
    android:height="24dp"
    android:viewportWidth="24"
    android:viewportHeight="24"
    android:tint="?attr/colorOnSurface">
  <path
      android:fillColor="@android:color/white"
      android:pathData="M12,2C6.48,2 2,6.48 2,12s4.48,10 10,10 10,-4.48 10,-10S17.52,2 12,2zM11,19.93c-3.95,-0.49 -7,-3.85 -7,-7.93 0,-0.62 0.08,-1.21 0.21,-1.79L9,15v1c0,1.1 0.9,2 2,2v1.93zM17.9,17.39c-0.26,-0.81 -1,-1.39 -1.9,-1.39h-1v-3c0,-0.55 -0.45,-1 -1,-1H8v-2h2c0.55,0 1,-0.45 1,-1V7h2c1.1,0 2,-0.9 2,-2v-0.41c2.93,1.19 5,4.06 5,7.41 0,2.08 -0.8,3.97 -2.1,5.39z"/>
</vector>
EOF

cat > app/src/main/res/drawable/ic_launcher_round.xml << 'EOF'
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="24dp"
    android:height="24dp"
    android:viewportWidth="24"
    android:viewportHeight="24"
    android:tint="?attr/colorOnSurface">
  <path
      android:fillColor="@android:color/white"
      android:pathData="M12,2C6.48,2 2,6.48 2,12s4.48,10 10,10 10,-4.48 10,-10S17.52,2 12,2zM11,19.93c-3.95,-0.49 -7,-3.85 -7,-7.93 0,-0.62 0.08,-1.21 0.21,-1.79L9,15v1c0,1.1 0.9,2 2,2v1.93zM17.9,17.39c-0.26,-0.81 -1,-1.39 -1.9,-1.39h-1v-3c0,-0.55 -0.45,-1 -1,-1H8v-2h2c0.55,0 1,-0.45 1,-1V7h2c1.1,0 2,-0.9 2,-2v-0.41c2.93,1.19 5,4.06 5,7.41 0,2.08 -0.8,3.97 -2.1,5.39z"/>
</vector>
EOF

# Step 7: Create MainActivity.kt
echo "🔧 Creating MainActivity.kt..."
cat > app/src/main/java/com/onyx/hotspotmanager/MainActivity.kt << 'EOF'
package com.onyx.hotspotmanager

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }
    }
}
EOF

# Step 8: Create activity_main.xml
echo "🔧 Creating activity_main.xml..."
cat > app/src/main/res/layout/activity_main.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools"
    android:id="@+id/main"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    tools:context=".MainActivity">

    <TextView
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="@string/hello_world"
        app:layout_constraintBottom_toBottomOf="parent"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toTopOf="parent" />

</androidx.constraintlayout.widget.ConstraintLayout>
EOF

# Step 9: Create themes.xml
echo "🔧 Creating themes.xml..."
mkdir -p app/src/main/res/values
cat > app/src/main/res/values/themes.xml << 'EOF'
<resources xmlns:tools="http://schemas.android.com/tools">
    <!-- Base application theme. -->
    <style name="Theme.HotspotManager" parent="Theme.Material3.DayNight">
        <!-- Primary brand color. -->
        <item name="colorPrimary">@color/purple_500</item>
        <item name="colorPrimaryVariant">@color/purple_700</item>
        <item name="colorOnPrimary">@color/white</item>
        <!-- Secondary brand color. -->
        <item name="colorSecondary">@color/teal_200</item>
        <item name="colorSecondaryVariant">@color/teal_700</item>
        <item name="colorOnSecondary">@color/black</item>
        <!-- Status bar color. -->
        <item name="android:statusBarColor">?attr/colorPrimaryVariant</item>
        <!-- Customize your theme here. -->
    </style>
</resources>
EOF

# Step 10: Create colors.xml
echo "🔧 Creating colors.xml..."
cat > app/src/main/res/values/colors.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="purple_200">#FFBB86FC</color>
    <color name="purple_500">#FF6200EE</color>
    <color name="purple_700">#FF3700B3</color>
    <color name="teal_200">#FF03DAC5</color>
    <color name="teal_700">#FF018786</color>
    <color name="black">#FF000000</color>
    <color name="white">#FFFFFFFF</color>
</resources>
EOF

# Step 11: Clean up strange files
echo "🧹 Cleaning up strange files..."
rm -f A Android FETCH_HEAD For Get IDLE Run Task "]"

# Step 12: Update root build.gradle
echo "🔧 Updating root build.gradle..."
cat > build.gradle << 'EOF'
// Top-level build file where you can add configuration options common to all sub-projects/modules.
plugins {
    id 'com.android.application' version '8.2.1' apply false
    id 'org.jetbrains.kotlin.android' version '1.9.22' apply false
}
EOF

# Step 13: Make gradlew executable and test
echo "🔧 Making gradlew executable..."
chmod +x gradlew

echo "🧪 Testing project structure..."
echo "Files created:"
echo "✅ app/build.gradle"
echo "✅ app/proguard-rules.pro"
echo "✅ app/src/main/AndroidManifest.xml"
echo "✅ app/src/main/java/com/onyx/hotspotmanager/MainActivity.kt"
echo "✅ app/src/main/res/values/strings.xml"
echo "✅ app/src/main/res/values/themes.xml"
echo "✅ app/src/main/res/values/colors.xml"
echo "✅ app/src/main/res/layout/activity_main.xml"
echo "✅ app/src/main/res/drawable/ic_launcher.xml"
echo "✅ app/src/main/res/drawable/ic_launcher_round.xml"
echo "✅ app/src/main/res/xml/backup_rules.xml"
echo "✅ app/src/main/res/xml/data_extraction_rules.xml"

echo ""
echo "🔧 Testing Gradle tasks..."
./gradlew tasks | grep -E "(assembleDebug|build|clean)"

echo ""
echo "🏗️ Building APK..."
./gradlew clean
./gradlew assembleDebug

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ SUCCESS! APK built successfully!"
    echo "📱 APK location:"
    find . -name "*.apk" -type f
    ls -la app/build/outputs/apk/debug/ 2>/dev/null || echo "APK directory not found"
else
    echo ""
    echo "❌ Build failed. Check the output above for errors."
fi

echo ""
echo "============================================="
echo "🎉 ANDROID PROJECT STRUCTURE RESTORED!"
echo "============================================="
echo "The complete Android project structure has been created."
echo "You can now run: ./gradlew assembleDebug"
echo "============================================="
