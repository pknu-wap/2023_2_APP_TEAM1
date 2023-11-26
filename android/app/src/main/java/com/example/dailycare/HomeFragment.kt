package com.example.dailycare

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.AdapterView
import android.widget.ArrayAdapter
import android.widget.DatePicker
import androidx.fragment.app.setFragmentResultListener
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import com.example.dailycare.databinding.ActivityNaviBinding
import com.example.dailycare.databinding.FragmentHomeBinding
import com.google.android.gms.common.internal.ResourceUtils

class HomeFragment : Fragment() {
    private lateinit var binding: FragmentHomeBinding
    private lateinit var adapter: RecyclerViewAdapter
    private var diseaseData = mutableListOf("-선택하세요-", "독감", "A형 간염", "허리디스크")
    private var user = ""
    private val mDatas = mutableListOf<WarningRecyclerViewItemStateData>()
    private val checklistDatas = mutableListOf<checklistRecyclerViewItemState>()
    private lateinit var userViewModel : UserViewModel

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        binding = FragmentHomeBinding.inflate(inflater, container, false)
        userViewModel = ViewModelProvider(requireActivity()).get(UserViewModel::class.java)
        user = userViewModel.getUserInformation().userName.toString()

        initWarningItem()
        initChecklistItem()
        // 만약 새로운 금지사항을 생성한다면 appendDataToWarning() 을 실행한다.

        setSpinner()
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        setFragmentResultListener("request") {
            key, bundle->
            bundle.getString("valueKey")?.let {
                binding.usernameTextView.setText("${user}님")
            }
        }

    }

    private fun appendDataToWarning() {
        with(mDatas) {
            add(WarningRecyclerViewItemStateData("씻기 금지", "2023.11.20"))
        }
    }

    private fun appendDataToChecklist() {
        with(checklistDatas) {
            add(checklistRecyclerViewItemState("2023-11-25 병원 방문하기", "2023.11.20"))
        }
    }

    fun setSpinner() {
        binding.spinner.onItemSelectedListener = object: AdapterView.OnItemSelectedListener {
            override fun onItemSelected(
                parent: AdapterView<*>?,
                view: View?,
                position: Int,
                id: Long
            ) {
                // 선택하면 그에 맞는 현재 상황을 보여주기
            }
            override fun onNothingSelected(parent: AdapterView<*>?) { }
        }
    }

    fun initWarningItem() {
        val adapter = RecyclerViewAdapter()
        adapter.dataItems = mDatas
        binding.warningRecyclerView.adapter=adapter
        binding.warningRecyclerView.layoutManager=LinearLayoutManager(requireContext(), LinearLayoutManager.HORIZONTAL, false)
        appendDataToWarning()
        appendDataToWarning()
        appendDataToWarning()
    }

    fun initChecklistItem() {
        val adapter = RecyclerViewChecklistAdapter()
        adapter.checklistDataItems = checklistDatas
        binding.checklistRecyclerView.adapter = adapter
        binding.checklistRecyclerView.layoutManager=LinearLayoutManager(requireContext(), LinearLayoutManager.HORIZONTAL, false)
        appendDataToChecklist()
    }
    
//    fun initDiseaseData() {
//        diseaseData.add("-선택하세요-")
//    }

    fun setData(disease : String) {
        diseaseData.add(disease)
    }

    // fun getDiseaseData() = diseaseData

}