package com.musclemate.server.Controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ServerController {
    @GetMapping("/")
    public String hello() {
        System.out.println("Server is running");
        return "Hello, world!";
    }
}
