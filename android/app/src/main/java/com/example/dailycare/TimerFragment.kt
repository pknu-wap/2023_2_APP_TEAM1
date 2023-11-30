//TimerFragment
package com.example.dailycare

import CalendarFragment
import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Color
import android.graphics.Typeface
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.util.TypedValue
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.WindowManager
import android.widget.ImageButton
import android.widget.LinearLayout
import android.widget.TextView
import android.widget.Toast
import androidx.fragment.app.FragmentManager
import androidx.fragment.app.FragmentTransaction
import androidx.fragment.app.setFragmentResultListener
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProvider
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Locale

// TODO: Rename parameter arguments, choose names that match
// the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
private const val ARG_PARAM1 = "param1"
private const val ARG_PARAM2 = "param2"

/**
 * A simple [Fragment] subclass.
 * Use the [TimerFragment.newInstance] factory method to
 * create an instance of this fragment.
 */

class TimerFragment : Fragment() {
    private lateinit var sharedViewModel: SharedViewModel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        sharedViewModel = ViewModelProvider(requireActivity()).get(SharedViewModel::class.java)

    }





    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {


        val view = inflater.inflate(R.layout.fragment_timer, container, false)

        // 'plusButton' 클릭 이벤트 처리
        val plusButton: ImageButton = view.findViewById(R.id.plusButton)
        plusButton.setOnClickListener {
            // 새로운 프래그먼트로 이동하는 코드
            val fragmentManager: FragmentManager = requireActivity().supportFragmentManager
            val fragmentTransaction: FragmentTransaction = fragmentManager.beginTransaction()

            val newFragment = CalendarFragment() // CalendarFragment의 인스턴스를 생성
            fragmentTransaction.replace(R.id.timer_fragment_container, newFragment)
            fragmentTransaction.addToBackStack(null)
            fragmentTransaction.commit()
        }
        return view
    }
    private var formattedTime: String = ""
    private var alarmMessage: String = ""
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        sharedViewModel.getSelectedDateTime().observe(viewLifecycleOwner, Observer { dateTime ->
            formattedTime =
                SimpleDateFormat("yyyy-MM-dd HH:mm", Locale.getDefault()).format(dateTime.time)
            alarmMessage = sharedViewModel.getAlarmMessage()

            setAlarm(dateTime, alarmMessage)
        })
    }

    private val textViewList = mutableListOf<TextView>()
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

                    // TextView를 동적으로 생성하고 설정
                    val textView = TextView(context)
                    textView.text = "$formattedTime\n$alarmMessage"

                    textView.setTextSize(TypedValue.COMPLEX_UNIT_SP,30f)

                    val customTypeface = Typeface.createFromAsset(context?.assets,"HedvigLettersSans-Regular.ttf")
                    textView.typeface = customTypeface

                    textView.setTextColor(Color.BLACK)
                    textView.setBackgroundResource(R.drawable.bordered_background)  // 배경색상을 블루로 지정, 필요에 따라 수정하세요.
                    textView.setPadding(16, 16, 16, 16)  // 패딩 설정, 필요에 따라 수정하세요.
                    textView.layoutParams = ViewGroup.LayoutParams(
                        ViewGroup.LayoutParams.MATCH_PARENT,
                        ViewGroup.LayoutParams.WRAP_CONTENT
                    )
                    //textView.setBackgroundResource(R.drawable.rounded_rectangle)

                    // alarm_box에 TextView 추가
                    val alarmBox = view?.findViewById<LinearLayout>(R.id.alarm_box)

                    alarmBox?.addView(textView)


                    // 텍스트뷰에 알람 정보 설정

                } else {
                    // 정확한 알람 예약이 허용되지 않은 경우 처리
                    //Toast.makeText(requireContext(), "Alarm is not permited", Toast.LENGTH_SHORT).show()
                    val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
                    val uri: Uri = Uri.fromParts("package", requireContext().packageName,null)
                    intent.data = uri
                    startActivity(intent)
                }
            } catch (e: SecurityException) {
                // SecurityException 처리
                //Toast.makeText(requireContext(), "Error: $e", Toast.LENGTH_SHORT).show()
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
        Toast.makeText(requireContext(), "Alarm set for $formattedTime\ncontext: $alarmMessage", Toast.LENGTH_SHORT).show()
    }


}
