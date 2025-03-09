package mk.ukim.finki.LabsProject.web;

import mk.ukim.finki.LabsProject.model.User;
import mk.ukim.finki.LabsProject.model.enums.Role;
import mk.ukim.finki.LabsProject.service.interfaces.UserService;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


@RestController
@RequestMapping("/api/users")
public class UserController{
    private final UserService userService;


    public UserController(UserService userService){
        this.userService = userService;
    }

    @GetMapping("/teachers")
    public ResponseEntity<List<User>> getProfessors() {
    List<User> professors = userService.getUsersByRole(Role.ROLE_PROFESSOR);
    return ResponseEntity.ok(professors);
}
}