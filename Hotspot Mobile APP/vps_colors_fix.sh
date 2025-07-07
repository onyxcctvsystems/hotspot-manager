#!/bin/bash

# 🎨 VPS Missing Colors Fix Script
# This script adds all missing color resources to fix the build

echo "============================================="
echo "🎨 FIXING MISSING COLOR RESOURCES"
echo "============================================="

# Navigate to the Android project directory
cd ~/hotspot-manager/Hotspot\ Mobile\ APP/android

echo "📍 Current directory: $(pwd)"

# Add missing colors to colors.xml
echo "🎨 Adding missing color resources..."
cat > app/src/main/res/values/colors.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <!-- Primary Colors -->
    <color name="colorPrimary">#FF6200EE</color>
    <color name="colorPrimaryDark">#FF3700B3</color>
    <color name="colorAccent">#FF03DAC5</color>
    
    <!-- Material Design Colors -->
    <color name="purple_200">#FFBB86FC</color>
    <color name="purple_500">#FF6200EE</color>
    <color name="purple_700">#FF3700B3</color>
    <color name="teal_200">#FF03DAC5</color>
    <color name="teal_700">#FF018786</color>
    <color name="black">#FF000000</color>
    <color name="white">#FFFFFFFF</color>
    
    <!-- Text Colors -->
    <color name="textPrimary">#FF000000</color>
    <color name="textSecondary">#FF666666</color>
    <color name="textHint">#FF999999</color>
    
    <!-- Background Colors -->
    <color name="backgroundColor">#FFFFFFFF</color>
    <color name="surfaceColor">#FFFAFAFA</color>
    
    <!-- Button Colors -->
    <color name="buttonPrimary">#FF6200EE</color>
    <color name="buttonSecondary">#FF03DAC5</color>
    
    <!-- Status Colors -->
    <color name="colorSuccess">#FF4CAF50</color>
    <color name="colorError">#FFF44336</color>
    <color name="colorWarning">#FFFF9800</color>
    <color name="colorInfo">#FF2196F3</color>
</resources>
EOF

# Also update themes.xml to use the correct color references
echo "🎨 Updating themes.xml..."
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
</resources>
EOF

# Create night theme as well
echo "🌙 Creating night theme..."
mkdir -p app/src/main/res/values-night
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
</resources>
EOF

# Add night colors as well
echo "🌙 Creating night colors..."
cat > app/src/main/res/values-night/colors.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <!-- Night mode colors -->
    <color name="backgroundColor">#FF121212</color>
    <color name="surfaceColor">#FF1E1E1E</color>
    <color name="textPrimary">#FFFFFFFF</color>
    <color name="textSecondary">#FFCCCCCC</color>
    <color name="textHint">#FF888888</color>
</resources>
EOF

echo "✅ All missing color resources added!"
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
    ls -la app/build/outputs/apk/debug/app-debug.apk 2>/dev/null || echo "APK file not found"
    echo ""
    echo "🔍 APK size and info:"
    if [ -f "app/build/outputs/apk/debug/app-debug.apk" ]; then
        file app/build/outputs/apk/debug/app-debug.apk
        echo "Size: $(du -h app/build/outputs/apk/debug/app-debug.apk | cut -f1)"
    fi
else
    echo ""
    echo "❌ Build still failing. Let's check what's wrong..."
    echo "🔍 Recent error details:"
    ./gradlew assembleDebug --info 2>&1 | tail -20
fi

echo ""
echo "============================================="
echo "🎨 COLOR RESOURCES FIX COMPLETE!"
echo "============================================="
echo "Added colors:"
echo "✅ colorPrimary, colorPrimaryDark, colorAccent"
echo "✅ textPrimary, textSecondary, textHint"
echo "✅ backgroundColor, surfaceColor"
echo "✅ buttonPrimary, buttonSecondary"
echo "✅ colorSuccess, colorError, colorWarning, colorInfo"
echo "✅ Night mode colors and themes"
echo "============================================="
