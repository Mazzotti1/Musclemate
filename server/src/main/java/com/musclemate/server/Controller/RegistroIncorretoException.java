package com.musclemate.server.Controller;

public class RegistroIncorretoException extends RuntimeException {
    public RegistroIncorretoException(String message) {
        super(message);
    }
}
