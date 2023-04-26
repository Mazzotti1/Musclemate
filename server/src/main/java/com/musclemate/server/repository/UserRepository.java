package com.musclemate.server.repository;

import com.musclemate.server.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    List<User> findByDataDeNascimento(LocalDate dataDeNascimento);
    User findByEmail(String email);
}
