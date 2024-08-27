package io.terminus.trantor2.common

import com.google.gson.GsonBuilder
import org.apache.commons.io.IOUtils
import java.io.File
import java.nio.charset.Charset

const val CLI_CONFIG_FILE_NAME = "cli-config.json"

val CLI_CONFIG_PATH = "$TRANTOR2_WORKSPACE_PATH/conf"
val CLI_CONFIG_FILE = File("$CLI_CONFIG_PATH/$CLI_CONFIG_FILE_NAME")

var gson = GsonBuilder().disableHtmlEscaping().setPrettyPrinting().create()!!

class TrantorCliConfig {
    var runtimeRunningVersion: String? = null
    var env = mapOf<String, String>()

    fun save() {
        if (!CLI_CONFIG_FILE.exists()) {
            CLI_CONFIG_FILE.parentFile.mkdirs()
            CLI_CONFIG_FILE.createNewFile()
        }
        val configJson = gson.toJson(this)
        IOUtils.write(configJson, CLI_CONFIG_FILE.outputStream(), Charset.forName("utf-8"))
    }
}

fun loadTrantorCliConfig(): TrantorCliConfig {
    try {
        return gson.fromJson(CLI_CONFIG_FILE.reader(), TrantorCliConfig::class.java) ?: TrantorCliConfig()
    } catch (ignore: Throwable) {
    }
    return TrantorCliConfig()
}
