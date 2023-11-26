package com.example.dailycare

import android.content.Context
import android.content.SharedPreferences
import android.os.UserManager
import com.google.firebase.auth.UserInfo
import java.io.Serializable

class UserInformation constructor(private val context: Context) {
    private val sharedPreferences: SharedPreferences =
        context.getSharedPreferences(USER_PREFS, Context.MODE_PRIVATE)

    var userName: String?
        get() = sharedPreferences.getString(KEY_USERNAME, null)
        set(value) = sharedPreferences.edit().putString(KEY_USERNAME, value).apply()
    var email: String?
        get() = sharedPreferences.getString(KEY_USEREMAIL, null)
        set(value) = sharedPreferences.edit().putString(KEY_USEREMAIL, value).apply()

    companion object {
        private const val USER_PREFS = "user_prefs"
        private const val KEY_USERNAME = "username"
        private const val KEY_USEREMAIL = "useremail"

        @Volatile
        private var instance : UserInformation? = null

        fun getInstance(context: Context): UserInformation {
            return instance?: synchronized(this) {
                instance?: buildInstance(context).also { instance = it }
            }
        }

        private fun buildInstance(context: Context) : UserInformation {
            return UserInformation(context.applicationContext)
        }
    }
}