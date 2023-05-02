package com.musclemate.server.entity;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "exercicios")
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class Exercicios {

    @Id
    private Long id;

    @Column(name = "grupo_muscular")
    private String grupoMuscular;

    @Column(name = "nome_exercicio")
    private String nomeExercicio;


}
