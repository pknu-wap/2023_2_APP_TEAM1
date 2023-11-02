package com.example.dailycare

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.AdapterView
import android.widget.ArrayAdapter
import androidx.fragment.app.setFragmentResultListener
import com.example.dailycare.databinding.ActivityNaviBinding
import com.example.dailycare.databinding.FragmentHomeBinding

class HomeFragment : Fragment() {
    lateinit var binding: FragmentHomeBinding
    lateinit var diseaseData : MutableList<String>
    lateinit var user : String

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
                binding.textView.setText("${user}님")
            }
        }

        setSpinner()
    }

    fun setSpinner() {
        binding.spinner.onItemSelectedListener = object: AdapterView.OnItemSelectedListener {
            override fun onItemSelected(
                parent: AdapterView<*>?,
                view: View?,
                position: Int,
                id: Long
            ) {
                binding.textView.text = diseaseData.get(position)
            }

            override fun onNothingSelected(parent: AdapterView<*>?) {

            }
        }
    }

    fun initDiseaseData() {
        diseaseData.add("-선택하세요-")
    }

    fun setData(disease : String) {
        diseaseData.add(disease)
    }

    fun getDiseaseData() = diseaseData

}