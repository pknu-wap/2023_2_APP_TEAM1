package com.example.dailycare

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentManager
import com.example.dailycare.databinding.ActivityNaviBinding

private const val TAG_HOME = "home_fragment"
private const val TAG_MY_PAGE = "mypage_fragment"
private const val TAG_MEDICINE = "medicine_info_fragment"
private const val TAG_TIMER = "timer_fragment"
class NaviActivity : AppCompatActivity() {
    private lateinit var binding : ActivityNaviBinding
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityNaviBinding.inflate(layoutInflater)
        setContentView(binding.root)


    }

    private fun setFragment(tag: String, fragment: Fragment) {
        val manager : FragmentManager = supportFragmentManager
        val fragTransaction = manager.beginTransaction()

        if(manager.findFragmentByTag(tag) == null) {
            fragTransaction.add(R.id.mainFrameLayout, fragment, tag)
        }

        val home = manager.findFragmentByTag(TAG_HOME)
        val myPage = manager.findFragmentByTag(TAG_MY_PAGE)
        val medicine = manager.findFragmentByTag(TAG_MEDICINE)
        val timer = manager.findFragmentByTag(TAG_TIMER)

        if(home!=null) {
            fragTransaction.hide(home)
        }

        if(myPage!=null) {
            fragTransaction.hide(myPage)
        }

        if(medicine!=null) {
            fragTransaction.hide(medicine)
        }

        if(timer!=null) {
            fragTransaction.hide(timer)
        }

        if(tag== TAG_HOME) {
            if(home!=null) {
                fragTransaction.show(home)
            }
        }

        else if(tag== TAG_MEDICINE) {
            if(medicine!=null) {
                fragTransaction.show(medicine)
            }
        }

        else if(tag== TAG_MY_PAGE) {
            if(myPage!=null) {
                fragTransaction.show(myPage)
            }
        }

        else if(tag== TAG_TIMER) {
            if(timer!=null) {
                fragTransaction.show(timer)
            }
        }

    }
}