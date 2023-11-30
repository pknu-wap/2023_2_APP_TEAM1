package com.example.dailycare.timerset

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
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageButton
import android.widget.LinearLayout
import android.widget.TextView
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentManager
import androidx.fragment.app.FragmentTransaction
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProvider
import com.example.dailycare.R
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Locale

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

        })
        alarmMessage = sharedViewModel.getAlarmMessage()
        if(alarmMessage != "" || formattedTime != "") {
            // TextView를 동적으로 생성하고 설정
            val textView = TextView(context)
            textView.text = "$formattedTime\n$alarmMessage"

            textView.setTextSize(TypedValue.COMPLEX_UNIT_SP,25f)

            val customTypeface =
                Typeface.createFromAsset(context?.assets, "HedvigLettersSans-Regular.ttf")
            textView.typeface = customTypeface

            textView.setTextColor(Color.BLACK)
            textView.setBackgroundResource(R.drawable.boarded_background)  // 배경색상을 블루로 지정, 필요에 따라 수정하세요.
            textView.setPadding(16, 16, 16, 16)  // 패딩 설정, 필요에 따라 수정하세요.
            textView.layoutParams = ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            )
            //textView.setBackgroundResource(R.drawable.rounded_rectangle)

            // alarm_box에 TextView 추가
            val alarmBox = view?.findViewById<LinearLayout>(R.id.alarm_box)
            alarmBox?.addView(textView)
        }
    }
}