package com.musclemate.server.entity.form;

import java.time.LocalDate;

public class UserUpdateForm {
    private String email;
    private String sobrenome;
    private String cidade;
    private String estado;
    private String bio;
    private String genero;
    private String peso;
    private String nome;

    private LocalDate dataDeNascimento;

    public String getEmail() {
        return email;
    }

    public String getSobrenome() {
        return sobrenome;
    }

    public String getCidade() {
        return cidade;
    }

    public String getEstado() {
        return estado;
    }

    public String getBio() {
        return bio;
    }

    public LocalDate getDataDeNascimento() {
        return dataDeNascimento;
    }

    public String getPeso() {
        return peso;
    }

    public String getNome() {
        return nome;
    }
}
