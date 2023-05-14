package com.musclemate.server.Controller;

import com.musclemate.server.Amazon.EmailService;
import com.musclemate.server.entity.User;
import com.musclemate.server.service.impl.UserServiceImpl;

import org.springframework.beans.factory.annotation.Autowired;


import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.Map;
import java.util.Random;


@RestController
@RequestMapping("/forgetPassword")
public class PasswordController {
    @Autowired
    private UserServiceImpl service;

    @PostMapping
    public ResponseEntity<?> sendResetPasswordEmail(@RequestBody Map<String, String> requestBody) throws IOException {
        String email = requestBody.get("email");

        boolean emailExists = service.checkEmailExists(email);

        if (emailExists) {
            String recoveryCode = generateRecoveryCode();

            User user = service.getUserByEmail(email);
            user.setRecoveryCode(recoveryCode);
            service.saveUser(user);

            // Enviar o email
            EmailService emailService = new EmailService();
            emailService.sendSimpleMessage(email, recoveryCode);

            return ResponseEntity.ok().build();
        } else {
            return ResponseEntity.notFound().build();
        }
    }
    private String generateRecoveryCode() {
        Random random = new Random();
        int code = random.nextInt(9000) + 1000; // Gera um número aleatório de 1000 a 9999
        return String.valueOf(code);
    }

}




