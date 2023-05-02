package com.musclemate.server.Controller;

import com.musclemate.server.entity.Exercicios;
import com.musclemate.server.entity.User;
import com.musclemate.server.service.impl.ExerciciosServiceImpl;
import com.musclemate.server.service.impl.UserServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;


@RestController
@RequestMapping("/exercicios")
public class ExerciciosController{

    @Autowired
    private ExerciciosServiceImpl service;

    @GetMapping
    public List<String> getAllGroupNames() {
        return service.getAllGroupNames();
    }

    @PostMapping
    public ResponseEntity<String> chooseGroup(@RequestBody String groupName) {
        List<String> exercicios = service.getGroupName(groupName);

        return ResponseEntity.ok(groupName);
    }

    @GetMapping("/{grupoMuscular}")
    public ResponseEntity<List<String>> getExerciciosByGrupoMuscular(@PathVariable String grupoMuscular) {
        List<String> exercicios = service.getExerciciosByGrupoMuscular(grupoMuscular);

        if (exercicios.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        return ResponseEntity.ok(exercicios);
    }

}