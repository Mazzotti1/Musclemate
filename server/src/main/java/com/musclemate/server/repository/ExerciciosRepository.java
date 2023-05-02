package com.musclemate.server.repository;

import com.musclemate.server.entity.Exercicios;
import org.springframework.data.jpa.repository.JpaRepository;

import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ExerciciosRepository extends JpaRepository<Exercicios, Long> {

    @Query("SELECT DISTINCT e.grupoMuscular FROM Exercicios e")
    List<String> findAllGroupNames();


    @Query("SELECT e.nomeExercicio FROM Exercicios e WHERE e.grupoMuscular = :grupoMuscular")
    List<String> findByGrupoMuscular(String grupoMuscular);

}

