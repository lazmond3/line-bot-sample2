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
    val url = "jdbc:mysql://address=(host=${System.getenv("DB_ADDRESS")})(port=${System.getenv("DB_PORT")})(user=${System.getenv("DB_USER")})(password=${System.getenv("DB_PASSWORD")})/${System.getenv("DB_DATABASE")}"
    println("DB_PASSWORD: ${pass}")
    println("url: $url")
    runApplication<AppApplication>(*args)
}
