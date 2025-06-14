package mk.ukim.finki.LabsProject.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Represents a student session entity.
 * A student session is a session that a student has joined.
 */

@Data
@Entity
@NoArgsConstructor
@AllArgsConstructor
public class StudentSession {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    private LocalDateTime joinedAt;
    private boolean attendanceChecked;

    @JsonBackReference("session-studentSession")
    @ManyToOne
    private Session session;

    @JsonBackReference("student-studentSession")
    @ManyToOne
    private User student;

    @JsonManagedReference
    @OneToOne(mappedBy = "studentSession", cascade = CascadeType.ALL, orphanRemoval = true)
    private Grade grade;
}

