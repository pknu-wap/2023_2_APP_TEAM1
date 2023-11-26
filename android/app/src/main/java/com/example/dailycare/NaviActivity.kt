package com.example.dailycare

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentManager
import androidx.navigation.fragment.NavHostFragment
import androidx.navigation.ui.NavigationUI
import com.example.dailycare.databinding.ActivityNaviBinding

private const val TAG_HOME = "home_fragment"
private const val TAG_MY_PAGE = "mypage_fragment"
private const val TAG_MEDICINE = "medicine_info_fragment"
private const val TAG_TIMER = "timer_fragment"

class NaviActivity : AppCompatActivity() {
    private lateinit var binding: ActivityNaviBinding
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityNaviBinding.inflate(layoutInflater)
        setContentView(binding.root)

        val navHostFragment =
            supportFragmentManager.findFragmentById(R.id.nav_host_fragment) as NavHostFragment
        val navController = navHostFragment.navController
        NavigationUI.setupWithNavController(binding.bottomNavigationView, navController)
    }
}