package com.onyx.hotspotmanager.data.api

import com.onyx.hotspotmanager.data.model.*
import retrofit2.Response
import retrofit2.http.*

interface ApiService {
    
    @POST("auth/login")
    suspend fun login(@Body request: LoginRequest): Response<AuthResponse>
    
    @POST("auth/register")
    suspend fun register(@Body request: RegisterRequest): Response<AuthResponse>
    
    @GET("auth/user")
    suspend fun getCurrentUser(@Header("Authorization") token: String): Response<ApiResponse<User>>
    
    @GET("dashboard")
    suspend fun getDashboardData(@Header("Authorization") token: String): Response<ApiResponse<DashboardData>>
    
    @GET("routers")
    suspend fun getRouters(@Header("Authorization") token: String): Response<ApiResponse<List<Router>>>
    
    @POST("routers")
    suspend fun addRouter(
        @Header("Authorization") token: String,
        @Body router: Router
    ): Response<ApiResponse<Router>>
    
    @PUT("routers/{id}")
    suspend fun updateRouter(
        @Header("Authorization") token: String,
        @Path("id") id: Int,
        @Body router: Router
    ): Response<ApiResponse<Router>>
    
    @DELETE("routers/{id}")
    suspend fun deleteRouter(
        @Header("Authorization") token: String,
        @Path("id") id: Int
    ): Response<ApiResponse<Any>>
    
    @GET("packages")
    suspend fun getPackages(@Header("Authorization") token: String): Response<ApiResponse<List<Package>>>
    
    @POST("packages")
    suspend fun addPackage(
        @Header("Authorization") token: String,
        @Body packageData: Package
    ): Response<ApiResponse<Package>>
    
    @PUT("packages/{id}")
    suspend fun updatePackage(
        @Header("Authorization") token: String,
        @Path("id") id: Int,
        @Body packageData: Package
    ): Response<ApiResponse<Package>>
    
    @DELETE("packages/{id}")
    suspend fun deletePackage(
        @Header("Authorization") token: String,
        @Path("id") id: Int
    ): Response<ApiResponse<Any>>
    
    @GET("vouchers")
    suspend fun getVouchers(
        @Header("Authorization") token: String,
        @Query("page") page: Int = 1,
        @Query("limit") limit: Int = 20
    ): Response<ApiResponse<List<Voucher>>>
    
    @POST("vouchers/generate")
    suspend fun generateVouchers(
        @Header("Authorization") token: String,
        @Body request: GenerateVoucherRequest
    ): Response<ApiResponse<List<Voucher>>>
    
    @DELETE("vouchers/{id}")
    suspend fun deleteVoucher(
        @Header("Authorization") token: String,
        @Path("id") id: Int
    ): Response<ApiResponse<Any>>
    
    @POST("mikrotik/test-connection")
    suspend fun testRouterConnection(
        @Header("Authorization") token: String,
        @Body router: Router
    ): Response<ApiResponse<Boolean>>
    
    @GET("mikrotik/active-users/{routerId}")
    suspend fun getActiveUsers(
        @Header("Authorization") token: String,
        @Path("routerId") routerId: Int
    ): Response<ApiResponse<List<ActiveUser>>>
}

data class GenerateVoucherRequest(
    val packageId: Int,
    val routerId: Int,
    val quantity: Int,
    val prefix: String = "HSM"
)

data class ActiveUser(
    val username: String,
    val ipAddress: String,
    val macAddress: String,
    val uptime: String,
    val bytesIn: Long,
    val bytesOut: Long
)
