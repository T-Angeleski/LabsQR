package mk.ukim.finki.LabsProject.model;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class LoginResponse {

    private String token;

    private long expiresIn;

}