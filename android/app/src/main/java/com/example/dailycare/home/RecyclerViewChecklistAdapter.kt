package com.example.dailycare.home

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.example.dailycare.databinding.ChecklistRecyclerviewItemBinding
import com.example.dailycare.timerset.SharedViewModel

class RecyclerViewChecklistAdapter : RecyclerView.Adapter<RecyclerViewChecklistAdapter.ChecklistViewHolder>() {

    var checklistDataItems = mutableListOf<checklistRecyclerViewItemState>()

    inner class ChecklistViewHolder(private val binding: ChecklistRecyclerviewItemBinding) :
        RecyclerView.ViewHolder(binding.root) {
        fun bind(checklistRecyclerViewItemStateData: checklistRecyclerViewItemState) {
            binding.checklistItemTitleTextview.text =
                checklistRecyclerViewItemStateData.checklistTitle
            binding.checklistItemDateTextview.text =
                checklistRecyclerViewItemStateData.checklistDate
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ChecklistViewHolder {
        val binding = ChecklistRecyclerviewItemBinding.inflate(
            LayoutInflater.from(parent.context),
            parent,
            false
        )
        return ChecklistViewHolder(binding)
    }

    override fun getItemCount(): Int = checklistDataItems.size
    override fun onBindViewHolder(
        holder: ChecklistViewHolder,
        position: Int
    ) {
        val sharedViewModel = SharedViewModel()

        holder.bind(checklistDataItems[position])
    }

}