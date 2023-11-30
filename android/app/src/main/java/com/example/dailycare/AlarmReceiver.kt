package com.example.dailycare

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import android.widget.Toast

class AlarmReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context?, intent: Intent?) {
        if(intent != null) {
            Toast.makeText(context, "Ringing!", Toast.LENGTH_SHORT).show()
        }
    }

}