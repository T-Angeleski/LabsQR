package mk.ukim.finki.LabsProject.model.dto;

import jakarta.validation.constraints.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import mk.ukim.finki.LabsProject.model.User;
import mk.ukim.finki.LabsProject.model.enums.Role;

@Data
@NoArgsConstructor
public class RegisterRequestDTO {
    @NotBlank(message = "Full name is required")
    private String fullName;

    @NotBlank(message = "Email is required")
    @Email(message = "Email should be valid")
    private String email;

    @NotBlank(message = "Password is required")
    @Size(min = 6, message = "Password but be at least 6 characters")
    private String password;

    @NotNull(message = "Role is required")
    private Role role;

    private String index;

    @AssertTrue(message = "Index is required for students")
    private boolean isIndexValid() {
        return role != Role.ROLE_STUDENT || (index != null && !index.isEmpty());
    }

    public User toUser() {
        User user = new User();
        user.setFullName(this.fullName);
        user.setEmail(this.email);
        user.setPassword(this.password);
        user.setRole(this.role);
        user.setIndex(this.index);
        return user;
    }
}
