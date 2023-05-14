package com.musclemate.server.service;

import com.musclemate.server.entity.User;
import com.musclemate.server.entity.form.UserForm;
import com.musclemate.server.entity.form.UserUpdateForm;

import javax.naming.AuthenticationException;
import java.util.List;

public interface IUserService {

    User create(UserForm form);

    User login(String email, String password) throws AuthenticationException;

    User get(Long id);

    List<User> getAll(String dataDeNascimento);

    User getByNome(String nome);

    User update(Long id, UserUpdateForm formUpdate);

    boolean delete(Long id);


    boolean checkEmailExists(String email);

    User getUserByEmail(String email);

    User saveUser(User user);
}
