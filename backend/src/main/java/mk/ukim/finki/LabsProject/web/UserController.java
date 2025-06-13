package mk.ukim.finki.LabsProject.web;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.AllArgsConstructor;
import mk.ukim.finki.LabsProject.model.User;
import mk.ukim.finki.LabsProject.model.dto.UserResponseDTO;
import mk.ukim.finki.LabsProject.model.enums.Role;
import mk.ukim.finki.LabsProject.service.interfaces.UserService;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

@AllArgsConstructor
@RestController
@RequestMapping("/api/users")
@Tag(name = "Users", description = "User management endpoints")
public class UserController {
    private final UserService userService;

    @Operation(summary = "Get all professors", security = @SecurityRequirement(name = "bearerAuth"))
    @GetMapping("/teachers")
    public ResponseEntity<List<UserResponseDTO>> getProfessors() {
        List<UserResponseDTO> professors = userService.getUsersByRole(Role.ROLE_PROFESSOR);
        return ResponseEntity.ok(professors);
    }

    @Operation(summary = "Get current authenticated user", security = @SecurityRequirement(name = "bearerAuth"))
    @GetMapping("/me")
    public ResponseEntity<UserResponseDTO> authenticatedUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        User currentUser = (User) authentication.getPrincipal();
        return ResponseEntity.ok(UserResponseDTO.from(currentUser));
    }

    @Operation(summary = "Get all users", security = @SecurityRequirement(name = "bearerAuth"))
    @GetMapping("/")
    public ResponseEntity<List<UserResponseDTO>> allUsers() {
        List<UserResponseDTO> users = userService.allUsers();
        return ResponseEntity.ok(users);
    }
}