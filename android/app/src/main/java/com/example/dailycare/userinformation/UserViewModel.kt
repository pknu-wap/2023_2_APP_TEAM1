package com.example.dailycare.userinformation

import android.app.Application
import androidx.fragment.app.FragmentActivity
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.ViewModelStoreOwner
import com.example.dailycare.MainActivity
import com.example.dailycare.networks.DrugInfo
import com.example.dailycare.networks.Item
import com.example.dailycare.networks.MedicineInfoViewModel

class UserViewModel(application: Application): AndroidViewModel(application) {
    private val userInformation = UserInformation(application)
    private val userDiseaseList = mutableMapOf<String, Item>()
    private var currentDisease = ""
    private lateinit var medicineInfoViewModel : MedicineInfoViewModel


    fun getUserInformation() = userInformation
    fun getUserDiseaseList() = userDiseaseList

    fun setUserDiseaseList(name: String) {
        userDiseaseList.put(name, medicineInfoViewModel.getApiDataFromRetrofit(name))
    }

    fun setMedicineInfoViewModel(fragment: FragmentActivity) {
        medicineInfoViewModel = ViewModelProvider(fragment).get(MedicineInfoViewModel::class.java)
    }
    fun setCurrentDisease(name: String) {
        currentDisease = name
    }

    fun getCurrentDisease() :String = currentDisease
}