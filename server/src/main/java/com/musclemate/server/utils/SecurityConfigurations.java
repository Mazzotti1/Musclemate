package com.musclemate.server.utils;


import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.web.cors.CorsConfigurationSource;


public interface SecurityConfigurations {

    PasswordEncoder encoder();


    AuthenticationManager authenticationManager(AuthenticationConfiguration authenticationConfiguration) throws Exception;


    SecurityFilterChain filterChain(HttpSecurity http) throws Exception;


    CorsConfigurationSource corsConfigurationSource();

}