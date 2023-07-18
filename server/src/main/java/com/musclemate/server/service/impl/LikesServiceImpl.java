package com.musclemate.server.service.impl;


import com.musclemate.server.entity.Followers;
import com.musclemate.server.entity.Likes;
import com.musclemate.server.entity.TreinosConcluidos;
import com.musclemate.server.entity.User;


import com.musclemate.server.repository.LikesRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;
import java.util.*;

@Service
public class LikesServiceImpl {

    @Autowired
    private LikesRepository repository;

    private Map<Long, Set<Long>> likesMap = new HashMap<>();
    public Likes addLike(Long userId, Long treinoId) {
        // Verifique se o usuário já deu like nesse treino
        if (likesMap.containsKey(treinoId) && likesMap.get(treinoId).contains(userId)) {
            throw new IllegalStateException("O usuário já deu like neste treino.");
        }

        likesMap.putIfAbsent(treinoId, new HashSet<>());

        User user = new User();
        user.setId(userId);

        TreinosConcluidos treinoConcluido = new TreinosConcluidos();
        treinoConcluido.setId(treinoId);

        Likes like = new Likes();
        like.setUser(user);
        like.setTreinoId(treinoConcluido);
        like.setLiked_at(new Timestamp(System.currentTimeMillis()));

        likesMap.get(treinoId).add(userId);

        return repository.save(like);
    }

        public List<Likes> getLikesByPosts(TreinosConcluidos treinoId) {

            return repository.findByTreinoId(treinoId);
        }






}
