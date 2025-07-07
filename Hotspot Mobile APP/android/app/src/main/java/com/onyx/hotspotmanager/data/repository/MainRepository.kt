package com.onyx.hotspotmanager.data.repository

import android.content.Context
import android.content.SharedPreferences
import androidx.security.crypto.EncryptedSharedPreferences
import androidx.security.crypto.MasterKey
import com.onyx.hotspotmanager.data.api.ApiService
import com.onyx.hotspotmanager.data.model.*
import com.onyx.hotspotmanager.util.Constants
import com.onyx.hotspotmanager.util.Resource
import dagger.hilt.android.qualifiers.ApplicationContext
import retrofit2.Response
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class MainRepository @Inject constructor(
    private val apiService: ApiService,
    @ApplicationContext private val context: Context
) {

    private val sharedPreferences: SharedPreferences by lazy {
        val masterKey = MasterKey.Builder(context)
            .setKeyScheme(MasterKey.KeyScheme.AES256_GCM)
            .build()

        EncryptedSharedPreferences.create(
            context,
            Constants.PREFS_NAME,
            masterKey,
            EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
            EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
        )
    }

    // Authentication
    suspend fun login(email: String, password: String): Resource<AuthData> {
        return try {
            val response = apiService.login(LoginRequest(email, password))
            if (response.isSuccessful && response.body()?.success == true) {
                val authData = response.body()?.data
                authData?.let { saveAuthData(it) }
                Resource.Success(authData!!)
            } else {
                Resource.Error(response.body()?.message ?: "Login failed")
            }
        } catch (e: Exception) {
            Resource.Error(e.message ?: "Network error")
        }
    }

    suspend fun register(
        email: String,
        password: String,
        name: String,
        organization: OrganizationRequest
    ): Resource<AuthData> {
        return try {
            val request = RegisterRequest(email, password, name, organization)
            val response = apiService.register(request)
            if (response.isSuccessful && response.body()?.success == true) {
                val authData = response.body()?.data
                authData?.let { saveAuthData(it) }
                Resource.Success(authData!!)
            } else {
                Resource.Error(response.body()?.message ?: "Registration failed")
            }
        } catch (e: Exception) {
            Resource.Error(e.message ?: "Network error")
        }
    }

    // Dashboard
    suspend fun getDashboardData(): Resource<DashboardData> {
        return safeApiCall { apiService.getDashboardData(getAuthHeader()) }
    }

    // Routers
    suspend fun getRouters(): Resource<List<Router>> {
        return safeApiCall { apiService.getRouters(getAuthHeader()) }
    }

    suspend fun addRouter(router: Router): Resource<Router> {
        return safeApiCall { apiService.addRouter(getAuthHeader(), router) }
    }

    suspend fun updateRouter(id: Int, router: Router): Resource<Router> {
        return safeApiCall { apiService.updateRouter(getAuthHeader(), id, router) }
    }

    suspend fun deleteRouter(id: Int): Resource<Any> {
        return safeApiCall { apiService.deleteRouter(getAuthHeader(), id) }
    }

    // Packages
    suspend fun getPackages(): Resource<List<Package>> {
        return safeApiCall { apiService.getPackages(getAuthHeader()) }
    }

    suspend fun addPackage(packageData: Package): Resource<Package> {
        return safeApiCall { apiService.addPackage(getAuthHeader(), packageData) }
    }

    suspend fun updatePackage(id: Int, packageData: Package): Resource<Package> {
        return safeApiCall { apiService.updatePackage(getAuthHeader(), id, packageData) }
    }

    suspend fun deletePackage(id: Int): Resource<Any> {
        return safeApiCall { apiService.deletePackage(getAuthHeader(), id) }
    }

    // Vouchers
    suspend fun getVouchers(page: Int = 1, limit: Int = 20): Resource<List<Voucher>> {
        return safeApiCall { apiService.getVouchers(getAuthHeader(), page, limit) }
    }

    suspend fun generateVouchers(request: GenerateVoucherRequest): Resource<List<Voucher>> {
        return safeApiCall { apiService.generateVouchers(getAuthHeader(), request) }
    }

    suspend fun deleteVoucher(id: Int): Resource<Any> {
        return safeApiCall { apiService.deleteVoucher(getAuthHeader(), id) }
    }

    // Mikrotik
    suspend fun testRouterConnection(router: Router): Resource<Boolean> {
        return safeApiCall { apiService.testRouterConnection(getAuthHeader(), router) }
    }

    suspend fun getActiveUsers(routerId: Int): Resource<List<ActiveUser>> {
        return safeApiCall { apiService.getActiveUsers(getAuthHeader(), routerId) }
    }

    // Helper functions
    private fun saveAuthData(authData: AuthData) {
        with(sharedPreferences.edit()) {
            putString(Constants.KEY_TOKEN, authData.token)
            putInt(Constants.KEY_USER_ID, authData.user.id)
            putInt(Constants.KEY_ORGANIZATION_ID, authData.user.organizationId)
            putString(Constants.KEY_USER_NAME, authData.user.name)
            putString(Constants.KEY_USER_EMAIL, authData.user.email)
            putString(Constants.KEY_ORGANIZATION_NAME, authData.organization.name)
            apply()
        }
    }

    fun getAuthToken(): String? {
        return sharedPreferences.getString(Constants.KEY_TOKEN, null)
    }

    fun isLoggedIn(): Boolean {
        return getAuthToken() != null
    }

    fun logout() {
        sharedPreferences.edit().clear().apply()
    }

    private fun getAuthHeader(): String {
        return "Bearer ${getAuthToken()}"
    }

    private suspend fun <T> safeApiCall(apiCall: suspend () -> Response<ApiResponse<T>>): Resource<T> {
        return try {
            val response = apiCall()
            if (response.isSuccessful && response.body()?.success == true) {
                Resource.Success(response.body()?.data!!)
            } else {
                Resource.Error(response.body()?.message ?: "API call failed")
            }
        } catch (e: Exception) {
            Resource.Error(e.message ?: "Network error")
        }
    }
}
