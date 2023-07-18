package com.musclemate.server.service.impl;


import com.musclemate.server.entity.User;

import com.musclemate.server.repository.CommentsRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class CommentsServiceImpl {

    @Autowired
    private CommentsRepository repository;



}
