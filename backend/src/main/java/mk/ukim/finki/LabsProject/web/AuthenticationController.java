package mk.ukim.finki.LabsProject.web;

import lombok.AllArgsConstructor;
import mk.ukim.finki.LabsProject.model.LoginResponse;
import mk.ukim.finki.LabsProject.model.User;
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
    public ResponseEntity<User> register(@RequestBody User registerUser) {
        User registeredUser = authenticationService.signup(registerUser);

        return ResponseEntity.ok(registeredUser);
    }

    @PostMapping("/login")
    public ResponseEntity<LoginResponse> authenticate(@RequestBody User loginUser) {
        User authenticatedUser = authenticationService.authenticate(loginUser);

        String jwtToken = jwtService.generateToken(authenticatedUser);

        LoginResponse loginResponse = new LoginResponse();

        loginResponse.setToken(jwtToken);
        loginResponse.setExpiresIn(jwtService.getExpirationTime());

        return ResponseEntity.ok(loginResponse);
    }
}