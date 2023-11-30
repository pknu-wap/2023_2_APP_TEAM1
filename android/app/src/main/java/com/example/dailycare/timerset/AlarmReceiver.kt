package com.example.dailycare.timerset

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import android.widget.Toast

class AlarmReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context?, intent: Intent?) {
        if(intent != null) {
            Toast.makeText(context, "ring", Toast.LENGTH_SHORT).show()
            val vib = context?.getSystemService(Context.VIBRATOR_SERVICE) as Vibrator

            if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val vibrationEffect =
                    VibrationEffect.createOneShot(1000, VibrationEffect.DEFAULT_AMPLITUDE)
                vib.vibrate(vibrationEffect)
            } else {
                // 안드로이드 Oreo 미만에서는 deprecated된 메소드 사용
                vib.vibrate(1000)
            }

        }
    }

}