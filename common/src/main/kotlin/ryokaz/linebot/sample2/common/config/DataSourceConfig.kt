package ryokaz.linebot.sample2.common.config

import org.mybatis.spring.annotation.MapperScan
import org.springframework.boot.autoconfigure.EnableAutoConfiguration
import org.springframework.boot.autoconfigure.jdbc.DataSourceProperties
import org.springframework.boot.autoconfigure.transaction.TransactionManagerCustomizers
import org.springframework.boot.context.properties.ConfigurationProperties
import org.springframework.boot.jdbc.DataSourceBuilder
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.context.annotation.Primary
import org.springframework.jdbc.datasource.DataSourceTransactionManager
import org.springframework.transaction.PlatformTransactionManager
import javax.sql.DataSource

@Configuration
@MapperScan(
    basePackages = arrayOf(
        "ryokaz.linebot.sample2.common.mapper"
    )
)
@EnableAutoConfiguration
class DataSourceConfig {

    @Bean
    @ConfigurationProperties(prefix = "spring.datasource.hikari")
    fun hikariDataSource(properties: DataSourceProperties): DataSource {
        return DataSourceBuilder.create().build()
    }

    @Bean
    @Primary
    fun hikariTransactionManager(
        hikariDataSource: DataSource,
        transactionManagerCustomizers: TransactionManagerCustomizers
    ): PlatformTransactionManager {
        val transactionManager: PlatformTransactionManager = DataSourceTransactionManager(hikariDataSource)
        transactionManagerCustomizers.customize(transactionManager)
        return transactionManager
    }
}
