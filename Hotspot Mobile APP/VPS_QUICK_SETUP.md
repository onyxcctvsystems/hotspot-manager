# 🔧 VPS Quick Setup Commands

## Copy-Paste Command Blocks for VPS Setup

### **Block 1: Initial System Setup**
```bash
# Update system and install essentials
sudo apt update && sudo apt upgrade -y
sudo apt install -y wget curl git unzip software-properties-common build-essential

# Create development user
sudo adduser developer
sudo usermod -aG sudo developer
```

### **Block 2: Install Java 17**
```bash
# Install OpenJDK 17
sudo apt install -y openjdk-17-jdk

# Configure Java environment
echo 'export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64' >> ~/.bashrc
echo 'export PATH=$PATH:$JAVA_HOME/bin' >> ~/.bashrc
source ~/.bashrc

# Verify Java installation
java -version
```

### **Block 3: Install Desktop Environment**
```bash
# Install XFCE (lightweight desktop)
sudo apt install -y xfce4 xfce4-goodies
sudo apt install -y xrdp
sudo systemctl enable xrdp
sudo systemctl start xrdp

# Configure firewall
sudo ufw enable
sudo ufw allow 3389
sudo ufw allow 22
sudo ufw allow 80
sudo ufw allow 8080
```

### **Block 4: Download and Install Android Studio**
```bash
# Download Android Studio
cd /tmp
wget https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2023.3.1.18/android-studio-2023.3.1.18-linux.tar.gz

# Extract and install
sudo tar -xzf android-studio-*.tar.gz -C /opt/
sudo chown -R $USER:$USER /opt/android-studio/

# Create Android SDK directory
mkdir -p ~/Android/Sdk
```

### **Block 5: Configure Android Environment**
```bash
# Set Android environment variables
cat >> ~/.bashrc << EOF
export ANDROID_HOME=~/Android/Sdk
export PATH=\$PATH:\$ANDROID_HOME/emulator
export PATH=\$PATH:\$ANDROID_HOME/tools
export PATH=\$PATH:\$ANDROID_HOME/tools/bin
export PATH=\$PATH:\$ANDROID_HOME/platform-tools
EOF

source ~/.bashrc
```

### **Block 6: Setup Remote Desktop**
```bash
# Configure RDP for XFCE
echo "xfce4-session" > ~/.xsession
sudo systemctl restart xrdp

# Set password for RDP access
sudo passwd $USER
```

### **Block 7: Performance Optimization**
```bash
# Add swap space for heavy builds
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

### **Block 8: Install Additional Tools**
```bash
# Install Node.js and build tools
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
sudo apt install -y android-tools-adb android-tools-fastboot
```

## 📱 **After VPS Setup: Connect and Launch**

### **Remote Desktop Connection:**
1. **Windows**: Use "Remote Desktop Connection"
2. **Computer**: `your-vps-ip:3389`
3. **Username**: `developer`
4. **Password**: (password you set)

### **Launch Android Studio:**
```bash
# In VPS terminal or after RDP connection
/opt/android-studio/bin/studio.sh
```

## 🚀 **Project Transfer Options**

### **Option A: Git Clone (Recommended)**
```bash
# If you have a Git repository
git clone https://github.com/your-username/your-repo.git

# If you need to create a new repo from your local files
# First, push your local project to GitHub/GitLab
# Then clone it on the VPS
```

### **Option B: Direct Upload via SCP**
```bash
# From your Windows machine (using PowerShell or Git Bash)
scp -r "C:\Users\onyxt\Documents\OneDrive_onyxcctv_systems\OneDrive\Hotspot Project\Hotspot Mobile APP" developer@your-vps-ip:/home/developer/
```

### **Option C: Web File Manager**
```bash
# Install web-based file manager on VPS
sudo apt install -y apache2 php libapache2-mod-php
cd /var/www/html
sudo wget https://raw.githubusercontent.com/prasathmani/tinyfilemanager/master/tinyfilemanager.php
sudo chown -R www-data:www-data /var/www/html/

# Access via: http://your-vps-ip/tinyfilemanager.php
# Default: admin / admin@123
```

## ⚡ **Quick Benefits of VPS Development**

| Issue | Local Machine | VPS Solution |
|-------|---------------|--------------|
| Java PATH problems | ❌ Complex setup | ✅ Clean Java 17 install |
| Gradle compatibility | ❌ Version conflicts | ✅ Fresh environment |
| Windows Firewall | ❌ Blocks connections | ✅ No Windows issues |
| Network timeouts | ❌ Corporate/ISP limits | ✅ Data center connectivity |
| Cache corruption | ❌ Hard to diagnose | ✅ Fresh start anytime |
| Dependencies | ❌ Local conflicts | ✅ Isolated environment |

## 💰 **Cost-Effective VPS Options**

### **Hostinger VPS Plans:**
- **VPS 4**: 8GB RAM, 4 vCPU, 160GB - ~$20/month
- **VPS 8**: 16GB RAM, 8 vCPU, 320GB - ~$35/month

### **Alternative Providers:**
- **DigitalOcean**: $40-80/month for 8-16GB
- **Vultr**: $30-60/month for 8-16GB
- **Linode**: $40-80/month for 8-16GB

## 🎯 **Ready to Start?**

1. **Purchase VPS** (Hostinger 8GB+ recommended)
2. **Run setup commands** (blocks 1-8 above)
3. **Connect via Remote Desktop**
4. **Transfer your project**
5. **Start developing** without any local issues!

**This eliminates ALL your current development problems!** 🚀
