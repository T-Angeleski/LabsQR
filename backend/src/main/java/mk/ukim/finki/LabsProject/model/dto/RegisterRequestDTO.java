package mk.ukim.finki.LabsProject.model.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import mk.ukim.finki.LabsProject.model.User;
import mk.ukim.finki.LabsProject.model.enums.Role;

@Data
@NoArgsConstructor
public class RegisterRequestDTO {
    private String fullName;
    private String email;
    private String password;
    private Role role;
    private String index;

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
