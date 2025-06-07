package mk.ukim.finki.LabsProject.service.interfaces;

import mk.ukim.finki.LabsProject.model.User;

public interface AuthenticationService {
    User signup(User input);

    User authenticate(User input);
}
