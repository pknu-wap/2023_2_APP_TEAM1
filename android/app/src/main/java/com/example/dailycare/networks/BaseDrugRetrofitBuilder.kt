package com.example.dailycare.networks

import com.google.gson.GsonBuilder
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

open class BaseDrugRetrofitBuilder {
    open val baseUrl = "https://apis.data.go.kr"

    private val gson = GsonBuilder()
        .setLenient()
        .create()

    private val clientBuilder = OkHttpClient.Builder().addInterceptor(
        HttpLoggingInterceptor().apply {
            level =
                HttpLoggingInterceptor.Level.BODY
        }
    )

    private val retrofit = Retrofit.Builder()
        .baseUrl(baseUrl)
        .addConverterFactory(GsonConverterFactory.create(gson))
        .client(clientBuilder.build())
        .build()

    protected fun getRetrofit() : Retrofit = retrofit

}

/*

https://apis.data.go.kr/
1471000/DrbEasyDrugInfoService/getDrbEasyDrugList
?serviceKey=zp5%2FBg95020WS8r3QsVwD0oB5ugio%2FN68bNGbAjmjn7x7kyc0uyoJBgyyMUvVbQzNo4QK5Xgu144dW%2FyWzTBRw%3D%3D
&pageNo=1&numOfRows=3&itemName=%ED%83%80%EC%9D%B4%EB%A0%88%EB%86%80&type=json
 */