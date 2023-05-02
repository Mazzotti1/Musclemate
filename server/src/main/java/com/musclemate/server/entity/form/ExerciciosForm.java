package com.musclemate.server.entity.form;

import jakarta.validation.constraints.NotEmpty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ExerciciosForm {

    @NotEmpty(message = "Preencha o campo corretamente.")
    private String grupoMuscular;

    @NotEmpty(message = "Preencha o campo corretamente.")
    private String nomeExercicio;
}
