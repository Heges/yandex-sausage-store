package com.yandex.practicum.devops;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class SausageApplication {
    public static void main(String[] args) {
        SpringApplication.run(SausageApplication.class, args);
    }

}
