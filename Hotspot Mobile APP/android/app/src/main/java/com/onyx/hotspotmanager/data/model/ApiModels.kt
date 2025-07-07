package com.onyx.hotspotmanager.data.model

import com.google.gson.annotations.SerializedName

data class LoginRequest(
    @SerializedName("email")
    val email: String,
    @SerializedName("password")
    val password: String
)

data class RegisterRequest(
    @SerializedName("email")
    val email: String,
    @SerializedName("password")
    val password: String,
    @SerializedName("name")
    val name: String,
    @SerializedName("organization")
    val organization: OrganizationRequest
)

data class OrganizationRequest(
    @SerializedName("name")
    val name: String,
    @SerializedName("business_type")
    val businessType: String,
    @SerializedName("address")
    val address: String,
    @SerializedName("phone")
    val phone: String,
    @SerializedName("email")
    val email: String
)

data class AuthResponse(
    @SerializedName("success")
    val success: Boolean,
    @SerializedName("message")
    val message: String,
    @SerializedName("data")
    val data: AuthData?
)

data class AuthData(
    @SerializedName("user")
    val user: User,
    @SerializedName("organization")
    val organization: Organization,
    @SerializedName("token")
    val token: String
)

data class ApiResponse<T>(
    @SerializedName("success")
    val success: Boolean,
    @SerializedName("message")
    val message: String,
    @SerializedName("data")
    val data: T?
)

data class DashboardData(
    @SerializedName("total_routers")
    val totalRouters: Int,
    @SerializedName("active_routers")
    val activeRouters: Int,
    @SerializedName("total_vouchers")
    val totalVouchers: Int,
    @SerializedName("active_vouchers")
    val activeVouchers: Int,
    @SerializedName("total_packages")
    val totalPackages: Int,
    @SerializedName("revenue_today")
    val revenueToday: Double,
    @SerializedName("revenue_month")
    val revenueMonth: Double
)
