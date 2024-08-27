package io.terminus.trantor2.common

import com.github.ajalt.clikt.core.CliktCommand
import kotlin.concurrent.thread

/**
 * @author wjx
 */
class SpinnerControl(private val cliktCommand: CliktCommand, private val message: String, private val interval: Long = 200, private val spinner: Array<String> = SPINNER) {
    private val spinnerThread: Thread = thread(start = true) {
        var spinnerIndex = 0
        while (!Thread.currentThread().isInterrupted) {
            try {
                cliktCommand.echo("\r${spinner[spinnerIndex]} $message", trailingNewline = false)
                spinnerIndex = (spinnerIndex + 1) % spinner.size
                Thread.sleep(interval)
            } catch (e: InterruptedException) {
                Thread.currentThread().interrupt()
                break
            }
        }
        cliktCommand.echo("\r${" ".repeat(message.length)}\r", trailingNewline = false)
    }

    fun stop(finalMessage: String? = null) {
        spinnerThread.interrupt()
        spinnerThread.join()
        if (finalMessage != null) {
            cliktCommand.echo("$finalMessage")
        }
    }
}
