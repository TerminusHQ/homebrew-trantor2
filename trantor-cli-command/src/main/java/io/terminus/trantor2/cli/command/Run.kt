package io.terminus.trantor2.cli.command

import com.github.ajalt.clikt.core.CliktCommand
import com.github.ajalt.clikt.parameters.arguments.argument
import io.terminus.trantor2.common.*
import java.io.File

/**
 * @author wjx
 */
val RUNTIME_PATH = "$TRANTOR2_WORKSPACE_PATH/libexec/dockerfiles/"

class Run : CliktCommand("启动 Trantor2 底座环境") {
    private val version by argument("version", help = "Trantor2 版本")

    override fun run() {
        trantorCliConfig.runtimeRunningVersion = version

        echo(BASE_RUNTIME_PULLING)

        exec(this, arrayOf("docker", "compose", "-p", version, "down"))
        val runtimeDir = File(RUNTIME_PATH)
        val envFile = File("$RUNTIME_PATH$version/.env")
        val env = mutableMapOf<String, String>()

        envFile.forEachLine {
            val (key, value) = it.split("=")
            val trimKey = key.trim();
            if (trimKey == "VERSION" || trimKey == "TRANTOR_PORT" || trimKey == "TRANTOR_WEB_PORT") {
                return@forEachLine
            }
            env[trimKey] = value.trim()
        }
        trantorCliConfig.env = env
        trantorCliConfig.save()

        val pullResult = execInherit(arrayOf("docker", "compose", "-f", "$version/compose.yml", "pull"), runtimeDir)
        if (!pullResult.successful) {
            echo(BASE_RUNTIME_PULL_FAIL, err = true)
            return
        }

        val command = arrayOf("docker", "compose", "-f", "$version/compose.yml", "--env-file", envFile.absolutePath, "up", "-d")
        val result = execInherit(command, runtimeDir)
        if (result.successful) {
            checkHealth(this, trantorCliConfig.env["TRANTOR_PORT"] ?: "8082", "/actuator/health")
        } else {
            echo(BASE_RUNTIME_UP_FAIL, err = true)
            echo(result.message, err = true)
        }
    }

    private fun checkHealth(cliktCommand: CliktCommand, checkPort: String, checkPath: String) {
        doHealthCheck(cliktCommand, checkPort, checkPath, object : HealthCheckCallback {
            override fun onSuccessful() {
                echo(BASE_RUNTIME_UP_SUCCESS)
            }

            override fun onFailure(message: String) {
                echo("🥹 ${BASE_RUNTIME_INIT_FAIL}，原因是 [$message]")
            }
        })
    }
}