package com.musclemate.server.utils;




import com.musclemate.server.repository.UserRepository;
import com.musclemate.server.utils.exceptionConfig.ForbiddenHandler;
import com.musclemate.server.utils.exceptionConfig.UnauthorizedHandler;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.Arrays;


@RequiredArgsConstructor
// Faz com que quando a classe for instanciada, os atributos vão ser passados no construtor automaticamente.
@EnableWebSecurity
// Desabilita as configurações default do Spring Security, permitindo o desenvolvedor configurar as próprias configurações.
@Configuration  // Indica que é uma classe de configuração.
@Primary // Essa vai ser a implementação a ser carregada caso tenha mais de 1.
public class SecurityConfig implements SecurityConfigurations { // As classes de Security só são chamadas quando a aplicação sobe!
    // Nas proximas requisições, essa classe não é chamada novamente, pois as configurações já estão salvas em memória.

    private final JwtUtils jwtUtils; // Classe que contém ações relacionadas á um token: gerar um token, validar um token, recuperar o subject do token...

    private final UserRepository userRepository; // Repositório da entidade Usuário.

    @Override
    @Bean
    public PasswordEncoder encoder() { // Encoder de senha, codifica a senha.
        return new BCryptPasswordEncoder();
    }

    @Override
    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration authenticationConfiguration) throws Exception {  // Autentica o usuário.
        return authenticationConfiguration.getAuthenticationManager();
    }

    @Override
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http.authorizeHttpRequests()
                .requestMatchers("/users/register","/users/login").permitAll()
                .anyRequest().authenticated()
                .and().cors()
                .and().headers().frameOptions().disable()
                .and().csrf().disable()
                .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                .and()
                .addFilterBefore(new AuthenticationJWTFilter(jwtUtils, userRepository), UsernamePasswordAuthenticationFilter.class)
                .exceptionHandling().authenticationEntryPoint(new UnauthorizedHandler())
                .and().exceptionHandling().accessDeniedHandler(new ForbiddenHandler());

        return http.build();
    }

    @Override
    @Bean
    public CorsConfigurationSource corsConfigurationSource() {           // Método relacionado á CORS, integração com um meio externo.
        CorsConfiguration configuration = new CorsConfiguration().applyPermitDefaultValues();
        configuration.setAllowedMethods(Arrays.asList("POST", "GET", "PUT", "DELETE", "OPTIONS"));
        final UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }


}

