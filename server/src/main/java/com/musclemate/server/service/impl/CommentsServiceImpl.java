package com.musclemate.server.service.impl;


import com.musclemate.server.entity.Comments;
import com.musclemate.server.entity.Likes;
import com.musclemate.server.entity.TreinosConcluidos;
import com.musclemate.server.entity.User;

import com.musclemate.server.repository.CommentsRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;
import java.util.*;

@Service
public class CommentsServiceImpl {

    @Autowired
    private CommentsRepository repository;

    private Map<Long, Set<Long>> commentsMap = new HashMap<>();
    public Comments addComment(Long userId, Long treinoId, String commentText) {

        commentsMap.putIfAbsent(treinoId, new HashSet<>());

        User user = new User();
        user.setId(userId);

        TreinosConcluidos treinoConcluido = new TreinosConcluidos();
        treinoConcluido.setId(treinoId);

        Comments comment = new Comments();
        comment.setUser(user);
        comment.setTreinoId(treinoConcluido);
        comment.setCommented_at(new Timestamp(System.currentTimeMillis()));
        comment.setCommentText(commentText);
        commentsMap.get(treinoId).add(userId);

        return repository.save(comment);
    }

    public List<Comments> getCommentsByPosts(TreinosConcluidos treinoId) {
        return repository.findByTreinoId(treinoId);
    }

    public void deleteComment(Long id) {
        Comments comment = repository.findById(id).orElse(null);
        if (comment != null) {
            Long treinoId = comment.getTreinoId().getId();
            Long userId = comment.getUser().getId();


            repository.deleteById(id);


            if (commentsMap.containsKey(treinoId)) {
                commentsMap.get(treinoId).remove(userId);
            }
        }
    }

}
