# 🔐 GitHub Authentication Setup Guide

## **Issue: GitHub Password Authentication Removed**
GitHub removed password authentication on August 13, 2021. You need to use a Personal Access Token (PAT) instead.

## **Option 1: Personal Access Token (Recommended)**

### **Step 1: Create a Personal Access Token**
1. Go to [GitHub Settings → Developer settings → Personal access tokens](https://github.com/settings/tokens)
2. Click "**Generate new token**" → "**Generate new token (classic)**"
3. Give it a descriptive name: `Hotspot Manager VPS Development`
4. Select the following scopes:
   - ✅ `repo` (Full repository access)
   - ✅ `workflow` (Update GitHub Actions workflows)
   - ✅ `write:packages` (Upload packages)
   - ✅ `read:packages` (Download packages)
5. Click "**Generate token**"
6. **IMPORTANT**: Copy the token immediately and save it securely!

### **Step 2: Use Token Instead of Password**
When prompted for credentials:
- **Username**: `onyxcctvsystems@gmail.com`
- **Password**: `your_personal_access_token` (paste the token here)

### **Step 3: Configure Git to Cache Credentials**
```bash
# Cache credentials for 1 hour (3600 seconds)
git config --global credential.helper 'cache --timeout=3600'

# Or store credentials permanently (less secure)
git config --global credential.helper store
```

## **Option 2: SSH Keys (More Secure)**

### **Step 1: Generate SSH Key**
```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "onyxcctvsystems@gmail.com"

# Start SSH agent
eval "$(ssh-agent -s)"

# Add SSH key to agent
ssh-add ~/.ssh/id_ed25519

# Copy public key to clipboard
cat ~/.ssh/id_ed25519.pub
```

### **Step 2: Add SSH Key to GitHub**
1. Go to [GitHub Settings → SSH and GPG keys](https://github.com/settings/keys)
2. Click "**New SSH key**"
3. Title: `Hotspot Manager Development`
4. Paste your public key
5. Click "**Add SSH key**"

### **Step 3: Update Remote URL to SSH**
```bash
# Change remote URL to SSH
git remote set-url origin git@github.com:onyxcctvsystems/hotspot-manager.git

# Test connection
ssh -T git@github.com
```

## **Option 3: GitHub CLI (Easiest)**

### **Step 1: Install GitHub CLI**
```powershell
# Install via winget
winget install --id GitHub.cli

# Or download from https://cli.github.com/
```

### **Step 2: Authenticate**
```bash
# Login to GitHub
gh auth login

# Follow the prompts to authenticate via browser
```

### **Step 3: Clone/Push with GitHub CLI**
```bash
# Clone repository
gh repo clone onyxcctvsystems/hotspot-manager

# Or push changes
gh repo sync
```

## **Quick Fix for Current Session**

### **Immediate Solution**
1. **Generate a Personal Access Token** (steps above)
2. **Try the push command again**:
   ```bash
   git push origin main
   ```
3. **When prompted**:
   - Username: `onyxcctvsystems@gmail.com`
   - Password: `your_personal_access_token`

### **Alternative: Use HTTPS with Token in URL**
```bash
# Add remote with token embedded (less secure)
git remote set-url origin https://onyxcctvsystems:YOUR_TOKEN@github.com/onyxcctvsystems/hotspot-manager.git

# Then push
git push origin main
```

## **Security Best Practices**
1. **Never share your Personal Access Token**
2. **Set appropriate token permissions** (only what you need)
3. **Set token expiration** (90 days max recommended)
4. **Use SSH keys for long-term development**
5. **Regenerate tokens periodically**

## **Next Steps After Authentication**
Once authentication is fixed, continue with:
```bash
# Push your changes
git push origin main

# Then proceed with VPS setup
ssh root@your-vps-ip
cd ~/hotspot-manager
git pull origin main
cd android
./vps_complete_build_verification.sh
```

---

**Choose the option that works best for you. Personal Access Token is the quickest solution for immediate needs.**
