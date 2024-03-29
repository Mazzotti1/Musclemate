package com.musclemate.server.entity.form;

import java.time.LocalDate;

public class UserUpdateForm {
    private String email;
    private String sobrenome;
    private String cidade;
    private String estado;
    private String bio;
    private String genero;
    private String peso;
    private String nome;
    private String imageUrl;
    private String followers;
    private String following;
    private LocalDate dataDeNascimento;

    public String getEmail() {
        return email;
    }

    public String getSobrenome() {
        return sobrenome;
    }

    public String getCidade() {
        return cidade;
    }

    public String getEstado() {
        return estado;
    }

    public String getBio() {
        return bio;
    }

    public LocalDate getDataDeNascimento() {
        return dataDeNascimento;
    }

    public String getPeso() {
        return peso;
    }

    public String getNome() {
        return nome;
    }
    public String getImageUrl() {
        return imageUrl;
    }

    private boolean likeNotification;
    private boolean commentNotification;
    private boolean followNotification;

    private String fcmToken;

    public String getFcmToken() {
        return fcmToken;
    }
    public void setFcmToken(String fcmToken) {
        this.fcmToken = fcmToken;
    }

    public boolean isLikeNotification() {
        return likeNotification;
    }

    public boolean isCommentNotification() {
        return commentNotification;
    }

    public boolean isFollowNotification() {
        return followNotification;
    }

    public Boolean getLikeNotification() {
        return likeNotification;
    }

    public Boolean getCommentNotification() {
        return commentNotification;
    }

    public Boolean getFollowNotification() {
        return followNotification;
    }
}
