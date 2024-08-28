package io.terminus.trantor2.cli.command

import com.github.ajalt.clikt.core.CliktCommand
import io.terminus.trantor2.common.TRANTOR2_HOME_PATH
import java.io.File

/**
 * @author wjx
 */
private val LIB_PATH = "$TRANTOR2_HOME_PATH/libexec/"

class List : CliktCommand("列出 Trantor2 底座版本") {
    override fun run() {
        val runtimeDir = File(LIB_PATH + "dockerfiles/")
        echo("Trantor2 底座版本列表:")
        runtimeDir.listFiles { file -> file.isDirectory }?.filter { it.name.startsWith("v") }?.forEach { dir ->
            echo(dir.name)
        }
    }
}