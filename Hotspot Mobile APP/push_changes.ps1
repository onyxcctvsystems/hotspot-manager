# PowerShell script to push changes to GitHub
# Run this from the android project directory

Write-Host "Pushing changes to GitHub..." -ForegroundColor Green

# Navigate to the project directory
Set-Location "c:\Users\onyxt\Documents\OneDrive_onyxcctv_systems\OneDrive\Hotspot Project\Hotspot Mobile APP"

# Add all changes
git add .

# Commit changes
git commit -m "Fix data binding configuration and Java version compatibility

- Update minSdk from 24 to 26 for better compatibility
- Update Java version from 1.8 to 17 for modern compatibility
- Add LoginActivity with proper data binding setup
- Ensure data binding is properly configured in build.gradle"

# Push to GitHub
git push origin main

Write-Host "Changes pushed successfully!" -ForegroundColor Green
Write-Host "You can now pull these changes on your VPS and build the project." -ForegroundColor Yellow
