package mk.ukim.finki.LabsProject.model;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.annotation.Nullable;
import jakarta.persistence.*;
import lombok.*;
import mk.ukim.finki.LabsProject.model.enums.Role;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.authority.SimpleGrantedAuthority;


import java.util.Collection;
import java.util.Date;
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
public class User implements UserDetails {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false)
    private String fullName;

    @Column(unique = true, length = 100, nullable = false)
    private String email;

    @Column(nullable = false)
    private String password;

    @CreationTimestamp
    @Column(updatable = false, name = "created_at")
    private Date createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private Date updatedAt;

    @Enumerated(EnumType.STRING)
    private Role role;
    @Nullable
    private String index;

    public User(String fullName, String email, String password, Role role, @Nullable String index) {
        this.fullName = fullName;
        this.email = email;
        this.password = password;
        this.role = role;
        this.index = index;
    }

    @JsonManagedReference("teacher-session")
    @OneToMany(mappedBy = "teacher", fetch = FetchType.EAGER)
    private List<Session> sessions = List.of();

    @JsonManagedReference("student-studentSession")
    @OneToMany(mappedBy = "student", fetch = FetchType.EAGER)
    private List<StudentSession> studentSessions = List.of();

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return List.of(new SimpleGrantedAuthority(role.name()));
    }

    @Override
    public String getUsername() {
        return email;
    }

    @Override
    public String getPassword() {
        return password;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }
}
