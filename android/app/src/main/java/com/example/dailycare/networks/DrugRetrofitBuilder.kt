package com.example.dailycare.networks

import android.util.Log
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

object DrugRetrofitBuilder : BaseDrugRetrofitBuilder() {
    lateinit var itemFromAPI : Item
    override val baseUrl: String
        get() = "https://apis.data.go.kr"

    private const val API_KEY =
        "zp5/Bg95020WS8r3QsVwD0oB5ugio/N68bNGbAjmjn7x7kyc0uyoJBgyyMUvVbQzNo4QK5Xgu144dW/yWzTBRw=="

    fun getItems(searchKeyWord: String) {
        val api = getRetrofit().create(DrugAPI::class.java)
        api.requestData(
            API_KEY, 1, 100, "$searchKeyWord", "json"
        ).enqueue(object : Callback<DrugInfo>{
            override fun onResponse(call: Call<DrugInfo>, response: Response<DrugInfo>) {
                val resultCode = response.body()?.header?.resultCode
                val resultMessage = response.body()?.header?.resultMsg

                if(resultCode == "00") {
                    response.body()?.body?.items?.forEach {
                        item ->
                        Log.d("Success", "${item.itemName}")
                        itemFromAPI = item
                    }
                }
            }

            override fun onFailure(call: Call<DrugInfo>, t: Throwable) {
                Log.d("error", t.message.toString())
            }
        })
    }
}