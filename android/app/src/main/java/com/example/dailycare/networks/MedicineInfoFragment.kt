package com.example.dailycare.networks

import android.os.Bundle
import android.util.Log
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.appcompat.widget.SearchView
import androidx.fragment.app.FragmentTransaction
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.navigation.fragment.findNavController
import com.example.dailycare.R
import com.example.dailycare.databinding.FragmentHomeBinding
import com.example.dailycare.databinding.FragmentMedicineInfoBinding
import com.example.dailycare.userinformation.UserViewModel
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import retrofit2.Retrofit

class MedicineInfoFragment : Fragment() {
    private lateinit var binding: FragmentMedicineInfoBinding
    private lateinit var retrofit: DrugAPI
    private lateinit var userViewModel: UserViewModel
    private lateinit var medicineInfoViewModel: MedicineInfoViewModel
    private val adapter = RecyclerViewDrugInfoAdapter()
    private val TAG = "MedicineInfoFragment"
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        binding = FragmentMedicineInfoBinding.inflate(inflater, container, false)
        userViewModel = ViewModelProvider(requireActivity()).get(UserViewModel::class.java)
        medicineInfoViewModel = ViewModelProvider(requireActivity()).get(MedicineInfoViewModel::class.java)

        searchMedicine()

        binding.drugRecyclerView.adapter = medicineInfoViewModel.adapter

        return inflater.inflate(R.layout.fragment_medicine_info, container, false)
    }

    private fun searchMedicine() {
        val findIcon = binding.SearchIcon
        findIcon.isSubmitButtonEnabled = true
        findIcon.setOnQueryTextListener(
            object : SearchView.OnQueryTextListener {
                override fun onQueryTextSubmit(query: String?): Boolean {
                    val findText = binding.toolbar
                    medicineInfoViewModel.getApiDataFromRetrofit("$findText")
                    return false
                }

                override fun onQueryTextChange(newText: String?): Boolean {
                    medicineInfoViewModel.getApiDataFromRetrofit("히스타민")
                    return true
                }
            }
        )
    }

    private fun setUpOnClickListener() {
        adapter.setItemClickListener(object : RecyclerViewDrugInfoAdapter.OnItemClickListener{
            override fun onClick(v: View, position: Int) {
                findNavController().navigate(R.id.DrugMoreInfoFragment)
            }
        })
    }

    fun setRecyclerView() {
        val currentDisease = userViewModel.getUserDiseaseList()
    }


}