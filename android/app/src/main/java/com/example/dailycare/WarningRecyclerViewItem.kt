package com.example.dailycare

import android.graphics.drawable.Drawable

class WarningRecyclerViewItem {
    private lateinit var iconDrawble: Drawable
    private lateinit var warningTitle: String
    private lateinit var warningTime: String

    fun setIcon(icon: Drawable) {
        iconDrawble = icon
    }
    fun setWarningTitle(title:String) {
        warningTitle = title
    }
    fun setWarningTime(time: String) {
        warningTime = time;
    }
}