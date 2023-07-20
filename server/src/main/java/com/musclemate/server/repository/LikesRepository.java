package com.musclemate.server.repository;

import com.musclemate.server.entity.Likes;
import com.musclemate.server.entity.TreinosConcluidos;
import com.musclemate.server.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;


import org.springframework.stereotype.Repository;

import java.util.List;


@Repository
public interface LikesRepository extends JpaRepository<Likes, Long> {


    List<Likes> findByTreinoId(TreinosConcluidos treinoId);

    List<Likes> findByUser(User user);

}




