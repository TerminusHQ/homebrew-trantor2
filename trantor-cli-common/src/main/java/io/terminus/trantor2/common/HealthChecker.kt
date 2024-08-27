package io.terminus.trantor2.common

import com.github.ajalt.clikt.core.CliktCommand
import java.io.IOException

/**
 * @author wjx
 */
const val CHECK_HEALTH_TIME_OUT = 600000

interface HealthCheckCallback {
    fun onSuccessful()
    fun onFailure(message: String)
}

fun doHealthCheck(cliktCommand: CliktCommand, checkPort: String, checkPath: String, callback: HealthCheckCallback) {
    val startTime = System.currentTimeMillis()
    var lastCheckTime = System.currentTimeMillis()

    val spinnerControl = SpinnerControl(cliktCommand, BASE_RUNTIME_INIT_EMPTY)

    while (true) {
        try {
            if (System.currentTimeMillis() - startTime >= CHECK_HEALTH_TIME_OUT) {
                callback.onFailure("健康检查超时")
                break
            }
            if (System.currentTimeMillis() - lastCheckTime >= 5000L) {
                val response = noArgGet("http://127.0.0.1:$checkPort$checkPath")
                if (response.isSuccessful) {
                    spinnerControl.stop()
                    callback.onSuccessful()
                    break
                }
                lastCheckTime = System.currentTimeMillis()
            }
        } catch (_: IOException) {
        }
    }
}
