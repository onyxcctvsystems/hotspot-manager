package com.onyx.hotspotmanager.ui.viewmodel

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.onyx.hotspotmanager.data.model.AuthData
import com.onyx.hotspotmanager.data.model.OrganizationRequest
import com.onyx.hotspotmanager.data.repository.MainRepository
import com.onyx.hotspotmanager.util.Resource
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class AuthViewModel @Inject constructor(
    private val repository: MainRepository
) : ViewModel() {

    private val _loginResult = MutableLiveData<Resource<AuthData>>()
    val loginResult: LiveData<Resource<AuthData>> = _loginResult

    private val _registerResult = MutableLiveData<Resource<AuthData>>()
    val registerResult: LiveData<Resource<AuthData>> = _registerResult

    fun login(email: String, password: String) {
        viewModelScope.launch {
            _loginResult.value = Resource.Loading()
            _loginResult.value = repository.login(email, password)
        }
    }

    fun register(
        email: String,
        password: String,
        name: String,
        organizationName: String,
        businessType: String,
        address: String,
        phone: String,
        orgEmail: String
    ) {
        viewModelScope.launch {
            _registerResult.value = Resource.Loading()
            val organization = OrganizationRequest(
                name = organizationName,
                businessType = businessType,
                address = address,
                phone = phone,
                email = orgEmail
            )
            _registerResult.value = repository.register(email, password, name, organization)
        }
    }

    fun logout() {
        repository.logout()
    }
}
