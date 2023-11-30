package com.example.dailycare

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import java.util.Calendar

class SharedViewModel : ViewModel() {
    private val selectedDateTime = MutableLiveData<Calendar>()
    private var alarmMessage : String = ""
    fun setSelectedDateTime(dateTime: Calendar, massage: String) {
        selectedDateTime.value = dateTime
        alarmMessage = massage
    }
    fun getSelectedDateTime(): LiveData<Calendar> {
        return selectedDateTime
    }

    fun getAlarmMessage(): String{
        return alarmMessage
    }
}
