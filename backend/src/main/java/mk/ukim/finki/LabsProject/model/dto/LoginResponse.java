package mk.ukim.finki.LabsProject.model.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class LoginResponse {

    private String token;

    private long expiresIn;

}