package ryokaz.linebot.sample2.bot_server

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class BotServer

fun main(args: Array<String>) {
    runApplication<BotServer>(*args)
}
