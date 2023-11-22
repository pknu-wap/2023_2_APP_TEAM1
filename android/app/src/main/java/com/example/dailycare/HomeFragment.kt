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
import androidx.recyclerview.widget.LinearLayoutManager
import com.example.dailycare.databinding.ActivityNaviBinding
import com.example.dailycare.databinding.FragmentHomeBinding

class HomeFragment : Fragment() {
    private lateinit var binding: FragmentHomeBinding
    private lateinit var adapter: RecyclerViewAdapter
    private var diseaseData = mutableListOf<String>()
    private var user = ""
    private val mDatas = mutableListOf<WarningRecyclerViewItemStateData>()

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        binding = FragmentHomeBinding.inflate(inflater, container, false)
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

        initWarningRecyclerView()
        appendDataToWarning()

        setSpinner()
    }

    private fun appendDataToWarning() {
        with(mDatas) {
            add(WarningRecyclerViewItemStateData("씻기 금지", "2023.11.20"))
        }
    }

    fun setSpinner() {
        initDiseaseData()
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

    fun initWarningRecyclerView() {
        val adapter = RecyclerViewAdapter()
        adapter.dataItems = mDatas
        binding.warningRecyclerView.adapter=adapter
        binding.warningRecyclerView.layoutManager=LinearLayoutManager(requireContext())
    }
    
    fun initDiseaseData() {
        diseaseData.add("-선택하세요-")
    }

    fun setData(disease : String) {
        diseaseData.add(disease)
    }

    // fun getDiseaseData() = diseaseData

}