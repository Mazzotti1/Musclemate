package com.musclemate.server.service.impl;

import com.musclemate.server.Controller.RegistroIncorretoException;
import com.musclemate.server.entity.User;
import com.musclemate.server.entity.form.UserForm;
import com.musclemate.server.entity.form.UserUpdateForm;
import com.musclemate.server.repository.UserRepository;
import com.musclemate.server.service.IUserService;

import com.musclemate.server.utils.JwtUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
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
            throw new RegistroIncorretoException("O email informado esta incorreto.");
        }

        User user = new User();
        user.setNome(form.getNome());
        user.setEmail(form.getEmail());
        String rawPassword = form.getPassword();
        if (rawPassword != null && rawPassword.length() >= 6) {
            user.setPassword(getPasswordEncoder().encode(rawPassword));
            return repository.save(user);
        } else {
            throw new RegistroIncorretoException("A senha precisa ter no minimo 6 caracteres.");
        }
    }

    @Override
    public User login(String email, String password) throws AuthenticationException {
        User user = repository.findByEmail(email);
        if (user == null) {
            throw new RegistroIncorretoException("Usuario nao encontrado");
        }

        if (!getPasswordEncoder().matches(password, user.getPassword())) {
            throw new RegistroIncorretoException("Senha incorreta");
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



    public User updateUserEmail(Long id, UserUpdateForm formUpdate) {
        User user = get(id);
        if (user == null) {
            throw new RegistroIncorretoException("Usuário não encontrado.");
        }

        String newEmail = formUpdate.getEmail();
        if (!newEmail.matches("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$")) {
            throw new RegistroIncorretoException("O email informado esta incorreto.");
        }

        if (newEmail != null && !newEmail.equals(user.getEmail())) {
            User existingUser = repository.findByEmail(newEmail);
            if (existingUser != null) {
                throw new RegistroIncorretoException("Este email ja esta sendo usado por outro usuario.");
            }
            user.setEmail(newEmail);
        } else if (newEmail == null) {

            throw new RegistroIncorretoException("O novo email não pode ser nulo.");
        }

        return repository.save(user);
    }



    public User updateUserData(Long id, UserUpdateForm formUpdate) {
        User user = get(id);
        if (user == null) {
            throw new BadCredentialsException("Usuário não encontrado.");
        }

        String newName = formUpdate.getNome();
        if (newName != null) {
            user.setNome(newName);
        }

        String newLastName = formUpdate.getSobrenome();
        if (newLastName != null) {
            user.setSobrenome(newLastName);
        }

        String newCity = formUpdate.getCidade();
        if (newCity != null) {
            user.setCidade(newCity);
        }

        String newState = formUpdate.getEstado();
        if (newState != null) {
            user.setEstado(newState);
        }

        String newBio = formUpdate.getBio();
        if (newBio != null) {
            user.setBio(newBio);
        }

        LocalDate newBirthdate = formUpdate.getDataDeNascimento();
        if (newBirthdate != null) {
            user.setDataDeNascimento(newBirthdate);
        }

        String newWeight = formUpdate.getPeso();
        if (newWeight != null) {
            user.setPeso(newWeight);
        }

        String newImageUrl = formUpdate.getImageUrl();
        if (newImageUrl != null) {
            user.setImageUrl(newImageUrl);
        }

        return repository.save(user);
    }

    @Override
    public User get(Long id) {
        return repository.findById(id).orElse(null);
    }

    @Override
    public List<User> getAll(String nome) {
        if (nome == null) {
            return repository.findAll();
        } else {
            return repository.findByNomeContainingIgnoreCase(nome);
        }
    }

    @Override
    public boolean delete(Long id) {
        try {
            repository.deleteById(id);
            return true;
        } catch (EmptyResultDataAccessException ex) {
            return false;
        }
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
        @Override
        public User getByNome(String nome) {
            return repository.findByNome(nome);
    }

    @Override
    public User update(Long id, UserUpdateForm formUpdate) {
        return null;
    }

    @Override
    public boolean checkEmailExists(String email) {
        User user = repository.findByEmail(email);
        return user != null;

    }

    @Override
    public User getUserByEmail(String email) {
        return repository.findByEmail(email);
    }
    @Override
    public User saveUser(User user) {
        return repository.save(user);
    }

}

