package com.example.dailycare

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import com.example.dailycare.UserInformation

class UserViewModel(application: Application): AndroidViewModel(application) {
    private val userInformation = UserInformation(application)

    fun getUserInformation() = userInformation
}