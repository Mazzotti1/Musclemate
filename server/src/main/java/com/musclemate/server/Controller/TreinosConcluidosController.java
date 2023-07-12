package com.musclemate.server.Controller;

import com.musclemate.server.entity.TreinosConcluidos;
import com.musclemate.server.entity.User;
import com.musclemate.server.repository.TreinosConcluidosRepository;
import com.musclemate.server.service.impl.ExerciciosServiceImpl;
import com.musclemate.server.service.impl.FollowerServiceImpl;
import com.musclemate.server.service.impl.TreinosConcluidosServiceImpl;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/treinos")
public class TreinosConcluidosController {
    @Autowired
    private TreinosConcluidosServiceImpl service;
    @Autowired
    private FollowerServiceImpl followerService;
    @Autowired
    private TreinosConcluidosRepository repository;
    @GetMapping("{userId}")
    public List<TreinosConcluidos> getAllTreinos(@PathVariable("userId") User user) {
        List<TreinosConcluidos> treinos = repository.findAllByUser(user);
        treinos.forEach(treino -> treino.setUser(null));
        return treinos;
    }

    @PostMapping
    public ResponseEntity<Object> criarTreinoConcluido(@RequestBody @Valid TreinosConcluidos treinoDTO, BindingResult bindingResult) {
        if(bindingResult.hasErrors()) {
            return ResponseEntity.badRequest().body("Dados inválidos");
        }
        service.criarTreinoConcluido(treinoDTO);
        return ResponseEntity.ok().body("Treino concluído criado com sucesso!");
    }

    @GetMapping("/feed/{userId}")
    public ResponseEntity<List<TreinosConcluidos>> getFeed(@PathVariable("userId") User user) {
        List<User> usuariosSeguidos = followerService.getSeguindo(user);
        List<TreinosConcluidos> atividadesFeed = service.buscarAtividadesDosSeguidos(usuariosSeguidos);


        if (atividadesFeed.isEmpty()) {
            return ResponseEntity.noContent().build();
        }

        return ResponseEntity.ok(atividadesFeed);
    }


}
