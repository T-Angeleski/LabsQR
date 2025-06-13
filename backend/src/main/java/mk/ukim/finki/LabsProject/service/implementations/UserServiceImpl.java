package mk.ukim.finki.LabsProject.service.implementations;

import lombok.AllArgsConstructor;
import mk.ukim.finki.LabsProject.model.User;
import mk.ukim.finki.LabsProject.model.dto.UserResponseDTO;
import mk.ukim.finki.LabsProject.model.enums.Role;
import mk.ukim.finki.LabsProject.model.exceptions.UserNotFoundException;
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
    public List<UserResponseDTO> allUsers() {
        List<User> users = userRepository.findAll();
        return UserResponseDTO.from(users);
    }

    @Override
    public UserResponseDTO getStudentById(UUID studentId) {
        if (studentId == null) {
            throw new IllegalArgumentException("Student ID cannot be null");
        }

        User student = userRepository.findById(studentId)
                .orElseThrow(() -> new UserNotFoundException("Student with ID " + studentId + " not found"));

        if (student.getRole() != Role.ROLE_STUDENT) {
            throw new IllegalArgumentException("User with ID " + studentId + " is not a student");
        }

        return UserResponseDTO.from(student);
    }

    @Override
    public List<UserResponseDTO> getUsersByRole(Role role) {
        List<User> users = userRepository.findAllByRole(role);
        return UserResponseDTO.from(users);
    }
}
