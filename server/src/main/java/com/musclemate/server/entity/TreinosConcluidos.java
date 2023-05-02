package com.musclemate.server.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "treinos_concluidos")
public class TreinosConcluidos {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotNull
    @Column
    private String tipoDeTreino;

    @NotNull
    private Integer totalDeRepeticoes;

    @NotNull
    private Integer mediaDePesoUtilizado;

    @NotNull
    private LocalDate dataDoTreino;

    @NotNull
    @Column
    private LocalTime tempo;

    @NotNull
    private Integer totalDeSeries;

    @NotNull
    @ManyToOne
    @JoinColumn(name = "usuario_id")
    private User user;

}


