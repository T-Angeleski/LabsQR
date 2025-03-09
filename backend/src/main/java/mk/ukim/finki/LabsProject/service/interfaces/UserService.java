package mk.ukim.finki.LabsProject.service.interfaces;

import mk.ukim.finki.LabsProject.model.User;
import mk.ukim.finki.LabsProject.model.enums.Role;

import java.util.List;
import java.util.UUID;

public interface UserService {
    void register(String username, String password, String repeatPassword, String name, String surname, String role);

    void login(String username, String password);

    void logout();

    User getStudentById(UUID studentId);

    List<User> getUsersByRole(Role roleProfessor);

    List<User> findByRole(Role role);
}
