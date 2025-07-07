package com.onyx.hotspotmanager.util

object Constants {
    const val BASE_URL = "http://10.0.2.2/hotspot-api/api/"  // For Android emulator
    // const val BASE_URL = "http://192.168.88.188/hotspot-api/api/"  // For real device - replace with your local IP
    
    const val PREFS_NAME = "hotspot_prefs"
    const val KEY_TOKEN = "auth_token"
    const val KEY_USER_ID = "user_id"
    const val KEY_ORGANIZATION_ID = "organization_id"
    const val KEY_USER_NAME = "user_name"
    const val KEY_USER_EMAIL = "user_email"
    const val KEY_ORGANIZATION_NAME = "organization_name"
    
    const val MIKROTIK_DEFAULT_PORT = 8728
    const val VOUCHER_USERNAME_LENGTH = 8
    const val VOUCHER_PASSWORD_LENGTH = 8
}

sealed class Resource<T>(
    val data: T? = null,
    val message: String? = null
) {
    class Success<T>(data: T) : Resource<T>(data)
    class Error<T>(message: String, data: T? = null) : Resource<T>(data, message)
    class Loading<T>(data: T? = null) : Resource<T>(data)
}
