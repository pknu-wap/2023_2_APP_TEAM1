package com.example.dailycare.timerset

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.DatePicker
import android.widget.EditText
import android.widget.TimePicker
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import com.example.dailycare.R
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Locale

class CalendarFragment : Fragment() {
    private lateinit var datePicker: DatePicker
    private lateinit var timePicker: TimePicker
    private lateinit var timerEditText: EditText
    private lateinit var setTimerButton: Button
    private lateinit var sharedViewModel: SharedViewModel

    // Method to set the OnTimerSetListener
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        sharedViewModel = ViewModelProvider(requireActivity()).get(SharedViewModel::class.java)
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val view = inflater.inflate(R.layout.fragment_calendar, container, false)

        // Initialize views
        datePicker = view.findViewById(R.id.datePicker)
        timePicker = view.findViewById(R.id.timePicker)
        timerEditText = view.findViewById(R.id.timerEditText)
        setTimerButton = view.findViewById(R.id.setTimerButton)

        // Set click listener for the Set Timer Button
        setTimerButton.setOnClickListener {
            // Get selected date from DatePicker
            val year = datePicker.year
            val month = datePicker.month
            val day = datePicker.dayOfMonth

            // Get selected time from TimePicker
            val hour = timePicker.hour
            val minute = timePicker.minute

            // Combine date and time to create a Calendar instance
            val calendar = Calendar.getInstance()
            calendar.set(year, month, day, hour, minute)

            // Get the timer value from the EditText
            val timerValue = timerEditText.text.toString()

            sharedViewModel.setSelectedDateTime(calendar, timerValue)


            val fragmentManager = requireActivity().supportFragmentManager
            val fragmentTransaction = fragmentManager.beginTransaction()
            val newFragment = TimerFragment()
            fragmentTransaction.replace(R.id.fragment_container, newFragment)
            //fragmentManager.popBackStack();
            fragmentTransaction.commit()
        }

        return view
    }

    private fun setAlarm(dateTime: Calendar, alarmMessage: String) {
        val alarmManager =
            requireContext().getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val alarmIntent = Intent(context, AlarmReceiver::class.java)
        val packageManager: PackageManager = requireContext().packageManager

        // requestCode를 일반적으로는 고유한 값으로 설정해야 합니다.
        val requestCode = 123 // 예시로 정의된 값을 사용했으니 필요에 따라 변경하세요.
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            requestCode,
            alarmIntent,
            PendingIntent.FLAG_CANCEL_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        // 알람을 설정하는 시간을 밀리초로 계산
        val alarmTimeInMillis = dateTime.timeInMillis

        // 알람 설정
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            try {
                val canScheduleExactAlarms = alarmManager.canScheduleExactAlarms()
                if (canScheduleExactAlarms) {
                    alarmManager.setExactAndAllowWhileIdle(
                        AlarmManager.RTC_WAKEUP,
                        alarmTimeInMillis,
                        pendingIntent
                    )

                    // 텍스트뷰에 알람 정보 설정

                } else {
                    // 정확한 알람 예약이 허용되지 않은 경우 처리
                    Toast.makeText(requireContext(), "Alarm is not permited", Toast.LENGTH_SHORT).show()
                    val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
                    val uri: Uri = Uri.fromParts("package", requireContext().packageName, null)
                    intent.data = uri
                    startActivity(intent)
                }
            } catch (e: SecurityException) {
                // SecurityException 처리
                Toast.makeText(requireContext(), "Error: $e", Toast.LENGTH_SHORT).show()
            }
        } else {
            // Android 11 (API 레벨 30) 이하의 기기에 대한 처리
            alarmManager.setExact(
                AlarmManager.RTC_WAKEUP,
                alarmTimeInMillis,
                pendingIntent
            )
        }
        val formattedTime =
            SimpleDateFormat("yyyy-MM-dd HH:mm", Locale.getDefault()).format(dateTime.time)
        // 알람이 설정되었다고 사용자에게 알림
        Toast.makeText(
            requireContext(),
            "Alarm set for $formattedTime\ncontext: $alarmMessage",
            Toast.LENGTH_SHORT
        ).show()

    }

}