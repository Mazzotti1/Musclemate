package com.musclemate.server.repository;

import com.musclemate.server.entity.Likes;
import com.musclemate.server.entity.Notifications;

import com.musclemate.server.entity.TreinosConcluidos;
import com.musclemate.server.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;


import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface NotificationsRepository extends JpaRepository<Notifications, Long> {
    List<Notifications> findByUser(User user);

}
