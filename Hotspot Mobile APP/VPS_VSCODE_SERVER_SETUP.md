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
```bash
# Option 1: Using Git (if you have a repo)
git clone https://github.com/yourusername/your-project.git

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
# Navigate to your project
cd ~/hotspot-project/android

# Make gradlew executable
chmod +x gradlew

# Build the project
./gradlew build

# If you want to build APK
./gradlew assembleDebug
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
