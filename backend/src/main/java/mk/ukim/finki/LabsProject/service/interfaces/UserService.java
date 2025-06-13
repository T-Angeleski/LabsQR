package mk.ukim.finki.LabsProject.service.interfaces;

import mk.ukim.finki.LabsProject.model.User;
import mk.ukim.finki.LabsProject.model.dto.UserResponseDTO;
import mk.ukim.finki.LabsProject.model.enums.Role;

import java.util.List;
import java.util.UUID;

public interface UserService {
    List<UserResponseDTO> allUsers();

    UserResponseDTO getStudentById(UUID studentId);

    List<UserResponseDTO> getUsersByRole(Role role);

}
