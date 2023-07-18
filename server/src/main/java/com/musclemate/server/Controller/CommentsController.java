package com.musclemate.server.Controller;

import com.musclemate.server.entity.*;


import com.musclemate.server.service.impl.CommentsServiceImpl;
import com.musclemate.server.service.impl.LikesServiceImpl;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/comments")
public class CommentsController {
    @Autowired
    private CommentsServiceImpl service;


    @PostMapping("/addComment/{userId}/{treinoId}")
    public ResponseEntity<Comments> addComment(@PathVariable Long userId, @PathVariable Long treinoId, @RequestBody Comments comment) {
        String commentText = comment.getCommentText();
        Comments savedComment = service.addComment(userId, treinoId, commentText);
        return new ResponseEntity<>(savedComment, HttpStatus.CREATED);
    }


    @GetMapping("/treino/{treinoId}")
    public List<Comments> getCommentsByTreinoConcluido(@PathVariable TreinosConcluidos treinoId) {
        return service.getCommentsByPosts(treinoId);
    }

    @DeleteMapping("/removeComment/{id}")
    public ResponseEntity<Void> deleteLike(@PathVariable Long id) {
        service.deleteComment(id);
        return ResponseEntity.noContent().build();
    }


}
