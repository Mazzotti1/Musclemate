package com.musclemate.server.Controller;

import com.musclemate.server.entity.User;
import com.musclemate.server.entity.form.UserForm;
import com.musclemate.server.service.impl.UserServiceImpl;


import org.springframework.beans.factory.annotation.Autowired;


import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.naming.AuthenticationException;
import javax.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/users")
public class UserController {
    @Autowired
    private UserServiceImpl service;

    @PostMapping("/register")
    public User create(@Valid @RequestBody UserForm form) {

        return service.create(form);
    }

    @PostMapping("/login")
    public ResponseEntity<User> login(@RequestBody UserForm form) throws AuthenticationException {
        User user = service.login(form.getEmail(), form.getPassword());
        return ResponseEntity.ok().body(user);
    }

    @GetMapping
    public List<User> getAll(@RequestParam(value = "dataDeNascimento", required = false)
                              String dataDeNacimento){
        return service.getAll(dataDeNacimento);
    }
}
