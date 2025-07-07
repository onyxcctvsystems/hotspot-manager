# Quick Fix Guide for Build Issues

## ⚡️ Improve Android Studio Performance (Microsoft Defender)
If you see a warning about Microsoft Defender Real-Time Protection:

**Add these folders to Defender's exclusion list:**
- `C:\Users\onyxt\.gradle`
- `C:\Users\onyxt\AppData\Local\Android\Sdk`
- `C:\Users\onyxt\AppData\Local\Google\AndroidStudio2025.1.1`
- `C:\Users\onyxt\Documents\OneDrive_onyxcctv_systems\OneDrive\Hotspot Project\Hotspot Mobile APP\android`

**How to add exclusions:**
1. Open Windows Security (search for "Windows Security" in Start menu)
2. Go to "Virus & threat protection"
3. Click "Manage settings" under "Virus & threat protection settings"
4. Scroll to "Exclusions" and click "Add or remove exclusions"
5. Add each folder above
6. Restart Android Studio

---

## 🚨 Java & Gradle Compatibility

If you see errors like:
- `Your build is currently configured to use incompatible Java 21.0.6 and Gradle 7.6. Cannot sync the project.`
- `The minimum compatible Gradle version is 8.5.`
- `The maximum compatible Gradle JVM version is 19.`

**Solution:**
- Upgrade Gradle to at least 8.5 (or 9.0-milestone-1 for Java 21+)
- Or, downgrade your Java to version 19 or below

### How to Upgrade Gradle Wrapper
1. Open `android/gradle/wrapper/gradle-wrapper.properties`
2. Change the distribution URL to:
   - For Gradle 9.0-milestone-1:
     ```
     distributionUrl=https\://services.gradle.org/distributions/gradle-9.0-milestone-1-bin.zip
     ```
   - For Gradle 8.5:
     ```
     distributionUrl=https\://services.gradle.org/distributions/gradle-8.5-bin.zip
     ```
3. Sync the project in Android Studio

### How to Set Gradle JVM Version
- In Android Studio: File > Settings > Build, Execution, Deployment > Build Tools > Gradle
- Set "Gradle JDK" to a version <= 19 (or use Embedded JDK if available)
- If using Java 21, you must use Gradle 9.0-milestone-1 or higher

---

## ❌ NoSuchMethodError: DependencyHandler.module()

If you're seeing errors like:
```
'org.gradle.api.artifacts.Dependency org.gradle.api.artifacts.dsl.DependencyHandler.module(java.lang.Object)'
java.lang.NoSuchMethodError: 'org.gradle.api.artifacts.Dependency org.gradle.api.artifacts.dsl.DependencyHandler.module(java.lang.Object)'
```

This is a critical Android Gradle Plugin compatibility issue.

**IMMEDIATE FIX:**
1. The `gradle-wrapper.properties` has been updated to use Gradle 8.5
2. In Android Studio: File > Sync Project with Gradle Files
3. If sync fails, try: Build > Clean Project, then sync again

**If still failing:**
- Go to File > Settings > Build, Execution, Deployment > Build Tools > Gradle
- Set "Gradle JDK" to JDK 17 or 19 (avoid JDK 21 for now)
- Click Apply and sync project again

---

## 🎯 FINAL SOLUTION: Latest Stable Configuration

**✅ LATEST STABLE VERSIONS APPLIED:**
- **Android Gradle Plugin**: 8.2.2 (latest stable)
- **Gradle**: 8.4 (perfect compatibility with AGP 8.2.2)
- **Kotlin**: 1.9.20 (latest stable)
- **Hilt**: 2.48 (latest stable)
- **Compile/Target SDK**: 34 (latest)
- **JitPack repository**: Added for third-party dependencies

**🔧 JDK Configuration:**
When Android Studio prompts "Select the Gradle JDK location":

**Option 1 (Recommended)**: 
- **Use "Embedded JDK (JetBrains Runtime 21.0.6)"** - Click Accept/OK

**Option 2 (Alternative)**:
- **File > Settings > Build, Execution, Deployment > Build Tools > Gradle**
- **Set "Gradle JDK"** to: `C:\Program Files\Eclipse Adoptium\jdk-21.0.7.6-hotspot`

**CRITICAL Steps:**
1. **Close Android Studio completely**
2. **Restart Android Studio** 
3. **File > Open** > Select the `android` folder
4. **Configure JDK** (see options above)
5. **File > Sync Project with Gradle Files**
6. **Wait for Gradle 8.4 download** (first time only)

---

## Problem: Gradle Build Fails with API Errors

If you're seeing errors like:
```
'org.gradle.api.artifacts.Dependency org.gradle.api.artifacts.dsl.DependencyHandler.module(java.lang.Object)'
```

This is due to Gradle version compatibility. Here's how to fix it:

## Solution Steps:

### 1. Update Android Studio
- Make sure you have the latest version of Android Studio
- Go to Help > Check for Updates

### 2. Fix Gradle Configuration
The project files have been updated with compatible versions:
- Gradle 8.0
- Android Gradle Plugin 8.0.2
- Kotlin 1.8.10

### 3. Install Java Development Kit (JDK)
If you see "'java' is not recognized":
1. Download and install JDK 8 or higher from Oracle or OpenJDK
2. Add Java to your system PATH
3. Restart Android Studio

### 4. Sync Project in Android Studio
1. Open Android Studio
2. File > Open > Select the `android` folder
3. Wait for indexing to complete
4. If "Sync Now" banner appears, click it
5. If not: File > Sync Project with Gradle Files

### 5. Clean and Rebuild
1. Build > Clean Project
2. Build > Rebuild Project

### 6. Alternative: Create New Project
If issues persist, you can:
1. Create a new Android project in Android Studio
2. Copy the source files from `app/src/main/java`
3. Copy the resources from `app/src/main/res`
4. Update the gradle files with the dependencies listed in the original project

## Expected Result
After these steps, the project should sync and build successfully without errors.

## Next Steps
Once the build is working:
1. Test the app on emulator or device
2. Verify backend API is accessible
3. Test user registration and login
4. Add your router configurations

If you continue to have issues, please share the specific error messages for more targeted assistance.

---

## 🚨 **CACHE CORRUPTION FIX**

**If you see errors like:**
```
C:\Users\onyxt\.gradle\caches\9.0-milestone-1\transforms\4f1c7b1951cac05afb119230690e967c\metadata.bin (The system cannot find the file specified)
```

**This means corrupted Gradle cache. Here's the fix:**

### **Step 1: Close Everything**
1. **Close Android Studio completely**
2. **Close any command prompt/PowerShell windows**

### **Step 2: Clear Gradle Cache**
1. Press **`Win + R`**, type **`%USERPROFILE%\.gradle`**, press Enter
2. Delete the **entire `caches` folder**
3. If files are locked, restart your computer first

### **Step 3: Restart Fresh**
1. **Restart Android Studio**
2. **File > Open** > Select your `android` folder
3. **File > Settings > Build, Execution, Deployment > Build Tools > Gradle**
4. Set **"Gradle JDK"** to: `C:\Program Files\Eclipse Adoptium\jdk-21.0.7.6-hotspot`
5. **File > Sync Project with Gradle Files**

---

## 🚨 **PERSISTENT API ERRORS - ULTIMATE SOLUTION**

**If you're still seeing API method errors like:**
```
'org.gradle.api.file.FileCollection org.gradle.api.artifacts.Configuration.fileCollection(org.gradle.api.specs.Spec)'
```

**✅ ULTRA-STABLE CONFIGURATION APPLIED:**
- **Android Gradle Plugin**: 8.2.0 (proven stable)
- **Gradle**: 8.5 (latest stable)
- **Kotlin**: 1.9.22 (latest stable)
- **Hilt**: 2.48
- **Full cache cleanup**: Complete fresh start

**🔧 ULTIMATE TROUBLESHOOTING:**

### **Method 1: Complete Reset**
1. **Close Android Studio**
2. **Delete**: `C:\Users\onyxt\.gradle` (entire directory)
3. **Delete**: Project `.gradle` and `build` folders
4. **Restart computer** (ensures all Java processes are killed)
5. **Open Android Studio**
6. **File > Open** > Select `android` folder
7. **Use Embedded JDK** when prompted
8. **File > Sync Project with Gradle Files**

### **Method 2: Create New Project (If Method 1 Fails)**
If persistent issues continue:
1. **Create new Android project** in Android Studio
2. **Copy source files** from:
   - `app/src/main/java/` → New project
   - `app/src/main/res/` → New project
3. **Copy dependencies** from `app/build.gradle`
4. **Test sync on clean project**

---

## 🌐 **NETWORK TIMEOUT COMPREHENSIVE FIX**

**✅ GOOD NEWS**: All Gradle API compatibility issues are RESOLVED!
**Current Issue**: Network timeout during dependency download

**🔧 ENHANCED NETWORK SETTINGS APPLIED:**
- **Connection timeout**: 120 seconds (was 10 seconds)
- **Socket timeout**: 120 seconds (was 30 seconds)
- **System proxy detection**: Enabled
- **Gradle caching**: Enabled for faster subsequent builds
- **Parallel downloads**: Optimized

**📋 STEP-BY-STEP NETWORK SOLUTIONS:**

### **Solution 1: Windows Firewall (Most Likely)**
Windows Firewall is blocking Java/Gradle connections:

1. **Press `Win + R`**, type **`wf.msc`**, press Enter
2. **Click "Inbound Rules"** → **"New Rule"**
3. **Program** → Browse to: `C:\Program Files\Eclipse Adoptium\jdk-21.0.7.6-hotspot\bin\java.exe`
4. **Allow the connection** → **All profiles** → **Name**: "Java for Android Studio"
5. **Repeat for Outbound Rules**

**Alternative (Simpler):**
1. **Windows Security** → **Firewall & network protection**
2. **Allow an app through firewall**
3. **Change Settings** → **Add Java and Android Studio**

### **Solution 2: Android Studio Proxy Settings**
1. **File > Settings > Appearance & Behavior > System Settings > HTTP Proxy**
2. **Select "Auto-detect proxy settings"**
3. **Test connection** with: `https://repo1.maven.org/maven2/`
4. **Apply** and **retry sync**

### **Solution 3: DNS Issues**
Change DNS to more reliable servers:
1. **Network Settings** → **Change adapter options**
2. **Right-click your connection** → **Properties**
3. **Internet Protocol Version 4** → **Properties**
4. **Use these DNS servers**:
   - Primary: **8.8.8.8** (Google)
   - Secondary: **8.8.4.4** (Google)
5. **Restart network connection**

### **Solution 4: Temporary Offline Mode**
1. **File > Settings > Build, Execution, Deployment > Build Tools > Gradle**
2. **Check "Offline work"** (temporarily)
3. **Sync project** (will use any cached files)
4. **Uncheck "Offline work"** and retry normal sync

### **Solution 5: Manual Gradle Download**
If all else fails:
1. **Download Gradle 8.5** from: https://gradle.org/releases/
2. **Extract to**: `C:\gradle\gradle-8.5`
3. **Android Studio Settings > Build Tools > Gradle**
4. **Use local Gradle distribution**: `C:\gradle\gradle-8.5`
