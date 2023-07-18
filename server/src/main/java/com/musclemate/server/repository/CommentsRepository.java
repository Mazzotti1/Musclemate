package com.musclemate.server.repository;

import com.musclemate.server.entity.Comments;
import com.musclemate.server.entity.Followers;


import org.springframework.data.jpa.repository.JpaRepository;

import org.springframework.stereotype.Repository;




@Repository
public interface CommentsRepository extends JpaRepository<Comments, Long> {



}




