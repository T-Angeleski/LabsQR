package mk.ukim.finki.LabsProject.model.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import mk.ukim.finki.LabsProject.model.User;
import mk.ukim.finki.LabsProject.model.enums.Role;

import java.util.Date;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Data
@NoArgsConstructor
public class UserResponseDTO {
    private UUID id;
    private String fullName;
    private String email;
    private Role role;
    private String index;
    private Date createdAt;

    public static UserResponseDTO from(User user) {
        UserResponseDTO dto = new UserResponseDTO();
        dto.setId(user.getId());
        dto.setFullName(user.getFullName());
        dto.setEmail(user.getEmail());
        dto.setRole(user.getRole());
        dto.setIndex(user.getIndex());
        dto.setCreatedAt(user.getCreatedAt());
        return dto;
    }

    public static List<UserResponseDTO> from(List<User> users) {
        return users.stream()
                .map(UserResponseDTO::from)
                .collect(Collectors.toList());
    }
}
