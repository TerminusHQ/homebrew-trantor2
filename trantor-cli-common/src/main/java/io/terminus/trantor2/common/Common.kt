package io.terminus.trantor2.common

import com.github.ajalt.clikt.core.CliktCommand
import com.github.ajalt.clikt.output.TermUi
import java.io.File

/**
 * @author wjx
 */
val TRANTOR2_HOME_PATH = System.getenv("TRANTOR2_HOME") ?: throw IllegalStateException("ENV [TRANTOR2_HOME] not set")
val TRANTOR2_VERSION = System.getenv("TRANTOR2_CLI_VERSION") ?: "UNKNOWN"
val TRANTOR2_WORKSPACE_PATH = System.getenv("TRANTOR2_WORKSPACE") ?: "${System.getProperty("user.home")}/.trantor2"
lateinit var trantorCliConfig: TrantorCliConfig
fun initTrantorCliConfig() {
    trantorCliConfig = loadTrantorCliConfig()
}

fun getDockerMachineIp(cliktCommand: CliktCommand): String {
    return if (TermUi.isWindows) {
        val result = exec(cliktCommand, arrayOf("docker-machine", "ip")) {}
        if (result.successful) {
            result.message
        } else {
            cliktCommand.echo("使用 docker-machine 获取 docker vm ip 失败，可能是 docker-desktop 环境，忽略并使用 localhost", err = true)
            cliktCommand.echo("原始异常：${result.message}", err = true)
            "localhost"
        }
    } else {
        "localhost"
    }
}

fun exec(cliktCommand: CliktCommand, command: Array<String>, runtimeDir: File? = null, rowAction: String.() -> Unit = { cliktCommand.echo(this) }): ExecResult {
    val messages = arrayListOf<String>()
    val process = prepareProcess(command, runtimeDir)
    process.inputStream.reader().forEachLine {
        messages.add(it)
        rowAction(it)
    }
    val outMessage = process.errorStream.reader().readText()
    if (messages.isEmpty() && outMessage.isNotBlank()) {
        messages.add(outMessage)
    }
    val errMessage = process.errorStream.reader().readText()
    val status = process.waitFor()
    return if (status == 0) {
        ExecResult(messages.joinToString("\n"))
    } else {
        ExecResult(errMessage, false)
    }
}

fun getPWD(): String = System.getenv("PWD")

fun getPWDFile() = File(getPWD())

data class ExecResult(
        val message: String,
        val successful: Boolean = true
)

fun execInherit(command: Array<String>,
                runtimeDir: File? = null
): ExecResult {
    val process = prepareProcess(command, runtimeDir, true)
    val status = process.waitFor()
    return if (status == 0) {
        ExecResult("OK")
    } else {
        ExecResult("Fail", false)
    }
}

private fun prepareProcess(command: Array<String>, runtimeDir: File? = null, inheritOutput: Boolean = false): Process {
    val processBuilder = ProcessBuilder(*command).directory(runtimeDir)
    processBuilder.environment().putAll(System.getenv())
    processBuilder.environment()["TRANTOR2_WORKSPACE"] = TRANTOR2_WORKSPACE_PATH

    if (inheritOutput) {
        processBuilder.inheritIO()
    }

    return processBuilder.start().apply { this.outputStream.close() }
}
