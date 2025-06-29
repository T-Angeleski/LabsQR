package mk.ukim.finki.LabsProject.model.exceptions;

public class NoActiveSessionForStudentException extends RuntimeException{
    public NoActiveSessionForStudentException(String message) {
        super(message);
    }
}
