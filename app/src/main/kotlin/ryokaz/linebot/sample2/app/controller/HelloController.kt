package ryokaz.linebot.sample2.app.controller

import mu.KotlinLogging
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController
import ryokaz.linebot.sample2.common.Hello

private val logger = KotlinLogging.logger {}

@RestController
class HelloController {
    @GetMapping("/hello")
    fun hello(): Hello {
        logger.info { "hello in app controller logger.info" }
        return Hello("world")
    }
}
