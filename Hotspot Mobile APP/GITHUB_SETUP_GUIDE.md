# 🚀 GitHub Setup Guide

## **Step 1: Create GitHub Repository**

1. **Go to GitHub.com** and sign in to your account
2. **Click "New"** (green button) or go to https://github.com/new
3. **Repository name**: `hotspot-manager` or `mikrotik-hotspot-manager`
4. **Description**: "Multi-tenant Android app for managing Mikrotik hotspot services"
5. **Public/Private**: Choose Public (recommended for easier access)
6. **Initialize repository**: Leave ALL checkboxes UNCHECKED
7. **Click "Create repository"**

## **Step 2: Connect Your Local Project to GitHub**

**Copy and paste these commands in PowerShell (one by one):**

```powershell
# Navigate to your project
cd "c:\Users\onyxt\Documents\OneDrive_onyxcctv_systems\OneDrive\Hotspot Project"

# Add GitHub remote - REPLACE YOUR_GITHUB_USERNAME with your actual username
git remote add origin https://github.com/YOUR_GITHUB_USERNAME/hotspot-manager.git

# Rename branch to main
git branch -M main

# Push to GitHub
git push -u origin main
```

**Example**: If your GitHub username is `johnsmith`, the command would be:
```powershell
git remote add origin https://github.com/johnsmith/hotspot-manager.git
```

## **Step 3: Get Your Clone Command**

After pushing to GitHub, your clone command will be:
```bash
git clone https://github.com/YOUR_GITHUB_USERNAME/hotspot-manager.git
```

## **Step 4: Use This Command on Your VPS**

**On your VPS (after setting up VS Code Server):**
```bash
# Clone your project
git clone https://github.com/YOUR_GITHUB_USERNAME/hotspot-manager.git

# Navigate to the Android project
cd hotspot-manager/Hotspot\ Mobile\ APP/android

# Make gradlew executable
chmod +x gradlew

# Build the project
./gradlew build
```

## **🎯 Quick Action Items:**

1. **Create GitHub repository** (5 minutes)
2. **Run the PowerShell commands** above (2 minutes)
3. **Copy the correct clone command** for your VPS
4. **Continue with VPS setup** using VS Code Server

## **Need Help?**

If you get stuck at any step, let me know:
- Your GitHub username
- Any error messages you see
- Which step you're on

The key is replacing `YOUR_GITHUB_USERNAME` with your actual GitHub username in all the commands!
