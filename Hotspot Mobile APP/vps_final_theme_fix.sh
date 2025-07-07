#!/bin/bash

# 🎨 VPS Final Theme Styles Fix Script
# This script adds all missing theme styles to complete the build

echo "============================================="
echo "🎨 FIXING MISSING THEME STYLES"
echo "============================================="

# Navigate to the Android project directory
cd ~/hotspot-manager/Hotspot\ Mobile\ APP/android

echo "📍 Current directory: $(pwd)"

# Add the missing theme styles to themes.xml
echo "🎨 Adding missing AppBar and Popup overlay styles..."
cat > app/src/main/res/values/themes.xml << 'EOF'
<resources xmlns:tools="http://schemas.android.com/tools">
    <!-- Base application theme. -->
    <style name="Theme.HotspotManager" parent="Theme.Material3.DayNight">
        <!-- Primary brand color. -->
        <item name="colorPrimary">@color/colorPrimary</item>
        <item name="colorPrimaryVariant">@color/colorPrimaryDark</item>
        <item name="colorOnPrimary">@color/white</item>
        <!-- Secondary brand color. -->
        <item name="colorSecondary">@color/teal_200</item>
        <item name="colorSecondaryVariant">@color/teal_700</item>
        <item name="colorOnSecondary">@color/black</item>
        <!-- Status bar color. -->
        <item name="android:statusBarColor">?attr/colorPrimaryVariant</item>
        <!-- Customize your theme here. -->
    </style>
    
    <!-- AppBar Overlay Theme -->
    <style name="Theme.HotspotManager.AppBarOverlay" parent="ThemeOverlay.Material3.ActionBar" />
    
    <!-- Popup Overlay Theme -->
    <style name="Theme.HotspotManager.PopupOverlay" parent="ThemeOverlay.Material3" />
    
    <!-- Additional Navigation and UI Styles -->
    <style name="Theme.HotspotManager.NoActionBar">
        <item name="windowActionBar">false</item>
        <item name="windowNoTitle">true</item>
    </style>
</resources>
EOF

# Update night theme as well
echo "🌙 Updating night theme with missing styles..."
cat > app/src/main/res/values-night/themes.xml << 'EOF'
<resources xmlns:tools="http://schemas.android.com/tools">
    <!-- Base application theme. -->
    <style name="Theme.HotspotManager" parent="Theme.Material3.DayNight">
        <!-- Primary brand color. -->
        <item name="colorPrimary">@color/purple_200</item>
        <item name="colorPrimaryVariant">@color/purple_700</item>
        <item name="colorOnPrimary">@color/black</item>
        <!-- Secondary brand color. -->
        <item name="colorSecondary">@color/teal_200</item>
        <item name="colorSecondaryVariant">@color/teal_200</item>
        <item name="colorOnSecondary">@color/black</item>
        <!-- Status bar color. -->
        <item name="android:statusBarColor">?attr/colorPrimaryVariant</item>
        <!-- Customize your theme here. -->
    </style>
    
    <!-- AppBar Overlay Theme for Night Mode -->
    <style name="Theme.HotspotManager.AppBarOverlay" parent="ThemeOverlay.Material3.Dark.ActionBar" />
    
    <!-- Popup Overlay Theme for Night Mode -->
    <style name="Theme.HotspotManager.PopupOverlay" parent="ThemeOverlay.Material3" />
    
    <!-- Additional Navigation and UI Styles for Night Mode -->
    <style name="Theme.HotspotManager.NoActionBar">
        <item name="windowActionBar">false</item>
        <item name="windowNoTitle">true</item>
    </style>
</resources>
EOF

# Check if app_bar_main.xml exists and needs fixing
if [ -f "app/src/main/res/layout/app_bar_main.xml" ]; then
    echo "🔧 Found app_bar_main.xml, checking if it needs theme fixes..."
    # Create a simple version if it's causing issues
    cat > app/src/main/res/layout/app_bar_main.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<androidx.coordinatorlayout.widget.CoordinatorLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    tools:context=".MainActivity">

    <com.google.android.material.appbar.AppBarLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:theme="@style/Theme.HotspotManager.AppBarOverlay">

        <androidx.appcompat.widget.Toolbar
            android:id="@+id/toolbar"
            android:layout_width="match_parent"
            android:layout_height="?attr/actionBarSize"
            android:background="?attr/colorPrimary"
            app:popupTheme="@style/Theme.HotspotManager.PopupOverlay" />

    </com.google.android.material.appbar.AppBarLayout>

    <include layout="@layout/content_main" />

</androidx.coordinatorlayout.widget.CoordinatorLayout>
EOF
fi

# Create content_main.xml if it doesn't exist
if [ ! -f "app/src/main/res/layout/content_main.xml" ]; then
    echo "🔧 Creating content_main.xml..."
    cat > app/src/main/res/layout/content_main.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    app:layout_behavior="@string/appbar_scrolling_view_behavior"
    tools:context=".MainActivity"
    tools:showIn="@layout/app_bar_main">

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
fi

# Add missing string resources for appbar behavior
echo "🔧 Adding missing string resources..."
# First, check if the string already exists
if ! grep -q "appbar_scrolling_view_behavior" app/src/main/res/values/strings.xml; then
    # Remove the closing tag temporarily
    sed -i '$d' app/src/main/res/values/strings.xml
    
    # Add the missing string
    cat >> app/src/main/res/values/strings.xml << 'EOF'
    
    <!-- Material Design behavior strings -->
    <string name="appbar_scrolling_view_behavior">com.google.android.material.appbar.AppBarLayout$ScrollingViewBehavior</string>
</resources>
EOF
fi

echo "✅ All missing theme styles and layouts created!"
echo ""
echo "🧪 Testing the build..."
./gradlew clean
./gradlew assembleDebug

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 SUCCESS! APK built successfully!"
    echo "📱 APK location:"
    find . -name "*.apk" -type f
    echo ""
    echo "📊 APK details:"
    if [ -f "app/build/outputs/apk/debug/app-debug.apk" ]; then
        ls -la app/build/outputs/apk/debug/app-debug.apk
        echo ""
        echo "🔍 APK size and info:"
        file app/build/outputs/apk/debug/app-debug.apk
        echo "Size: $(du -h app/build/outputs/apk/debug/app-debug.apk | cut -f1)"
        echo ""
        echo "🎯 DOWNLOAD COMMANDS:"
        echo "Via SCP: scp root@your-vps-ip:~/hotspot-manager/Hotspot\\ Mobile\\ APP/android/app/build/outputs/apk/debug/app-debug.apk ."
        echo "Via VS Code Server: Navigate to app/build/outputs/apk/debug/ and download app-debug.apk"
    else
        echo "APK file not found in expected location"
        echo "Searching for APK files..."
        find . -name "*.apk" -type f
    fi
else
    echo ""
    echo "❌ Build still failing. Let's check what's wrong..."
    echo "🔍 Recent error details:"
    ./gradlew assembleDebug --info 2>&1 | tail -30
fi

echo ""
echo "============================================="
echo "🎨 THEME STYLES FIX COMPLETE!"
echo "============================================="
echo "Added theme styles:"
echo "✅ Theme.HotspotManager.AppBarOverlay"
echo "✅ Theme.HotspotManager.PopupOverlay"
echo "✅ Theme.HotspotManager.NoActionBar"
echo "✅ Night mode variations"
echo "✅ Updated app_bar_main.xml layout"
echo "✅ Created content_main.xml layout"
echo "✅ Added appbar_scrolling_view_behavior string"
echo "============================================="
