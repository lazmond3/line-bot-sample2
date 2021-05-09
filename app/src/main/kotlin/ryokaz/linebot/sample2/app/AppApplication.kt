package ryokaz.linebot.sample2.app

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class AppApplication

fun main(args: Array<String>) {
    println("DB_ADDRESS: ${System.getenv("DB_ADDRESS")}")
    println("DB_PORT: ${System.getenv("DB_PORT")}")
    println("DB_USER: ${System.getenv("DB_USER")}")
    println("DB_DATABASE: ${System.getenv("DB_DATABASE")}")
    val pass = System.getenv("DB_PASSWORD")?.let {
        "${it.subSequence(0,4)}-length:${it.length}"
    }
        ?: "null"
    println("DB_PASSWORD: ${pass}")
    runApplication<AppApplication>(*args)
}
