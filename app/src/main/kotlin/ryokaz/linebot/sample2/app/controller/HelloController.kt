package ryokaz.linebot.sample2.app.controller

import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController
import ryokaz.linebot.sample2.common.Hello

@RestController
class HelloController {
    @GetMapping("/hello")
    fun hello() = Hello("world")
}