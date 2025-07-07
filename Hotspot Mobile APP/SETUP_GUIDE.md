# Hotspot Manager - Complete Setup Guide

This guide will walk you through setting up the complete Hotspot Management system from scratch.

## 📋 Prerequisites Checklist

### Software Requirements
- [ ] Android Studio (Latest version)
- [ ] XAMPP/WAMP/LAMP server
- [ ] MySQL Workbench
- [ ] Mikrotik RouterOS device

### Network Requirements
- [ ] Computer connected to same network as Mikrotik router
- [ ] Mikrotik router with API access enabled
- [ ] Stable internet connection

## 🔧 Step 1: Database Setup

### 1.1 Start MySQL Server
1. Open XAMPP Control Panel
2. Start Apache and MySQL services
3. Verify both services are running (green status)

### 1.2 Create Database
1. Open your web browser
2. Go to `http://localhost/phpmyadmin`
3. Click "New" to create a new database
4. Name it `hotspot_manager`
5. Click "Create"

### 1.3 Import Database Schema
1. Select the `hotspot_manager` database
2. Click "Import" tab
3. Choose file: `database/schema.sql`
4. Click "Go" to import

**Expected Result:** Database created with all tables and sample data

## 🌐 Step 2: Backend Setup

### 2.1 Copy Backend Files
1. Navigate to your XAMPP installation folder
2. Open the `htdocs` directory
3. Create a new folder called `hotspot-api`
4. Copy all files from `backend/` folder to `htdocs/hotspot-api/`

### 2.2 Configure Database Connection
1. Open `htdocs/hotspot-api/config/database.php`
2. Update the database credentials:
```php
private $host = 'localhost';
private $db_name = 'hotspot_manager';
private $username = 'root';
private $password = ''; // Your MySQL password (empty for XAMPP default)
```

### 2.3 Test Backend API
1. Open browser and go to: `http://localhost/hotspot-api/api/auth.php`
2. You should see: `{"message":"Method not allowed"}`
3. This confirms the API is accessible

**Expected Result:** Backend API is accessible and database connection is working

## 📱 Step 3: Android App Setup

### 3.1 Open Project in Android Studio
1. Open Android Studio
2. Select "Open an existing project"
3. Navigate to the `android/` folder in your project
4. Click "OK" to open the project

### 3.2 Configure API URL
1. Open `app/src/main/java/com/onyx/hotspotmanager/util/Constants.kt`
2. Update the BASE_URL:
   - For Android Emulator: `http://10.0.2.2/hotspot-api/api/`
   - For Real Device: `http://YOUR_COMPUTER_IP/hotspot-api/api/`

### 3.3 Find Your Computer's IP Address
**Windows:**
```cmd
ipconfig
```
Look for "IPv4 Address" under your network adapter (usually starts with 192.168.x.x)

**Example:** If your IP is 192.168.1.100, use:
```kotlin
const val BASE_URL = "http://192.168.1.100/hotspot-api/api/"
```

### 3.4 Sync and Build Project
1. Click "Sync Now" when prompted
2. Wait for Gradle sync to complete
3. Build the project: `Build > Make Project`

**Expected Result:** Project builds successfully without errors

## 🔌 Step 4: Mikrotik Router Setup

### 4.1 Enable API Access
1. Connect to your Mikrotik router (Winbox, Webfig, or SSH)
2. Run these commands:
```
/ip service enable api
/ip service set api port=8728
```

### 4.2 Create API User
1. Create a new user for API access:
```
/user add name=hotspot-api password=your-secure-password group=full
```

### 4.3 Configure Hotspot (if not already set up)
1. Set up hotspot server:
```
/ip hotspot setup
```
2. Follow the wizard to configure your hotspot

**Expected Result:** Mikrotik router is ready for API connections

## 🚀 Step 5: Testing the Complete System

### 5.1 Test Database Connection
1. Open browser: `http://localhost/phpmyadmin`
2. Verify `hotspot_manager` database exists
3. Check that tables are created (users, organizations, routers, etc.)

### 5.2 Test Backend API
1. Use a tool like Postman or curl
2. Test login endpoint:
```bash
curl -X POST http://localhost/hotspot-api/api/auth.php \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@demo.com","password":"password"}'
```

### 5.3 Test Android App
1. Run the app on emulator or device
2. Register a new account with organization details
3. Verify successful registration and login

### 5.4 Test Router Connection
1. In the app, navigate to "Routers"
2. Add a new router with your Mikrotik details:
   - Name: "Test Router"
   - IP Address: Your router's IP
   - Username: "hotspot-api"
   - Password: Your secure password
   - Port: 8728
3. Test the connection

**Expected Result:** All components working together successfully

## 🔍 Troubleshooting

### Common Issues and Solutions

#### Database Connection Error
- **Problem:** "Connection error" in backend
- **Solution:** 
  - Check MySQL service is running
  - Verify database credentials in `database.php`
  - Ensure database exists

#### API Not Accessible
- **Problem:** Android app can't reach API
- **Solution:**
  - Check Apache service is running
  - Verify correct IP address in Constants.kt
  - Test API URL in browser first

#### Router Connection Failed
- **Problem:** Can't connect to Mikrotik router
- **Solution:**
  - Verify API service is enabled on router
  - Check IP address and credentials
  - Ensure router is reachable from your computer

#### App Build Errors
- **Problem:** Android project won't build
- **Solution:**
  - Ensure Java is installed and in PATH
  - Check internet connection for dependencies
  - In Android Studio: File > Invalidate Caches and Restart
  - Clean and rebuild project
  - Update Android Studio if needed

#### Gradle Sync Issues
- **Problem:** "Sync Now" not appearing or Gradle sync failing
- **Solution:**
  - Restart Android Studio
  - File > Sync Project with Gradle Files
  - Check internet connection
  - Clear Gradle cache: `%USERPROFILE%\.gradle\caches`

#### Java Not Found Error
- **Problem:** "'java' is not recognized as an internal or external command"
- **Solution:**
  - Install Java Development Kit (JDK) 8 or higher
  - Add Java to system PATH
  - Restart Android Studio after Java installation

## 📊 Step 6: Production Deployment

### 6.1 Security Considerations
1. Change default passwords
2. Use HTTPS for production
3. Implement proper JWT secret key
4. Configure firewall rules

### 6.2 Server Deployment
1. Upload backend files to web server
2. Configure SSL certificate
3. Update database credentials
4. Test all endpoints

### 6.3 App Distribution
1. Generate signed APK
2. Test on multiple devices
3. Publish to Google Play Store (optional)

## 📞 Support

If you encounter any issues:
1. Check the troubleshooting section above
2. Verify all prerequisites are met
3. Test each component individually
4. Contact support with specific error messages

## 🎉 Success Checklist

- [ ] Database created and accessible
- [ ] Backend API responding correctly
- [ ] Android app builds and runs
- [ ] Mikrotik router API enabled
- [ ] Registration and login working
- [ ] Router connection successful
- [ ] All main features functional

**Congratulations! Your Hotspot Management System is now ready to use.**

---

**Next Steps:**
- Add your routers to the system
- Create internet packages
- Generate vouchers for customers
- Monitor usage through the dashboard
