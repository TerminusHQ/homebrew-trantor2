package io.terminus.trantor2.cli.command

import com.github.ajalt.clikt.core.CliktCommand
import com.github.ajalt.clikt.parameters.options.flag
import com.github.ajalt.clikt.parameters.options.option
import io.terminus.trantor2.common.TRANTOR2_VERSION
import io.terminus.trantor2.common.trantorCliConfig
import java.io.File

class Env : CliktCommand("获取运行所需环境变量") {
    private val develop by option("--dev", "-d").flag(default = false)

    override fun run() {
//        val dockerHost = getDockerMachineIp(this)
        val version = trantorCliConfig.runtimeRunningVersion
        if (version == null) {
            echo("当前没有正在运行的底座环境")
            return
        }
        val envFile = File("$RUNTIME_PATH$version/.env")
        val envs = trantorCliConfig.env

        echo("当前底座环境变量:")
        envs.forEach { (k, v) -> echo("$k=$v") }

        echo("env 文件位置: " + envFile.absolutePath)
    }
}

class Version : CliktCommand("查看 Trantor2 CLI 版本") {
    override fun run() {
        echo("Trantor2 CLI version: $TRANTOR2_VERSION")
    }
}
