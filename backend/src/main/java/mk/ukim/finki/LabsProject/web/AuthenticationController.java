package mk.ukim.finki.LabsProject.web;

import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import mk.ukim.finki.LabsProject.model.dto.LoginResponse;
import mk.ukim.finki.LabsProject.model.User;
import mk.ukim.finki.LabsProject.model.dto.LoginRequestDTO;
import mk.ukim.finki.LabsProject.model.dto.RegisterRequestDTO;
import mk.ukim.finki.LabsProject.model.dto.UserResponseDTO;
import mk.ukim.finki.LabsProject.service.interfaces.AuthenticationService;
import mk.ukim.finki.LabsProject.service.interfaces.JwtService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@AllArgsConstructor
@RequestMapping("/auth")
@RestController
public class AuthenticationController {
    private final JwtService jwtService;
    private final AuthenticationService authenticationService;

    @PostMapping("/signup")
    public ResponseEntity<UserResponseDTO> register(@RequestBody @Valid RegisterRequestDTO request) {
        User registeredUser = authenticationService.signup(request.toUser());
        return ResponseEntity.ok(UserResponseDTO.from(registeredUser));
    }

    @PostMapping("/login")
    public ResponseEntity<LoginResponse> authenticate(@RequestBody @Valid LoginRequestDTO request) {
        User authenticatedUser = authenticationService.authenticate(request.toUser());
        String jwtToken = jwtService.generateToken(authenticatedUser);

        LoginResponse loginResponse = new LoginResponse();
        loginResponse.setToken(jwtToken);
        loginResponse.setExpiresIn(jwtService.getExpirationTime());

        return ResponseEntity.ok(loginResponse);
    }
}