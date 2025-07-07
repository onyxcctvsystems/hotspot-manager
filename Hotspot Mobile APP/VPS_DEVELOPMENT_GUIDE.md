# 🚀 VPS Android Development Setup Guide

## Overview
This guide will help you set up a complete Android development environment on a Hostinger VPS, eliminating all local machine issues with Java, Gradle, and network connectivity.

## 🖥️ **Phase 1: VPS Setup & Selection**

### **Recommended VPS Specifications:**
- **RAM**: Minimum 8GB (16GB recommended for Android Studio)
- **Storage**: 100GB+ SSD 
- **CPU**: 4+ cores
- **OS**: Ubuntu 22.04 LTS
- **Location**: Choose closest to your location for best performance

### **Hostinger VPS Plans Suitable for Development:**
- **VPS Plan 4**: 8GB RAM, 4 vCPU, 160GB NVMe - **Minimum**
- **VPS Plan 8**: 16GB RAM, 8 vCPU, 320GB NVMe - **Recommended**

## 📦 **Phase 2: Initial VPS Configuration**

### **Step 1: Connect to Your VPS**
```bash
# Use Hostinger's provided SSH credentials
ssh root@your-vps-ip-address
```

### **Step 2: Update System**
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y wget curl git unzip software-properties-common
```

### **Step 3: Create Development User**
```bash
# Create a development user (recommended for security)
sudo adduser developer
sudo usermod -aG sudo developer
sudo su - developer
```

## ☕ **Phase 3: Install Java Development Kit**

### **Install OpenJDK 17 (Recommended for Android)**
```bash
sudo apt install -y openjdk-17-jdk

# Verify installation
java -version
javac -version

# Set JAVA_HOME
echo 'export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64' >> ~/.bashrc
echo 'export PATH=$PATH:$JAVA_HOME/bin' >> ~/.bashrc
source ~/.bashrc
```

## 🐧 **Phase 4: Install Desktop Environment (GUI)**

### **Option A: Lightweight XFCE (Recommended)**
```bash
sudo apt install -y xfce4 xfce4-goodies
sudo apt install -y xrdp
sudo systemctl enable xrdp
sudo systemctl start xrdp

# Configure firewall for RDP
sudo ufw allow 3389
```

### **Option B: GNOME (More Resource Intensive)**
```bash
sudo apt install -y ubuntu-desktop-minimal
sudo apt install -y xrdp
sudo systemctl enable xrdp
sudo systemctl start xrdp
sudo ufw allow 3389
```

## 📱 **Phase 5: Install Android Studio**

### **Step 1: Download Android Studio**
```bash
cd /tmp
wget https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2023.3.1.18/android-studio-2023.3.1.18-linux.tar.gz

# Extract to /opt
sudo tar -xzf android-studio-*.tar.gz -C /opt/
sudo chown -R developer:developer /opt/android-studio/

# Create desktop shortcut
mkdir -p ~/Desktop
cat > ~/Desktop/android-studio.desktop << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Android Studio
Icon=/opt/android-studio/bin/studio.png
Exec=/opt/android-studio/bin/studio.sh
Categories=Development;IDE;
EOF

chmod +x ~/Desktop/android-studio.desktop
```

### **Step 2: Install Android SDK**
```bash
# Create Android SDK directory
mkdir -p ~/Android/Sdk

# Set environment variables
echo 'export ANDROID_HOME=~/Android/Sdk' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/emulator' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/tools' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/tools/bin' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/platform-tools' >> ~/.bashrc
source ~/.bashrc
```

## 🌐 **Phase 6: Setup Remote Desktop Access**

### **Step 1: Configure Remote Desktop**
```bash
# Set RDP user password
sudo passwd developer

# Configure xrdp for XFCE
echo "xfce4-session" > ~/.xsession
sudo systemctl restart xrdp
```

### **Step 2: Connect from Windows**
1. **Open Remote Desktop Connection** on your Windows machine
2. **Computer**: `your-vps-ip-address:3389`
3. **Username**: `developer`
4. **Password**: (password you set)

## 📂 **Phase 7: Transfer Your Project**

### **Option A: Using Git (Recommended)**
```bash
# Install Git and clone your project
cd ~/
git clone https://github.com/your-username/hotspot-manager.git
# OR create new repository and push your local code
```

### **Option B: Using SCP/SFTP**
```bash
# From your local Windows machine
scp -r "C:\Users\onyxt\Documents\OneDrive_onyxcctv_systems\OneDrive\Hotspot Project\Hotspot Mobile APP" developer@your-vps-ip:/home/developer/
```

### **Option C: Upload via Web Interface**
```bash
# Install web-based file manager
sudo apt install -y apache2 php libapache2-mod-php
sudo systemctl enable apache2
sudo systemctl start apache2

# Install file manager (Tiny File Manager)
cd /var/www/html
sudo wget https://tinyfilemanager.github.io/master.zip
sudo unzip master.zip
sudo chown -R www-data:www-data /var/www/html/
sudo ufw allow 80

# Access via: http://your-vps-ip/tinyfilemanager.php
# Default login: admin/admin@123
```

## 🛠️ **Phase 8: Configure Development Environment**

### **Step 1: Install Additional Tools**
```bash
# Install Node.js (for potential web components)
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Install build tools
sudo apt install -y build-essential

# Install ADB platform tools
sudo apt install -y android-tools-adb android-tools-fastboot
```

### **Step 2: Setup Android Studio**
1. **Connect via Remote Desktop**
2. **Launch Android Studio**: `/opt/android-studio/bin/studio.sh`
3. **Complete setup wizard**
4. **Install SDK components**:
   - Android SDK Platform-Tools
   - Android SDK Build-Tools
   - Android Emulator
   - System Images (for emulator)

## 🔥 **Phase 9: Setup Project in VPS**

### **Step 1: Open Your Project**
```bash
# Launch Android Studio
/opt/android-studio/bin/studio.sh

# In Android Studio:
# File > Open > Navigate to your project folder
```

### **Step 2: Configure Gradle**
Your VPS will have:
- ✅ **Clean Java 17 installation**
- ✅ **Fresh Gradle cache**
- ✅ **No Windows firewall issues**
- ✅ **Stable network connectivity**
- ✅ **No corporate proxy issues**

## 💻 **Phase 10: Development Workflow**

### **Daily Development Process:**
1. **Connect to VPS** via Remote Desktop
2. **Launch Android Studio**
3. **Develop your Android app**
4. **Test on VPS emulator** or **connected device**
5. **Commit to Git** for backup

### **Performance Optimization:**
```bash
# Increase swap space for heavy builds
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# Optimize Android Studio memory
echo 'export STUDIO_VM_OPTIONS="-Xmx4g -XX:MaxPermSize=512m"' >> ~/.bashrc
```

## 🔧 **Alternative: VS Code Remote Development**

### **If You Prefer VS Code:**
```bash
# Install VS Code Server
curl -fsSL https://code-server.dev/install.sh | sh
sudo systemctl enable --now code-server@developer

# Configure code-server
mkdir -p ~/.config/code-server
cat > ~/.config/code-server/config.yaml << EOF
bind-addr: 0.0.0.0:8080
auth: password
password: your-secure-password
cert: false
EOF

# Allow port 8080
sudo ufw allow 8080

# Access via: http://your-vps-ip:8080
```

## 📱 **Testing Options**

### **Option 1: Android Emulator on VPS**
- **Pros**: Everything in one place
- **Cons**: Requires GPU acceleration setup

### **Option 2: USB Debugging with Local Device**
- **Pros**: Real device testing
- **Cons**: Need USB redirection or wireless ADB

### **Option 3: Wireless ADB**
```bash
# Enable wireless debugging on your local Android device
# Connect to same network or use VPN
adb connect your-phone-ip:5555
```

## 💰 **Cost Estimation**

### **Monthly VPS Costs (Hostinger):**
- **8GB RAM VPS**: ~$15-25/month
- **16GB RAM VPS**: ~$30-45/month

### **Benefits vs Local Development:**
- ✅ **No local environment issues**
- ✅ **24/7 availability**
- ✅ **Better performance** (if VPS has good specs)
- ✅ **Consistent environment**
- ✅ **Easy collaboration**
- ✅ **Automatic backups** (with Git)

## 🎯 **Next Steps**

1. **Purchase Hostinger VPS** (8GB+ RAM recommended)
2. **Follow this guide step by step**
3. **Transfer your project**
4. **Continue development without local issues**

This setup eliminates all your current problems:
- ❌ No Java PATH issues
- ❌ No Gradle compatibility problems  
- ❌ No Windows firewall blocking
- ❌ No network timeout issues
- ❌ No cache corruption

**Ready to proceed with VPS setup?** 🚀
