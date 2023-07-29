package com.musclemate.server.service.impl;

import com.musclemate.server.entity.*;
import com.musclemate.server.repository.NotificationsRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;
import java.util.List;


@Service
public class NotificationsServiceImpl {
    @Autowired
    private NotificationsRepository repository;

    public Notifications addNotification(Long userId, String atividade) {
        User user = new User();
        user.setId(userId);

        Notifications notifications = new Notifications();
        notifications.setUser(user);
        notifications.setAtividade(atividade);
        notifications.setAt(new Timestamp(System.currentTimeMillis()));

        return repository.save(notifications);
    }

    public List<Notifications> getNotificationsById(Long userId) {
        User user = new User();
        user.setId(userId);
        return repository.findByUser(user);
    }


}


