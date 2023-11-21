package com.example.dailycare

import androidx.recyclerview.widget.RecyclerView
import com.example.dailycare.databinding.WarningRecyclerviewItemBinding

class RecyclerViewAdapter {
    inner class WarningViewHolder(private val binding: WarningRecyclerviewItemBinding) : RecyclerView.ViewHolder(binding.root) {
        fun bind(warningRecyclerViewItemStateData: WarningRecyclerViewItemStateData) {
            binding.warningTitleTextView.text = warningRecyclerViewItemStateData.warningTitle
            binding.warningDateTextView.text = warningRecyclerViewItemStateData.warningTime
        }
    }
}