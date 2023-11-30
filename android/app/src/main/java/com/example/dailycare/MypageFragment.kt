package com.example.dailycare

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.activity.addCallback
import androidx.lifecycle.ViewModelProvider
import com.example.dailycare.databinding.FragmentMypageBinding
import com.example.dailycare.userinformation.UserViewModel

class MypageFragment : Fragment() {
    private lateinit var binding: FragmentMypageBinding
    private lateinit var userViewModel: UserViewModel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        binding = FragmentMypageBinding.inflate(inflater, container, false)
        userViewModel = ViewModelProvider(requireActivity()).get(UserViewModel::class.java)

        userInformationReady()
        userViewModel.setMedicineInfoViewModel(requireActivity())
        binding.bugFixRequestTextView.setOnClickListener {

        }

        binding.watchMyRecordTextView.setOnClickListener {
            callPastInformation()
        }

        binding.mypageBackImageview.setOnClickListener {
            val callback = requireActivity().onBackPressedDispatcher.addCallback(this) {

            }

        }

        return binding.root
    }

    private fun userInformationReady() {
        binding.userNameTextView.text = userViewModel.getUserInformation().userName
        binding.userEmailTextView.text = userViewModel.getUserInformation().email
    }

    private fun callPastInformation() {

    }

}