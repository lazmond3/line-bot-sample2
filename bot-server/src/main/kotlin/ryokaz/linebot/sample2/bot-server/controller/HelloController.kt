package ryokaz.linebot.sample2.bot_server.controller

import mu.KotlinLogging
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController
import ryokaz.linebot.sample2.common.Hello

// まだログ出力されない
private val logger = KotlinLogging.logger {}

@RestController
class HelloController {
    @GetMapping("/hello")
    fun hello(): Hello {
        logger.warn { "world in printlin" }
        return Hello("world")
    }
}