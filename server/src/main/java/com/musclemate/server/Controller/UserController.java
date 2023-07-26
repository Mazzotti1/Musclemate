package com.musclemate.server.Controller;

import com.musclemate.server.entity.Followers;
import com.musclemate.server.entity.User;
import com.musclemate.server.entity.form.UserForm;
import com.musclemate.server.entity.form.UserUpdateForm;
import com.musclemate.server.service.impl.FollowerServiceImpl;
import com.musclemate.server.service.impl.UserServiceImpl;


import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;


import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.web.bind.annotation.*;



import java.util.List;

@RestController
@RequestMapping("/users")
public class UserController {
    @Autowired
    private UserServiceImpl service;
    @Autowired
    private FollowerServiceImpl followService;
    @GetMapping
    public List<User> getAll(@RequestParam(value = "nome", required = false) String nome) {
        return service.getAll(nome);
    }

    @PostMapping("/register")
    public User create(@Valid @RequestBody UserForm form) {

        return service.create(form);
    }
    @PostMapping("/login")
    public ResponseEntity<String> login(@RequestBody UserForm form) throws AuthenticationException {
        User user = service.login(form.getEmail(), form.getPassword());
        return ResponseEntity.ok().body(user.getToken());
    }

    @GetMapping("/{id}")
    public ResponseEntity<User> getById(@PathVariable Long id) {
        User user = service.get(id);
        if (user == null) {
            return ResponseEntity.notFound().build();
        } else {
            return ResponseEntity.ok().body(user);
        }
    }
    @DeleteMapping("/{id}")
    public ResponseEntity<User> deleteById(@PathVariable Long id) {
        boolean deleted = service.delete(id);
        if (deleted) {
            return ResponseEntity.ok().body(new User());
        } else {
            return ResponseEntity.notFound().build();
        }
    }
    @GetMapping("/nome/{nome}")
    public ResponseEntity<User> getByNome(@PathVariable String nome) {
        String nomeMinusculo = nome.toLowerCase();
        String nomeCapitalizado = nomeMinusculo.substring(0, 1).toUpperCase() + nomeMinusculo.substring(1);
        User user = service.getByNome(nomeCapitalizado);
        if (user == null) {
            return ResponseEntity.notFound().build();
        } else {
            return ResponseEntity.ok().body(user);
        }
    }

    @PatchMapping("/update/email/{id}")
    public ResponseEntity<User> updateUserEmail(@PathVariable Long id, @RequestBody UserUpdateForm updateForm)  {
        try {
            User updatedUserEmail = service.updateUserEmail(id, updateForm);
            return ResponseEntity.ok(updatedUserEmail);
        } catch (BadCredentialsException e) {
            return ResponseEntity.badRequest().body(null);
        }
    }

    @PatchMapping("/update/data/{id}")
    public ResponseEntity<User> updateUser(@PathVariable Long id, @RequestBody UserUpdateForm updateForm) {
        try {
            User updatedUser = service.updateUserData(id, updateForm);
            return ResponseEntity.ok(updatedUser);
        } catch (BadCredentialsException e) {
            return ResponseEntity.badRequest().body(null);
        }
    }

    @PostMapping("/follow")
    public void seguirUsuario(@RequestBody Followers followers) {
        followService.seguirUsuario(followers.getFollower(), followers.getFollowed());

    }

    @DeleteMapping("/unfollow")
    public void deixarDeSeguirUsuario(@RequestBody Followers followers) {
        User follower = followers.getFollower();
        User followed = followers.getFollowed();

        followService.deixarDeSeguirUsuario(follower, followed);
    }

    @GetMapping("/followers/{id}")
    public List<User> getSeguidores(@PathVariable Long id) {
        User user = service.get(id);
        return followService.getSeguidores(user);
    }

    @GetMapping("/followed/{id}")
    public List<User> getSeguindo(@PathVariable Long id) {
        User user = service.get(id);
        return followService.getSeguindo(user);
    }



}
