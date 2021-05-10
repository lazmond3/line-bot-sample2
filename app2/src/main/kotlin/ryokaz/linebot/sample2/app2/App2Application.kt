package ryokaz.linebot.sample2.app2

import java.sql.DriverManager
import java.sql.SQLException

class App2Application

fun main(args: Array<String>) {
    println("DB_ADDRESS: ${System.getenv("DB_ADDRESS")}")
    println("DB_PORT: ${System.getenv("DB_PORT")}")
    println("DB_USER: ${System.getenv("DB_USER")}")
    println("DB_DATABASE: ${System.getenv("DB_DATABASE")}")
//    val pass = System.getenv("DB_PASSWORD")?.let {
//        "${it.subSequence(0, 4)}-length:${it.length}"
//    }
//        ?: "null"
//    val pass =
    val url = "jdbc:mysql://address=(host=${System.getenv("DB_ADDRESS")})(port=${System.getenv("DB_PORT")})(user=${
        System.getenv("DB_USER")
    })(password=${System.getenv("DB_PASSWORD")})/${System.getenv("DB_DATABASE")}"
//    println("DB_PASSWORD: ${pass}")
    println("url: $url")

    /*
    接続設定
     */
    val dbAddress = System.getenv("DB_ADDRESS")!!
    val dbPort = System.getenv("DB_PORT")!!
    val dbUser = System.getenv("DB_USER")!!
    val dbDatabase = System.getenv("DB_DATABASE")!!
    val dbPass = System.getenv("DB_PASSWORD")!!

    try {
        println("url2: \"jdbc:mysql://$dbAddress:$dbPort/${dbDatabase}?user=$dbUser&password=$dbPass\"")
        DriverManager.getConnection(
            "jdbc:mysql://$dbAddress:$dbPort/${dbDatabase}?user=$dbUser&password=$dbPass",
            dbUser,
            dbPass
        )

        println("connected...")
        // Do something with the Connection
//
    } catch (ex: SQLException) {
        println("in outer(first) error")
        println("SQLException: " + ex.message);
        println("SQLState: " + ex.sqlState);
        println("VendorError: " + ex.errorCode);
    }

}
