package com.musclemate.server.entity.form;




import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;



import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserForm {

    @NotEmpty(message = "Preencha o campo corretamente.")
    @Size(min = 3, max =50, message = "'${validatedValue}' precisa estar entre {min} e {max} caracteres.")
    private String nome;

    @Size(min = 3, max =50, message = "'${validatedValue}' precisa estar entre {min} e {max} caracteres.")
    private String sobrenome;

    @NotEmpty(message = "Preencha o campo corretamente.")
    @Email(message = "'${validatedValue}' é inválido!")
    @Pattern(regexp = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", message = "O e-mail precisa ser válido.")
    private String email;

    @NotEmpty(message = "Preencha o campo corretamente.")
    @Size(min = 6, max =50, message = "'${validatedValue}' precisa estar entre {min} e {max} caracteres.")
    private String password;

    @Size(min = 3, max =50, message = "'${validatedValue}' precisa estar entre {min} e {max} caracteres.")
    private String cidade;

    @Size(min = 2, max =50, message = "'${validatedValue}' precisa estar entre {min} e {max} caracteres.")
    private String estado;

    private String bio;

    @Past(message = "Data '${validatedValue}' é inválida.")
    private LocalDate dataDeNascimento;

    private String peso;


}

