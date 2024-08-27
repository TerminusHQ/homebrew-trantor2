package io.terminus.trantor2.cli.command

import com.github.ajalt.clikt.core.CliktCommand
import io.terminus.trantor2.common.*

/**
 * @author wjx
 */
class Stop : CliktCommand("停止 Trantor2 底座环境") {
    override fun run() {
        var version = trantorCliConfig.runtimeRunningVersion
        if (version == null) {
            val inspectRes = exec(this, arrayOf("docker", "inspect", "-f", "'{{ index .Config.Labels \"com.docker.compose.project\" }}'", "trantor2-backend"))
            if (!inspectRes.successful) {
                if (inspectRes.message.isNotBlank() && inspectRes.message.contains("No such object")) {
                    echo(BASE_RUNTIME_DOWN_EMPTY)
                } else {
                    echo(inspectRes.message, err = true)
                }
                return
            }
            version = inspectRes.message
        }

        val spinnerControl = SpinnerControl(this, "停止容器中...")
        val result = exec(this, arrayOf("docker", "compose", "-p", version, "down"))

        if (result.successful) {
            if (result.message.isNotBlank() && result.message.contains("No resource found")) {
                spinnerControl.stop((BASE_RUNTIME_DOWN_EMPTY))
            } else {
                spinnerControl.stop(BASE_RUNTIME_DOWN_SUCCESS)
            }
            trantorCliConfig.runtimeRunningVersion = null
            trantorCliConfig.save()
        } else {
            echo(BASE_RUNTIME_DOWN_FAIL, err = true)
            echo(result.message, err = true)
            spinnerControl.stop()
        }
    }
}
