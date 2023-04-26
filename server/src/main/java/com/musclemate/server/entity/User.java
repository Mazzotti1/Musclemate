package com.musclemate.server.entity;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;


@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "tb_users")
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String nome;

    private String sobrenome;

    @Column(unique = true)
    private String email;

    private String password;
    private String cidade;

    private String estado;

    private String bio;

    private LocalDate dataDeNascimento;

    private String peso;

    private int treinos;

    private String tempoTotal;

    private String pesoTotal;

    private String tempoCardio;
    private String token;

    public void setToken(String token) {
        this.token = token;
    }

}
