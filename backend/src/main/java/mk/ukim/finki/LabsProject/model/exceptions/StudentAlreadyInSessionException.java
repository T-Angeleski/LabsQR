package mk.ukim.finki.LabsProject.model.exceptions;

public class StudentAlreadyInSessionException extends RuntimeException {
    public StudentAlreadyInSessionException(String message) {
        super(message);
    }
}