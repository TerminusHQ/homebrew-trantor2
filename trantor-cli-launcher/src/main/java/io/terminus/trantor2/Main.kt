package io.terminus.trantor2

import com.github.ajalt.clikt.core.CliktCommand
import com.github.ajalt.clikt.core.subcommands
import io.terminus.trantor2.cli.command.*
import io.terminus.trantor2.cli.command.List
import io.terminus.trantor2.common.initTrantorCliConfig

class Trantor2 : CliktCommand() {
    override fun run() {
        initTrantorCliConfig()
    }
}

fun main(args: Array<String>) = Trantor2().subcommands(
        Version(),
        Env(),
        List(),
        Run(),
        Stop()
).main(args)
