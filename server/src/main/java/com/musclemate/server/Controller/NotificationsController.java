package com.musclemate.server.Controller;

import com.musclemate.server.entity.Notifications;
import com.musclemate.server.entity.User;
import com.musclemate.server.service.impl.NotificationsServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/notifications")
public class NotificationsController {
    @Autowired
    private NotificationsServiceImpl service;

    @PostMapping("/addNotification/{userId}")
    public ResponseEntity<Notifications> addNotification(@PathVariable Long userId, @RequestBody Notifications notifications) {
        String atividade = notifications.getAtividade();
        Notifications notification = service.addNotification(userId, atividade);
        return new ResponseEntity<>(notification, HttpStatus.OK);
    }

    @GetMapping("/{userId}")
    public List<Notifications> getNotificationsByUserId(@PathVariable Long userId) {
        return service.getNotificationsById(userId);
    }
}



