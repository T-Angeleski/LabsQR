package mk.ukim.finki.LabsProject.model.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import mk.ukim.finki.LabsProject.model.User;

@Data
@NoArgsConstructor
public class LoginRequestDTO {
    private String email;
    private String password;

    public User toUser() {
        User user = new User();
        user.setEmail(this.email);
        user.setPassword(this.password);
        return user;
    }
}
