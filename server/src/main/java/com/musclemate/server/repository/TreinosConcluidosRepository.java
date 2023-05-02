package com.musclemate.server.repository;

import com.musclemate.server.entity.TreinosConcluidos;
import com.musclemate.server.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface TreinosConcluidosRepository extends JpaRepository<TreinosConcluidos, Long> {
    List<TreinosConcluidos> findByDataDoTreino(LocalDate dataDoTreino);

    List<TreinosConcluidos> findAllTreinosById(String usuario_id);

    List<TreinosConcluidos> findAllByUser(User user);
}
