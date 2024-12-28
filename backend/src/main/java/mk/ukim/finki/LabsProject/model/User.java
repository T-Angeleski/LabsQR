package mk.ukim.finki.LabsProject.model;

import jakarta.annotation.Nullable;
import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import mk.ukim.finki.LabsProject.model.enums.Role;

import java.util.List;
import java.util.UUID;

/**
 * Represents a user entity.
 * A user can be a student or a professor (for now).
 */

@Data
@Entity
@Table(name = "users")
@NoArgsConstructor
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private UUID id;

    private String name;
    private String email;
    private String password;
    @Enumerated(EnumType.STRING)
    private Role role;
    @Nullable
    private String index;

    @OneToMany(mappedBy = "teacher")
    private List<Session> sessions = List.of();

    @OneToMany(mappedBy = "student")
    private List<StudentSession> studentSessions = List.of();

    public User(String name, String email, String password, Role role, @Nullable String index) {
        this.name = name;
        this.email = email;
        this.password = password;
        this.role = role;
        this.index = index;
    }
}
