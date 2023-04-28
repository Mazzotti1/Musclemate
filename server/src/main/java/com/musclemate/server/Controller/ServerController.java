package com.musclemate.server.Controller;


import com.musclemate.server.entity.User;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;


@RestController
public class ServerController {

    @GetMapping("/admin")
    public ResponseEntity<String> rotaProtegida(Authentication authentication) {
        User user = (User) authentication.getPrincipal();
        if (!user.isAdmin()) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Acesso negado");
        }
        return ResponseEntity.ok("Você foi autorizado!");
    }

}
