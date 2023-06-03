package com.musclemate.server.repository;

import com.musclemate.server.entity.TreinosConcluidos;
import com.musclemate.server.entity.TreinosPadroes;
import com.musclemate.server.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface TreinosPadroesRepository extends JpaRepository<TreinosPadroes, Long> {
    List<TreinosPadroes> findAllTreinosById(String usuario_id);

    List<TreinosPadroes> findAllByUser(User user);
}
