import org.springframework.boot.gradle.tasks.bundling.BootJar

tasks {
    "jar"(Jar::class) {
        enabled = true
    }

    "bootJar"(BootJar::class) {
        enabled = false
    }
    dependencies {
        implementation("org.springframework.boot:spring-boot-autoconfigure")
        implementation("org.springframework.boot:spring-boot-starter-web")
        implementation("org.springframework.boot:spring-boot-starter-aop")
        implementation("org.springframework.data:spring-data-commons")
        implementation("org.springframework.retry:spring-retry")

        api("org.mybatis.spring.boot:mybatis-spring-boot-starter")

        runtimeOnly("mysql:mysql-connector-java")
        implementation("org.flywaydb:flyway-core")

        implementation("io.github.microutils:kotlin-logging")
        implementation("org.springframework:spring-context-support")
        runtimeOnly("org.springframework.boot:spring-boot-devtools")
        testImplementation("org.springframework.boot:spring-boot-starter-test")
        testImplementation("org.mybatis.spring.boot:mybatis-spring-boot-starter-test")
        testImplementation("org.assertj:assertj-core")
        implementation("com.squareup.retrofit2:retrofit")
        implementation("com.squareup.retrofit2:converter-jackson")
        implementation("com.squareup.retrofit2:converter-scalars")
        implementation("com.squareup.okhttp3:logging-interceptor")
        implementation("com.squareup.okhttp3:okhttp")
        testImplementation("com.squareup.okhttp3:mockwebserver")
    }
}
