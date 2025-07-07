# Copilot Instructions for Hotspot Management Application

<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

## Project Overview
This is an Android mobile application for managing Mikrotik hotspot services with a multi-tenant architecture.

## Key Technologies
- **Frontend**: Android (Kotlin/Java) with Material Design
- **Backend**: PHP with MySQL database
- **Router Integration**: Mikrotik RouterOS API
- **Architecture**: Multi-tenant SaaS application
- **Authentication**: Organization-based user management

## Project Structure
- `android/` - Android application source code
- `backend/` - PHP API backend
- `database/` - MySQL schema and migration scripts
- `docs/` - Documentation and API references

## Development Guidelines
- Use Material Design components for consistent UI
- Implement proper error handling for API calls
- Follow MVVM architecture pattern for Android
- Use dependency injection with Dagger/Hilt
- Implement proper authentication and authorization
- Follow multi-tenant data isolation patterns

## API Integration
- Mikrotik RouterOS API for router management
- RESTful PHP backend for business logic
- JWT tokens for secure authentication
- Proper error handling and retry mechanisms

## Security Considerations
- Multi-tenant data isolation
- Secure API key management
- Input validation and sanitization
- Encrypted local storage for sensitive data
