package com.musclemate.server.service;

import com.musclemate.server.entity.Exercicios;
import com.musclemate.server.entity.User;

import java.util.List;

public interface IExerciciosService {

    List<String> getAllGroupNames();


    Exercicios findByGrupo(String grupoMuscular);

    List<Exercicios> getAll(String grupoMuscular);
}
