package ryokaz.linebot.sample2.bot_server.config

import org.springframework.context.annotation.Configuration
import org.springframework.security.config.annotation.web.builders.HttpSecurity
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter
import org.springframework.security.config.web.servlet.invoke

@Configuration
class BotSecurityConfig : WebSecurityConfigurerAdapter() {

    override fun configure(http: HttpSecurity) {
        http {
            csrf {
                disable()
            }
            authorizeRequests {
                authorize("/**", permitAll)
            }
        }
    }
}
