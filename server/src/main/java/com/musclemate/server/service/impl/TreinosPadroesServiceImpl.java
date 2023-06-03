package com.musclemate.server.service.impl;

import com.musclemate.server.entity.TreinosConcluidos;

import com.musclemate.server.entity.TreinosPadroes;
import com.musclemate.server.repository.TreinosPadroesRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TreinosPadroesServiceImpl {
    @Autowired
    private TreinosPadroesRepository repository;

    @Autowired
    private UserServiceImpl userService;

    public List<TreinosPadroes> getAllTreinos(String usuario_id) {
        return repository.findAllTreinosById(usuario_id);
    }
    public void criarTreinoPadrao(TreinosPadroes treinoDTO){
        TreinosPadroes treino = new TreinosPadroes();

        treino.setNome(treinoDTO.getNome());
        treino.setExercicios(treinoDTO.getExercicios());
        treino.setGrupos(treinoDTO.getGrupos());
        treino.setUser(treinoDTO.getUser());

        repository.save(treino);
    }

}
