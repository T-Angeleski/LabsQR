package mk.ukim.finki.LabsProject.model.exceptions;

public class InvalidCredentialsException extends RuntimeException {
    public InvalidCredentialsException(String message) {
        super("Invalid email or password");
    }
}
