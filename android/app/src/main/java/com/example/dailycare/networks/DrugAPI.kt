package com.example.dailycare.networks

import retrofit2.Call
import retrofit2.http.GET
import retrofit2.http.Query


interface DrugAPI {
    @GET("/1471000/DrbEasyDrugInfoService/getDrbEasyDrugList")
    fun requestData(
        @Query("serviceKey") serviceKey: String,
        @Query("pageNo") pageNo:Int,
        @Query("numOfRows") numOfRows:Int,
        @Query("itemName") itemName:String,
        @Query("type") type:String
    ) :Call<DrugInfo>
}

/*https://apis.data.go.kr/
1471000/DrbEasyDrugInfoService/getDrbEasyDrugList
?serviceKey=zp5%2FBg95020WS8r3QsVwD0oB5ugio%2FN68bNGbAjmjn7x7kyc0uyoJBgyyMUvVbQzNo4QK5Xgu144dW%2FyWzTBRw%3D%3D
&pageNo=1&numOfRows=3&itemName=%ED%83%80%EC%9D%B4%EB%A0%88%EB%86%80&type=json
* */