package com.musclemate.server.entity.form;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class TreinosConcluidoForm {

    @NotNull(message = "Preencha o campo corretamente.")
    private LocalDate dataDoTreino;

    @NotNull(message = "Preencha o campo corretamente.")
    private String tipoDeExercicio;

    @Positive(message = "Preencha o campo corretamente.")
    private int duracaoDoTreinoEmMinutos;

    @Positive(message = "Preencha o campo corretamente.")
    private int mediaDePesoUtilizado;

    @Positive(message = "Preencha o campo corretamente.")
    private int totalDeRepeticoes;

    @Positive(message = "Preencha o campo corretamente.")
    private int totalDeSeries;

}