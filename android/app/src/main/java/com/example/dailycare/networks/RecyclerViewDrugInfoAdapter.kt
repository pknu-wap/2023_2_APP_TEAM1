package com.example.dailycare.networks

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.ViewParent
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView
import com.example.dailycare.databinding.MedicineRecyclerviewItemBinding

class RecyclerViewDrugInfoAdapter : RecyclerView.Adapter<RecyclerViewDrugInfoAdapter.DrugViewHolder>() {

    var drugInformationItems = mutableListOf<DrugInfoRecyclerViewItemState>()
    private lateinit var itemClickListener : OnItemClickListener

    inner class DrugViewHolder(private val binding: MedicineRecyclerviewItemBinding) :
        RecyclerView.ViewHolder(binding.root) {
        fun bind(drugInfoRecyclerViewItemState: DrugInfoRecyclerViewItemState) {
            binding.searchMedicineName.text =
                drugInfoRecyclerViewItemState.drugName
            binding.searchMedicineEnterpriseName.text =
                drugInfoRecyclerViewItemState.drugEnterpriceName
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int) : DrugViewHolder {
        val binding = MedicineRecyclerviewItemBinding.inflate(
            LayoutInflater.from(parent.context),
            parent,
            false
        )
        return DrugViewHolder(binding)
    }

    override fun getItemCount(): Int = drugInformationItems.size

    override fun onBindViewHolder(
        holder: DrugViewHolder,
        position:Int
    ) {
        holder.bind(drugInformationItems[position])

        holder.itemView.setOnClickListener {
            itemClickListener.onClick(it, position)
        }
    }

    interface OnItemClickListener {
        fun onClick(v: View, position: Int)
    }

    fun setItemClickListener(onItemClickListener: OnItemClickListener) {
        this.itemClickListener = onItemClickListener
    }
}