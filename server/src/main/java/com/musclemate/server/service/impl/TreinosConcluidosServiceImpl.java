package com.musclemate.server.service.impl;

import com.musclemate.server.entity.TreinosConcluidos;
import com.musclemate.server.entity.User;
import com.musclemate.server.repository.ExerciciosRepository;
import com.musclemate.server.repository.TreinosConcluidosRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class TreinosConcluidosServiceImpl {
    @Autowired
    private TreinosConcluidosRepository repository;

    @Autowired
    private UserServiceImpl userService;

    public List<TreinosConcluidos> getAllTreinos(String usuario_id) {
        return repository.findAllTreinosById(usuario_id);
    }

    public void criarTreinoConcluido(TreinosConcluidos treinoDTO) {
        TreinosConcluidos treino = new TreinosConcluidos();
        treino.setTipoDeTreino(treinoDTO.getTipoDeTreino());
        treino.setTotalDeRepeticoes(treinoDTO.getTotalDeRepeticoes());
        treino.setMediaDePesoUtilizado(treinoDTO.getMediaDePesoUtilizado());
        treino.setDataDoTreino(treinoDTO.getDataDoTreino());
        treino.setTempo(treinoDTO.getTempo());
        treino.setTotalDeSeries(treinoDTO.getTotalDeSeries());
        treino.setUser(treinoDTO.getUser());

        repository.save(treino);
    }

    public List<TreinosConcluidos> buscarAtividadesDosSeguidos(List<User> usuariosSeguidos) {
        List<TreinosConcluidos> atividades = new ArrayList<>();

        for (User usuario : usuariosSeguidos) {
            List<TreinosConcluidos> atividadesUsuario = repository.findAllByUser(usuario);
            atividades.addAll(atividadesUsuario);
        }

        return atividades;
    }



}
