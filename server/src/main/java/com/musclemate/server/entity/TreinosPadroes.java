package com.musclemate.server.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "treinos_padroes")
public class TreinosPadroes {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotNull
    @Column
    private String nomeTreino;


    private List<String> exercicios;


    private String grupos;

    @NotNull
    @ManyToOne
    @JoinColumn(name = "usuario_id")
    private User user;


}


