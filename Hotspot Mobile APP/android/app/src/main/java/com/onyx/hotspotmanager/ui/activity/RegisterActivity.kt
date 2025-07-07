package com.onyx.hotspotmanager.ui.activity

import android.content.Intent
import android.os.Bundle
import android.widget.Toast
import androidx.activity.viewModels
import androidx.appcompat.app.AppCompatActivity
import androidx.databinding.DataBindingUtil
import com.onyx.hotspotmanager.R
import com.onyx.hotspotmanager.databinding.ActivityRegisterBinding
import com.onyx.hotspotmanager.ui.viewmodel.AuthViewModel
import com.onyx.hotspotmanager.util.Resource
import dagger.hilt.android.AndroidEntryPoint

@AndroidEntryPoint
class RegisterActivity : AppCompatActivity() {

    private lateinit var binding: ActivityRegisterBinding
    private val viewModel: AuthViewModel by viewModels()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = DataBindingUtil.setContentView(this, R.layout.activity_register)
        
        setupObservers()
        setupClickListeners()
    }

    private fun setupObservers() {
        viewModel.registerResult.observe(this) { result ->
            when (result) {
                is Resource.Loading -> {
                    binding.btnRegister.isEnabled = false
                    binding.btnRegister.text = "Registering..."
                }
                is Resource.Success -> {
                    binding.btnRegister.isEnabled = true
                    binding.btnRegister.text = "Register"
                    Toast.makeText(this, "Registration successful", Toast.LENGTH_SHORT).show()
                    startActivity(Intent(this, MainActivity::class.java))
                    finish()
                }
                is Resource.Error -> {
                    binding.btnRegister.isEnabled = true
                    binding.btnRegister.text = "Register"
                    Toast.makeText(this, result.message, Toast.LENGTH_LONG).show()
                }
            }
        }
    }

    private fun setupClickListeners() {
        binding.btnRegister.setOnClickListener {
            val email = binding.etEmail.text.toString().trim()
            val password = binding.etPassword.text.toString().trim()
            val confirmPassword = binding.etConfirmPassword.text.toString().trim()
            val name = binding.etName.text.toString().trim()
            val organizationName = binding.etOrganizationName.text.toString().trim()
            val businessType = binding.etBusinessType.text.toString().trim()
            val address = binding.etAddress.text.toString().trim()
            val phone = binding.etPhone.text.toString().trim()
            val orgEmail = binding.etOrganizationEmail.text.toString().trim()
            
            if (validateInput(email, password, confirmPassword, name, organizationName, businessType, address, phone, orgEmail)) {
                viewModel.register(email, password, name, organizationName, businessType, address, phone, orgEmail)
            }
        }

        binding.tvLogin.setOnClickListener {
            finish()
        }
    }

    private fun validateInput(
        email: String,
        password: String,
        confirmPassword: String,
        name: String,
        organizationName: String,
        businessType: String,
        address: String,
        phone: String,
        orgEmail: String
    ): Boolean {
        if (email.isEmpty()) {
            binding.etEmail.error = "Email is required"
            return false
        }
        if (!android.util.Patterns.EMAIL_ADDRESS.matcher(email).matches()) {
            binding.etEmail.error = "Please enter a valid email"
            return false
        }
        if (password.isEmpty()) {
            binding.etPassword.error = "Password is required"
            return false
        }
        if (password.length < 6) {
            binding.etPassword.error = "Password must be at least 6 characters"
            return false
        }
        if (confirmPassword != password) {
            binding.etConfirmPassword.error = "Passwords do not match"
            return false
        }
        if (name.isEmpty()) {
            binding.etName.error = "Name is required"
            return false
        }
        if (organizationName.isEmpty()) {
            binding.etOrganizationName.error = "Organization name is required"
            return false
        }
        if (businessType.isEmpty()) {
            binding.etBusinessType.error = "Business type is required"
            return false
        }
        if (address.isEmpty()) {
            binding.etAddress.error = "Address is required"
            return false
        }
        if (phone.isEmpty()) {
            binding.etPhone.error = "Phone is required"
            return false
        }
        if (orgEmail.isEmpty()) {
            binding.etOrganizationEmail.error = "Organization email is required"
            return false
        }
        if (!android.util.Patterns.EMAIL_ADDRESS.matcher(orgEmail).matches()) {
            binding.etOrganizationEmail.error = "Please enter a valid organization email"
            return false
        }
        return true
    }
}
