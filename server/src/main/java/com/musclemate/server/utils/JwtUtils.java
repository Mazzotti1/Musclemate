package com.musclemate.server.utils;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import org.springframework.beans.factory.annotation.Value;


import java.time.LocalDate;
import java.util.Date;

public class JwtUtils {
    @Value("${jwt.secret-key}")
    private static String SECRET_KEY;

    public static String generateToken(Long userId,String nome, String sobrenome, String email, String Cidade, String Estado, String bio, int treinos, String tempoTotal, String pesoTotal, String tempoCardio) {
        Date now = new Date();
        Date expiryDate = new Date(now.getTime() + 3600000); // Token válido por 1 hora

        return Jwts.builder()
                .setSubject(Long.toString(userId))
                .setIssuedAt(now)
                .setExpiration(expiryDate)
                .signWith(SignatureAlgorithm.HS512, SECRET_KEY)
                .compact();
    }
}
