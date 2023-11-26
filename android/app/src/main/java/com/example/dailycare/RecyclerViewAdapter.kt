package com.example.dailycare

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.example.dailycare.databinding.WarningRecyclerviewItemBinding

class RecyclerViewAdapter : RecyclerView.Adapter<RecyclerViewAdapter.WarningViewHolder>() {

    var dataItems = mutableListOf<WarningRecyclerViewItemStateData>()

    inner class WarningViewHolder(private val binding: WarningRecyclerviewItemBinding) : RecyclerView.ViewHolder(binding.root) {
        fun bind(warningRecyclerViewItemStateData: WarningRecyclerViewItemStateData) {
            binding.warningTitleTextView.text = warningRecyclerViewItemStateData.warningTitle
            binding.warningDateTextView.text = warningRecyclerViewItemStateData.warningTime
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType:Int) : WarningViewHolder {
        val binding = WarningRecyclerviewItemBinding.inflate(LayoutInflater.from(parent.context), parent, false)
        return WarningViewHolder(binding)
    }

    override fun getItemCount(): Int = dataItems.size

    override fun onBindViewHolder(holder:WarningViewHolder, position:Int) {
        holder.bind(dataItems[position])
    }
}