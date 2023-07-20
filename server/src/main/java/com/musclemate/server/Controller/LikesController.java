package com.musclemate.server.Controller;

import com.musclemate.server.entity.Followers;
import com.musclemate.server.entity.Likes;
import com.musclemate.server.entity.TreinosConcluidos;


import com.musclemate.server.entity.User;
import com.musclemate.server.service.impl.LikesServiceImpl;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/likes")
public class LikesController {
    @Autowired
    private LikesServiceImpl service;


    @PostMapping("/addLike/{userId}/{treinoId}")
    public ResponseEntity<Likes> addLike(@PathVariable Long userId, @PathVariable Long treinoId) {
        Likes like = service.addLike(userId, treinoId);
        return new ResponseEntity<>(like, HttpStatus.OK);
    }


    @GetMapping("/treino/{treinoId}")
    public List<Likes> getLikesByTreinoConcluido(@PathVariable TreinosConcluidos treinoId) {
        return service.getLikesByPosts(treinoId);
    }

    @GetMapping("/user/{userId}")
    public List<Likes> getLikesByUser(@PathVariable Long userId) {
        return service.getLikesByUser(userId);
    }
    @DeleteMapping("/dislike/{id}")
    public ResponseEntity<Void> deleteLike(@PathVariable Long id) {
        service.deleteLike(id);
        return ResponseEntity.noContent().build();
    }


}
