package mk.ukim.finki.LabsProject.service.implementations;

import lombok.AllArgsConstructor;
import mk.ukim.finki.LabsProject.model.User;
import mk.ukim.finki.LabsProject.model.enums.Role;
import mk.ukim.finki.LabsProject.repository.UserRepository;
import mk.ukim.finki.LabsProject.service.interfaces.UserService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@AllArgsConstructor
@Service
public class UserServiceImpl implements UserService {
    private final UserRepository userRepository;

    @Override
    public void register(String username, String password, String repeatPassword, String name, String surname, String role) {
        throw new Error("Not implemented");
    }

    @Override
    public void login(String username, String password) {
        throw new Error("Not implemented");
    }

    @Override
    public void logout() {
        throw new Error("Not implemented");
    }

    @Override
    public User getStudentById(UUID studentId) {
        return userRepository.findById(studentId)
                .orElseThrow(() -> new IllegalArgumentException("Student not found"));
    }

    @Override
    public List<User> getUsersByRole(Role role) {
        return userRepository.findByRole(role);
    }
}
