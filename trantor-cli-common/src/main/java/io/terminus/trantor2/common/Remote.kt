package io.terminus.trantor2.common

import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import okhttp3.Response

/**
 * @author wjx
 */
val httpClient = OkHttpClient()
val JSON_TYPE = "application/json; charset=utf-8".toMediaType()
val FILE_TYPE = "File/*".toMediaType()

fun jsonPost(url: String, body: String): Response {
    val requestBody = body.toRequestBody(JSON_TYPE)
    return httpClient.newCall(Request.Builder().url(url).post(requestBody).build()).execute()
}

fun noArgGet(url: String): Response {
    return httpClient.newCall(Request.Builder().url(url).get().build()).execute()
}