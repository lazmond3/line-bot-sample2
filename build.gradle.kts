import org.jetbrains.kotlin.gradle.tasks.KotlinCompile
import java.io.ByteArrayOutputStream

repositories {
    mavenCentral()
    jcenter()
}

val javaVersion: String by project
java.sourceCompatibility = JavaVersion.VERSION_11

plugins {
    java
    `java-library`
    checkstyle
    kotlin("jvm") version "1.4.32"
    kotlin("plugin.spring") version "1.4.32"
    kotlin("plugin.noarg") version "1.4.32"

    id("org.springframework.boot") version "2.4.5" apply false
    id("io.spring.dependency-management") version "1.0.11.RELEASE" apply true
    id("io.gitlab.arturbosch.detekt") version "1.16.0"
    id("com.google.cloud.tools.jib") version "3.0.0"
}

val projectClassName = "ryokaz.linebot.sample2"
subprojects {
    group = projectClassName

    repositories {
        mavenCentral()
        jcenter()
    }

    apply {
//        plugin("org.jetbrains.dokka") // doc tool
//        plugin("io.gitlab.arturbosch.detekt") // static analysis
        plugin("java")
        plugin("java-library")
        plugin("kotlin")
        plugin("org.jetbrains.kotlin.plugin.noarg")
        plugin("kotlin-spring")
        plugin("org.springframework.boot")
        plugin("io.spring.dependency-management")
        plugin("com.google.cloud.tools.jib")
    }

    noArg {
        annotation("$projectClassName.common.annotation.NoArgsConstructor")
    }

    base.archivesBaseName = "$projectClassName-${project.name}"

    tasks.withType<JavaCompile> {
        options.encoding = "UTF-8"
        options.compilerArgs.addAll(arrayOf("-parameters", "--release", javaVersion))
    }

    tasks.withType<KotlinCompile> {
        kotlinOptions {
//            javaParameters = true
            freeCompilerArgs = listOf("-Xjsr305=strict")
            jvmTarget = javaVersion
        }
    }

    tasks.withType<Test> {
        useJUnitPlatform()
        jvmArgs = listOf("-Duser.timezone=Asia/Tokyo")
    }

    noArg {
        annotation("ryokaz.linebot.sample2.common.annotation.NoArgsConstructor")
    }

    dependencyManagement {
        dependencies {
            dependencySet("com.squareup.retrofit2:2.9.0") {
                entry("retrofit")
                entry("converter-jackson")
                entry("adapter-rxjava2")
                entry("converter-scalars")
            }

            dependencySet("com.squareup.okhttp3:4.9.0") {
                entry("okhttp")
                entry("logging-interceptor")
                entry("mockwebserver")
            }

            dependencySet("org.mybatis.spring.boot:2.1.4") {
                entry("mybatis-spring-boot-starter")
                entry("mybatis-spring-boot-starter-test")
            }

            dependency("com.linecorp.bot:line-bot-spring-boot:4.3.0")
            dependency("io.github.microutils:kotlin-logging:1.12.5")
            dependency("org.slf4j:slf4j-simple:1.7.29") // to stdout
            dependency("com.fasterxml.jackson.module:jackson-module-kotlin:2.11.4")
            dependency("io.springfox:springfox-boot-starter:3.0.0")
            dependency("io.mockk:mockk:1.10.0")
            dependency("com.ninja-squad:springmockk:3.0.1")
            dependency("org.jeasy:easy-random-core:4.2.0")
        }
    }

    jib {
        val versionNumber: String =
            file(
                rootDir.absolutePath +
                        File.separatorChar +
                        "VERSION.txt"
            )
                .readText().trim()
        val dockerImageTagLength = System.getenv("DOCKER_IMAGE_TAG_LENGTH") ?: 7
        val dockerRepositoryEcrBaseUrl = System.getenv("DOCKER_REPOSITORY_BASE_URL")
            ?: throw Exception("DOCKER_REPOSITORY_BASE_URL is not set")
        val gitRevision = ByteArrayOutputStream().use { os ->
            exec {
                commandLine("git", "rev-parse", "--short=$dockerImageTagLength", "HEAD")
                workingDir = rootDir
                standardOutput = os
            }
            os.toString().trim()
        }
        val tag = "$versionNumber-$gitRevision"
        val jibTag = System.getenv("JIB_TAG")
        val tagsVariable = mutableSetOf("latest", tag)

        from {
            image = "docker.io/library/amazoncorretto:11"
            // image = "adoptopenjdk/openjdk11:latest"
        }
        to {
            if (!jibTag.isNullOrBlank()) {
               tagsVariable.add(jibTag) // これ動かないんだっけ？
            }
            tags = tagsVariable

            image =
                "${dockerRepositoryEcrBaseUrl}/line-bot-sample2-${project.name}"
        }
        container {
            creationTime = "USE_CURRENT_TIMESTAMP"
            labels = mapOf("maintainer" to "ryokaz <moikilo00@gmail.com>")
            val serverPort = "8080"
            // user = "www:www"
            // val userHome = "/home/www"
            ports = listOf(
                serverPort,
                "8081"
            )
            jvmFlags = listOf(
                "-server",
                "-XX:+UseG1GC",
                "-XX:+ScavengeBeforeFullGC",
                "-XX:+ExitOnOutOfMemoryError",
                // "-Xlog:gc=info,vmoperation" +
                //         "=info:$userHome/logs/jvm/jvm.log:time,uptime,level,tags:filesize=100m,filecount=1",
                "-Dfile.encoding=UTF-8",
                "-Duser.timezone=Asia/Tokyo",
                "-XX:MaxMetaspaceSize=200M",
                "-Dserver.port=$serverPort"
            )
        }
    }


    dependencies {
        implementation("io.github.microutils:kotlin-logging")
        implementation("com.fasterxml.jackson.module:jackson-module-kotlin")
        implementation(kotlin("stdlib-jdk8"))
        implementation(kotlin("reflect"))
        testImplementation(kotlin("test"))
        testImplementation("io.mockk:mockk")
        testImplementation("com.ninja-squad:springmockk")
        testImplementation("org.jeasy:easy-random-core")
    }
}
