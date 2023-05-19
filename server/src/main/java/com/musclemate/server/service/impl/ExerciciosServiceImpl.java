package com.musclemate.server.service.impl;

import com.musclemate.server.entity.Exercicios;
import com.musclemate.server.repository.ExerciciosRepository;

import com.musclemate.server.service.IExerciciosService;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Service;


import java.util.List;

@Service
public class ExerciciosServiceImpl implements IExerciciosService {
    @Autowired
    private ExerciciosRepository repository;

    @Override
    public List<String> getAllGroupNames() {
        return repository.findAllGroupNames();
    }

    @Override
    public Exercicios findByGrupo(String grupoMuscular) {
        return null;
    }

    @Override
    public List<Exercicios> getAll(String grupoMuscular) {
        return null;
    }


    public List<String> getExerciciosByGrupoMuscular(String grupoMuscular) {

        return repository.findByGrupoMuscular(grupoMuscular);
    }


}