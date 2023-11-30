package com.example.dailycare.timerset

import androidx.lifecycle.ViewModel
import java.util.Calendar

class CalendarViewModel : ViewModel() {
    // Properties for selected date and time
    var selectedDate: Calendar = Calendar.getInstance()
    var selectedTime: Calendar = Calendar.getInstance()

    // Property for timer text
    var timerText: String = ""

    // Method to handle "Set Timer" button click
    fun onSetTimerButtonClick() {
        // Perform any additional logic needed when the button is clicked
        // For example, you might want to use the selectedDate, selectedTime, and timerText properties
    }
}