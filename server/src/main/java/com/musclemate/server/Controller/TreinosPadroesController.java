package com.musclemate.server.Controller;

import com.musclemate.server.entity.TreinosConcluidos;
import com.musclemate.server.entity.TreinosPadroes;
import com.musclemate.server.entity.User;
import com.musclemate.server.repository.TreinosPadroesRepository;

import com.musclemate.server.service.impl.TreinosPadroesServiceImpl;
import com.musclemate.server.service.impl.UserServiceImpl;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/treinosPadroes")
public class TreinosPadroesController {
    @Autowired
    private TreinosPadroesServiceImpl service;
    @Autowired
    private UserServiceImpl userService;
    @Autowired
    private TreinosPadroesRepository repository;
    @GetMapping("{userId}")
    public List<TreinosPadroes> getAllTreinos(@PathVariable("userId") User user) {
        return repository.findAllByUser(user);
    }

    @PostMapping
    public ResponseEntity<Object> criarTreinoPadrao(@RequestBody @Valid TreinosPadroes treinoDTO, BindingResult bindingResult) {
        if(bindingResult.hasErrors()) {
            return ResponseEntity.badRequest().body("Dados inválidos");
        }
        service.criarTreinoPadrao(treinoDTO);
        return ResponseEntity.ok().body("Treino padrão criado com sucesso!");
    }

    @GetMapping("/{userId}/{nomeTreino}")
    public ResponseEntity<Object> getExerciciosByNomeTreino(@PathVariable("userId") User user, @PathVariable("nomeTreino") String nomeTreino) {


        if (user == null) {
            return ResponseEntity.notFound().build();
        }
        List<TreinosPadroes> exercicios = repository.findExerciciosByUserAndNomeTreino(user, nomeTreino);
        if (exercicios.isEmpty()) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.ok(exercicios);
    }


}
