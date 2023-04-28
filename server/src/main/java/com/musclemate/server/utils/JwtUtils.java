package com.musclemate.server.utils;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.stereotype.Component;

import java.util.Date;

@Component
public class JwtUtils {


    private String secret = "asdasdas";


    public JwtUtils(AuthenticationManager authenticationManager) {
    }

    public JwtUtils() {

    }

    public String generateToken(Long userId,
                                String nome,
                                String sobrenome,
                                String email,
                                String cidade,
                                String estado,
                                String bio,
                                int treinos,
                                String tempoTotal,
                                String pesoTotal,
                                String tempoCardio) {
        Date now = new Date();
        Date expiryDate = new Date(now.getTime() + 3600000); // Token válido por 1 hora

        String token = JWT.create()
                .withSubject(String.valueOf(userId))
                .withClaim("userId", userId)
                .withClaim("nome", nome)
                .withClaim("sobrenome", sobrenome)
                .withClaim("email", email)
                .withClaim("cidade", cidade)
                .withClaim("estado", estado)
                .withClaim("bio", bio)
                .withClaim("treinos", treinos)
                .withClaim("tempoTotal", tempoTotal)
                .withClaim("pesoTotal", pesoTotal)
                .withClaim("tempoCardio", tempoCardio)
                .withIssuedAt(now)
                .withExpiresAt(expiryDate)
                .sign(Algorithm.HMAC512(secret));
        return token;
    }


    public String getSubject(String tokenJWT) {
        return JWT.decode(tokenJWT).getSubject();
    }

}
