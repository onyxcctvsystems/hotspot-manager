# 🚀 VS Code Server Setup for Hostinger VPS

## **This gives you a full IDE in your browser - no desktop needed!**

### **Step 1: Connect to VPS and Install VS Code Server**
```bash
# SSH to your VPS
ssh root@your-vps-ip

# Update system
sudo apt update && sudo apt upgrade -y

# Install essentials
sudo apt install -y curl wget git build-essential unzip

# Install VS Code Server
curl -fsSL https://code-server.dev/install.sh | sh

# Create config directory
mkdir -p ~/.config/code-server

# Configure VS Code Server (change password!)
cat > ~/.config/code-server/config.yaml << EOF
bind-addr: 0.0.0.0:8080
auth: password
password: YourSecurePassword123!
cert: false
EOF

# Start code-server as service
sudo systemctl enable --now code-server@$USER

# Check if it's running
sudo systemctl status code-server@$USER

# Allow port in firewall
sudo ufw allow 8080
sudo ufw --force enable
```

### **Step 2: Install Java and Android Development Tools**
```bash
# Install OpenJDK 17
sudo apt install -y openjdk-17-jdk

# Set Java environment
echo 'export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64' >> ~/.bashrc
echo 'export PATH=$PATH:$JAVA_HOME/bin' >> ~/.bashrc
source ~/.bashrc

# Verify Java
java -version
javac -version

# Install Android SDK Command Line Tools
mkdir -p ~/android-sdk/cmdline-tools
cd ~/android-sdk/cmdline-tools

# Download Android SDK Command Line Tools
wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip

# Extract
unzip commandlinetools-linux-9477386_latest.zip
mv cmdline-tools latest

# Set Android environment variables
echo 'export ANDROID_HOME=~/android-sdk' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/platform-tools' >> ~/.bashrc
source ~/.bashrc

# Accept licenses and install SDK components
yes | sdkmanager --licenses
sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"
```

### **Step 3: Transfer Your Project**

**First, complete the GitHub setup:**

**On your Windows machine:**
```powershell
# Navigate to your project directory
cd "c:\Users\onyxt\Documents\OneDrive_onyxcctv_systems\OneDrive\Hotspot Project"

# Add GitHub remote (replace YOUR_GITHUB_USERNAME with your actual username)
git remote add origin https://github.com/onyxcctvsystems/hotspot-manager.git

# Push to GitHub
git branch -M main
git push -u origin main
```

**Then on your VPS:**
```bash
# Option 1: Clone from GitHub (RECOMMENDED)
# If directory already exists, remove it first
rm -rf hotspot-manager

# Then clone fresh
git clone https://github.com/onyxcctvsystems/hotspot-manager.git
cd hotspot-manager

# Alternative: If you want to keep existing directory, use pull instead
# cd hotspot-manager
# git pull origin main

# Option 2: Using SCP from your Windows machine
# Run this on your Windows machine (PowerShell):
# scp -r "C:\Users\onyxt\Documents\OneDrive_onyxcctv_systems\OneDrive\Hotspot Project\Hotspot Mobile APP" root@your-vps-ip:/root/

# Option 3: Create project manually and copy files via VS Code Server web interface
mkdir -p ~/hotspot-project
```

### **Step 4: Access VS Code Server**
1. Open your browser and go to: `http://your-vps-ip:8080`
2. Enter the password you set in the config
3. You'll have a full VS Code IDE in your browser!

### **Step 5: Install VS Code Extensions**
In the VS Code Server web interface, install these extensions:
- **Android for VS Code** (adelphes.android-dev-ext)
- **Kotlin Language** (fwcd.kotlin)
- **Gradle for Java** (vscjava.vscode-gradle)
- **Extension Pack for Java** (vscjava.vscode-java-pack)

### **Step 6: Build Your Project**
```bash
# Navigate to the Android project (after cloning from GitHub)
cd "Hotspot Mobile APP/android"

# If gradlew is missing, create it from the wrapper
cat > gradlew << 'EOF'
#!/bin/bash
##############################################################################
##
##  Gradle start up script for UN*X
##
##############################################################################

# Add default JVM options here. You can also use JAVA_OPTS and GRADLE_OPTS to pass JVM options to this script.
DEFAULT_JVM_OPTS=""

APP_NAME="Gradle"
APP_BASE_NAME=`basename "$0"`

# Use the maximum available, or set MAX_FD != -1 to use that value.
MAX_FD="maximum"

warn ( ) {
    echo "$*"
}

die ( ) {
    echo
    echo "$*"
    echo
    exit 1
}

# OS specific support (must be 'true' or 'false').
cygwin=false
msys=false
darwin=false
case "`uname`" in
  CYGWIN* )
    cygwin=true
    ;;
  Darwin* )
    darwin=true
    ;;
  MINGW* )
    msys=true
    ;;
esac

# Attempt to set APP_HOME
# Resolve links: $0 may be a link
PRG="$0"
# Need this for relative symlinks.
while [ -h "$PRG" ] ; do
    ls=`ls -ld "$PRG"`
    link=`expr "$ls" : '.*-> \(.*\)$'`
    if expr "$link" : '/.*' > /dev/null; then
        PRG="$link"
    else
        PRG=`dirname "$PRG"`"/$link"
    fi
done
SAVED="`pwd`"
cd "`dirname \"$PRG\"`/" >/dev/null
APP_HOME="`pwd -P`"
cd "$SAVED" >/dev/null

CLASSPATH=$APP_HOME/gradle/wrapper/gradle-wrapper.jar

# Determine the Java command to use to start the JVM.
if [ -n "$JAVA_HOME" ] ; then
    if [ -x "$JAVA_HOME/jre/sh/java" ] ; then
        # IBM's JDK on AIX uses strange locations for the executables
        JAVACMD="$JAVA_HOME/jre/sh/java"
    else
        JAVACMD="$JAVA_HOME/bin/java"
    fi
    if [ ! -x "$JAVACMD" ] ; then
        die "ERROR: JAVA_HOME is set to an invalid directory: $JAVA_HOME

Please set the JAVA_HOME variable in your environment to match the
location of your Java installation."
    fi
else
    JAVACMD="java"
    which java >/dev/null 2>&1 || die "ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH.

Please set the JAVA_HOME variable in your environment to match the
location of your Java installation."
fi

# Increase the maximum file descriptors if we can.
if [ "$cygwin" = "false" -a "$darwin" = "false" ] ; then
    MAX_FD_LIMIT=`ulimit -H -n`
    if [ $? -eq 0 ] ; then
        if [ "$MAX_FD" = "maximum" -o "$MAX_FD" = "max" ] ; then
            MAX_FD="$MAX_FD_LIMIT"
        fi
        ulimit -n $MAX_FD
        if [ $? -ne 0 ] ; then
            warn "Could not set maximum file descriptor limit: $MAX_FD"
        fi
    else
        warn "Could not query maximum file descriptor limit: $MAX_FD_LIMIT"
    fi
fi

# For Darwin, add options to specify how the application appears in the dock
if [ "$darwin" = "true" ]; then
    GRADLE_OPTS="$GRADLE_OPTS \"-Xdock:name=$APP_NAME\" \"-Xdock:icon=$APP_HOME/media/gradle.icns\""
fi

# For Cygwin, switch paths to Windows format before running java
if [ "$cygwin" = "true" ] ; then
    APP_HOME=`cygpath --path --mixed "$APP_HOME"`
    CLASSPATH=`cygpath --path --mixed "$CLASSPATH"`
    JAVACMD=`cygpath --unix "$JAVACMD"`

    # We build the pattern for arguments to be converted via cygpath
    ROOTDIRSRAW=`find -L / -maxdepth 1 -mindepth 1 -type d 2>/dev/null`
    SEP=""
    for dir in $ROOTDIRSRAW ; do
        ROOTDIRS="$ROOTDIRS$SEP$dir"
        SEP="|"
    done
    OURCYGPATTERN="(^($ROOTDIRS))"
    # Add a user-defined pattern to the cygpath arguments
    if [ "$GRADLE_CYGPATTERN" != "" ] ; then
        OURCYGPATTERN="$OURCYGPATTERN|($GRADLE_CYGPATTERN)"
    fi
    # Now convert the arguments - kludge to limit ourselves to /bin/sh
    i=0
    for arg in "$@" ; do
        CHECK=`echo "$arg"|egrep -c "$OURCYGPATTERN" -`
        CHECK2=`echo "$arg"|egrep -c "^-"`                                 ### Determine if an option

        if [ $CHECK -ne 0 ] && [ $CHECK2 -eq 0 ] ; then                    ### Added a condition
            eval `echo args$i`=`cygpath --path --ignore --mixed "$arg"`
        else
            eval `echo args$i`="\"$arg\""
        fi
        i=$((i+1))
    done
    case $i in
        (0) set -- ;;
        (1) set -- "$args0" ;;
        (2) set -- "$args0" "$args1" ;;
        (3) set -- "$args0" "$args1" "$args2" ;;
        (4) set -- "$args0" "$args1" "$args2" "$args3" ;;
        (5) set -- "$args0" "$args1" "$args2" "$args3" "$args4" ;;
        (6) set -- "$args0" "$args1" "$args2" "$args3" "$args4" "$args5" ;;
        (7) set -- "$args0" "$args1" "$args2" "$args3" "$args4" "$args5" "$args6" ;;
        (8) set -- "$args0" "$args1" "$args2" "$args3" "$args4" "$args5" "$args6" "$args7" ;;
        (9) set -- "$args0" "$args1" "$args2" "$args3" "$args4" "$args5" "$args6" "$args7" "$args8" ;;
    esac
fi

# Split up the JVM_OPTS And GRADLE_OPTS values into an array, following the shell quoting and substitution rules
function splitJvmOpts() {
    JVM_OPTS=("$@")
}
eval splitJvmOpts $DEFAULT_JVM_OPTS $JAVA_OPTS $GRADLE_OPTS
JVM_OPTS[${#JVM_OPTS[*]}]="-Dorg.gradle.appname=$APP_BASE_NAME"

exec "$JAVACMD" "${JVM_OPTS[@]}" -classpath "$CLASSPATH" org.gradle.wrapper.GradleWrapperMain "$@"
EOF

# Make gradlew executable
chmod +x gradlew

# Fix settings.gradle compatibility issue
cp settings.gradle settings.gradle.bak
cat > settings.gradle << 'EOF'
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

rootProject.name = "Hotspot Manager"
include ':app'
EOF

# Test the build
./gradlew build

# If you want to build APK
./gradlew assembleDebug

# If you want to build release APK
./gradlew assembleRelease

# 🔧 QUICK FIX for Data Binding Issues
# If you get "data binding is not enabled" error, run these commands:

# 1. First, pull the latest changes from GitHub
git pull origin main

# 2. Check if data binding is enabled in build.gradle
grep -A 5 -B 5 "buildFeatures" app/build.gradle

# 3. If data binding is missing, add it manually
# Edit app/build.gradle and ensure this section exists:
# buildFeatures {
#     viewBinding true
#     dataBinding true
# }

# 4. Alternative: Run the automated fix script
# wget https://raw.githubusercontent.com/onyxcctvsystems/hotspot-manager/main/Hotspot%20Mobile%20APP/vps_build.sh
# chmod +x vps_build.sh
# ./vps_build.sh

# 5. Manual fix if needed:
cp app/build.gradle app/build.gradle.backup
sed -i '/buildFeatures {/,/}/ { /viewBinding true/a\        dataBinding true; }' app/build.gradle

# 6. Clean and rebuild
./gradlew clean
./gradlew build

# 🎉 SUCCESS! Data binding fixed! Now fix missing strings:
# If you get "string resource not found" errors, add missing strings:

# 7. Add missing string resources
cat >> app/src/main/res/values/strings.xml << 'EOF'
    
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
EOF

# 8. Fix the strings.xml file structure (remove duplicate closing tag)
sed -i '$d' app/src/main/res/values/strings.xml
echo '</resources>' >> app/src/main/res/values/strings.xml

# 9. Clean and rebuild after adding strings
./gradlew clean
./gradlew build
```

### **Step 7: Troubleshooting Build Issues**
```bash
# If you get permission errors
sudo chown -R $USER:$USER .

# If you need to clean build
./gradlew clean

# If you want verbose output
./gradlew build --info

# If you want to see all tasks
./gradlew tasks

# If you get dependency issues
./gradlew build --refresh-dependencies

# Check Gradle version
./gradlew --version

# Clean and rebuild
./gradlew clean build
```

### **Step 8: Development Workflow**
```bash
# Build and install debug APK to connected device
./gradlew installDebug

# Run tests
./gradlew test

# Generate code coverage report
./gradlew jacocoTestReport

# Lint check
./gradlew lint

# Find generated APK files
find . -name "*.apk" -type f

# APK location for debug builds
ls -la app/build/outputs/apk/debug/

# APK location for release builds
ls -la app/build/outputs/apk/release/
```

## **🎯 Alternative: GitHub Codespaces (Cloud-based)**

If the VPS setup is too complex, you can use GitHub Codespaces:

1. **Push your project to GitHub**
2. **Create a Codespace** from your repository
3. **Configure the environment** with Java and Android SDK
4. **Build and develop** entirely in the cloud

### **Codespaces Setup:**
```bash
# In your Codespace terminal
sudo apt update
sudo apt install -y openjdk-17-jdk

# Install Android SDK
mkdir -p ~/android-sdk/cmdline-tools
cd ~/android-sdk/cmdline-tools
wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
unzip commandlinetools-linux-9477386_latest.zip
mv cmdline-tools latest

# Set environment
echo 'export ANDROID_HOME=~/android-sdk' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin' >> ~/.bashrc
source ~/.bashrc

# Install SDK components
yes | sdkmanager --licenses
sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"
```

## **🎯 Alternative: DigitalOcean/AWS with Desktop**

If you need a GUI environment, consider these providers:
- **DigitalOcean Droplets** with Ubuntu Desktop
- **AWS EC2** with Ubuntu Desktop
- **Google Cloud** with Desktop environment

## **Which Option Should You Choose?**

1. **VS Code Server on Hostinger VPS** - Best for your current setup
2. **GitHub Codespaces** - Easiest, but has usage limits
3. **DigitalOcean/AWS** - Most flexible but higher cost

## **Next Steps**
1. Choose your preferred option
2. Follow the setup instructions
3. Transfer your project
4. Test the build process
5. Set up continuous integration if needed

The VS Code Server option is recommended as it works on your existing Hostinger VPS and gives you a full development environment in your browser.
