package com.musclemate.server.service.impl;

import com.musclemate.server.entity.User;
import com.musclemate.server.entity.form.UserForm;
import com.musclemate.server.entity.form.UserUpdateForm;
import com.musclemate.server.infra.utils.JavaTimeUtils;
import com.musclemate.server.repository.UserRepository;
import com.musclemate.server.service.IUserService;

import com.musclemate.server.utils.JwtUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;


import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Service
public class UserServiceImpl implements IUserService, UserDetailsService {
    @Autowired
    private UserRepository repository;

    public PasswordEncoder getPasswordEncoder(){
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        return encoder;
    }

    @Override
    public User create( UserForm form) {

        if (!form.getEmail().matches("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$")) {
            throw new IllegalArgumentException("O email informado é inválido.");
        }

        User user = new User();
        user.setNome(form.getNome());
        user.setEmail(form.getEmail());
        String rawPassword = form.getPassword();
        if (rawPassword != null && rawPassword.length() >= 6) {
            user.setPassword(getPasswordEncoder().encode(rawPassword));
            return repository.save(user);
        } else {
            throw new IllegalArgumentException("A senha precisa ter no mínimo 6 caracteres.");
        }
    }

    @Override
    public User login(String email, String password) throws AuthenticationException {
        User user = repository.findByEmail(email);
        if (user == null) {
            throw new BadCredentialsException("Usuário não encontrado");
        }

        if (!getPasswordEncoder().matches(password, user.getPassword())) {
            throw new BadCredentialsException("Senha incorreta");
        }

        JwtUtils jwtUtils = new JwtUtils();
        String token = jwtUtils.generateToken(
                user.getId(),
                user.getNome(),
                user.getSobrenome(),
                user.getEmail(),
                user.getCidade(),
                user.getEstado(),
                user.getBio(),
                user.getTreinos(),
                user.getTempoTotal(),
                user.getPesoTotal(),
                user.getTempoCardio()
        );

        user.setToken(token);
        return user;
    }


    @Override
    public User get(Long id) {
        return null;
    }

    @Override
    public List<User> getAll(String dataDeNascimento) {

        if(dataDeNascimento == null) {
            return repository.findAll();
        } else {
            LocalDate localDate = LocalDate.parse(dataDeNascimento, JavaTimeUtils.LOCAL_DATE_FORMATTER);
            return repository.findByDataDeNascimento(localDate);
        }

    }

    @Override
    public User update(Long id, UserUpdateForm formUpdate) {
        return null;
    }

    @Override
    public void delete(Long id) {
    }

        @Override
        public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
            User user = repository.findByEmail(username);
            if (user == null) {
                throw new UsernameNotFoundException("Usuário não encontrado");
            }
            return new org.springframework.security.core.userdetails.User(
                    user.getEmail(), user.getPassword(), new ArrayList<>());
        }


}
