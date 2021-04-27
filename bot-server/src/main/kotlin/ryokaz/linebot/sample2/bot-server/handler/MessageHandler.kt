package ryokaz.linebot.sample2.bot_server.controller

import com.linecorp.bot.model.event.Event
import com.linecorp.bot.model.event.MessageEvent
import com.linecorp.bot.model.event.message.TextMessageContent
import com.linecorp.bot.model.message.TextMessage
import com.linecorp.bot.spring.boot.annotation.EventMapping
import com.linecorp.bot.spring.boot.annotation.LineMessageHandler
import org.springframework.boot.SpringApplication


@LineMessageHandler
class MessageHandler {
    @EventMapping
    fun handleTextMessageEvent(event: MessageEvent<TextMessageContent>): TextMessage {
        println("event: $event")
        return TextMessage(event.getMessage().getText())
     }

    @EventMapping
    fun handleDefaultMessageEvent(event: Event) {
        println("event: $event")
    }
}