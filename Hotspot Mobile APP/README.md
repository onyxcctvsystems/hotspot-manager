# Hotspot Manager - Android Application

A comprehensive Android mobile application for managing Mikrotik hotspot services with multi-tenant architecture.

## 🚀 Features

- **Multi-tenant Architecture**: Organization-based user management
- **Router Management**: Connect and manage multiple Mikrotik routers
- **Package Management**: Create and manage internet packages/profiles
- **Voucher Generation**: Generate and manage user vouchers
- **Dashboard Analytics**: Real-time statistics and revenue tracking
- **User Authentication**: Secure login and registration system
- **Material Design UI**: Modern and intuitive user interface

## 🏗️ Architecture

- **Frontend**: Android (Kotlin) with MVVM architecture
- **Backend**: PHP REST API with MySQL database
- **Router Integration**: Mikrotik RouterOS API
- **Authentication**: JWT token-based authentication
- **Database**: MySQL with multi-tenant data isolation

## 📱 Android Project Structure

```
android/
├── app/
│   ├── src/main/java/com/onyx/hotspotmanager/
│   │   ├── data/
│   │   │   ├── api/           # API interfaces
│   │   │   ├── model/         # Data models
│   │   │   └── repository/    # Data repositories
│   │   ├── di/                # Dependency injection
│   │   ├── ui/
│   │   │   ├── activity/      # Activities
│   │   │   ├── fragment/      # Fragments
│   │   │   └── viewmodel/     # ViewModels
│   │   └── util/              # Utility classes
│   └── src/main/res/          # Resources (layouts, drawables, etc.)
└── build.gradle
```

## 🔧 Backend Structure

```
backend/
├── api/
│   ├── auth.php              # Authentication endpoints
│   ├── dashboard.php         # Dashboard data
│   ├── routers.php           # Router management
│   ├── packages.php          # Package management
│   ├── vouchers.php          # Voucher management
│   └── mikrotik.php          # Mikrotik API integration
├── config/
│   └── database.php          # Database configuration
└── classes/
    ├── Router.php            # Router class
    ├── Package.php           # Package class
    └── MikrotikAPI.php       # Mikrotik API wrapper
```

## 📋 Prerequisites

### Development Environment
- Android Studio Arctic Fox or later
- JDK 8 or higher
- Android SDK API 24 or higher

### Server Requirements
- XAMPP/WAMP/LAMP server
- PHP 7.4 or higher
- MySQL 5.7 or higher
- Apache/Nginx web server

### Hardware Requirements
- Mikrotik router with API access enabled
- Network connectivity between server and router

## 🚀 Installation & Setup

### 1. Database Setup

1. Start your MySQL server
2. Open MySQL Workbench or phpMyAdmin
3. Import the database schema:
   ```sql
   mysql -u root -p < database/schema.sql
   ```

### 2. Backend Setup

1. Copy the `backend` folder to your web server directory (e.g., `htdocs` for XAMPP)
2. Update database credentials in `backend/config/database.php`:
   ```php
   private $host = 'localhost';
   private $db_name = 'hotspot_manager';
   private $username = 'root';
   private $password = 'your_password';
   ```

3. Ensure your web server is running and accessible

### 3. Android App Setup

1. Open Android Studio
2. Open the `android` project folder
3. Update the API base URL in `Constants.kt`:
   ```kotlin
   const val BASE_URL = "http://your-server-ip/hotspot-api/"
   ```

4. Sync project and build

### 4. Mikrotik Router Setup

1. Enable API access on your Mikrotik router:
   ```
   /ip service enable api
   /ip service set api port=8728
   ```

2. Create a user with API access:
   ```
   /user add name=apiuser password=apipass group=full
   ```

## 📱 App Usage

### 1. Registration
- First-time users need to register with organization details
- The app creates both user account and organization profile
- Admin role is automatically assigned to the first user

### 2. Router Management
- Add routers by providing IP, username, password, and port
- Test connectivity before saving
- Monitor router status and location

### 3. Package Creation
- Define internet packages with speed and data limits
- Set pricing and duration for each package
- Packages are organization-specific

### 4. Voucher Generation
- Generate vouchers in bulk for specific packages
- Assign vouchers to specific routers
- Track voucher usage and status

### 5. Dashboard
- View real-time statistics
- Monitor revenue and active connections
- Track router and voucher status

## 🔐 Security Features

- JWT token-based authentication
- Encrypted shared preferences for sensitive data
- Multi-tenant data isolation
- Input validation and sanitization
- Secure API communication

## 🛠️ Development

### Key Dependencies

```gradle
// Network & API
implementation 'com.squareup.retrofit2:retrofit:2.9.0'
implementation 'com.squareup.retrofit2:converter-gson:2.9.0'

// Dependency Injection
implementation 'com.google.dagger:hilt-android:2.48'

// UI Components
implementation 'com.google.android.material:material:1.11.0'
implementation 'androidx.navigation:navigation-compose:2.7.6'

// Architecture Components
implementation 'androidx.lifecycle:lifecycle-viewmodel-compose:2.7.0'
implementation 'androidx.room:room-runtime:2.6.1'
```

### API Endpoints

- `POST /auth/login` - User authentication
- `POST /auth/register` - User registration
- `GET /dashboard` - Dashboard data
- `GET /routers` - List routers
- `POST /routers` - Add router
- `GET /packages` - List packages
- `POST /vouchers/generate` - Generate vouchers

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 Support

For support and questions, please contact:
- Email: support@onyxsystems.com
- Documentation: [Project Wiki](link-to-wiki)

## 🔄 Version History

- **v1.0.0** - Initial release with core features
- Basic authentication and organization management
- Router and package management
- Voucher generation and tracking
- Dashboard with analytics

---

Made with ❤️ by Onyx Systems
