package com.example.dailycare.networks

import android.app.Application
import android.util.Log
import android.widget.Toast
import androidx.lifecycle.AndroidViewModel

class MedicineInfoViewModel(application: Application): AndroidViewModel(application) {
    val adapter = RecyclerViewDrugInfoAdapter()

    val TAG = ".MainActivity"
    fun getApiDataFromRetrofit(keyWord: String): Item {
        Log.wtf(TAG, "I want to go home")
        DrugRetrofitBuilder.getItems("$keyWord")
        appendDataToRecyclerViewItem()
        return DrugRetrofitBuilder.itemFromAPI
    }
    fun appendDataToRecyclerViewItem() {
        val drugSearchRecyclerItem = DrugInfoRecyclerViewItemState(
            DrugRetrofitBuilder.itemFromAPI.itemName,
            DrugRetrofitBuilder.itemFromAPI.entpName
        )
        adapter.drugInformationItems.add(drugSearchRecyclerItem)
    }
}
