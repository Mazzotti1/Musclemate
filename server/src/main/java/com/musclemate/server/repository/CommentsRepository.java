package com.musclemate.server.repository;

import com.musclemate.server.entity.Comments;
import com.musclemate.server.entity.Followers;


import com.musclemate.server.entity.Likes;
import com.musclemate.server.entity.TreinosConcluidos;
import org.springframework.data.jpa.repository.JpaRepository;

import org.springframework.stereotype.Repository;

import java.util.List;


@Repository
public interface CommentsRepository extends JpaRepository<Comments, Long> {

    List<Comments> findByTreinoId(TreinosConcluidos treinoId);

}




