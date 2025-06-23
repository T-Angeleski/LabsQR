package mk.ukim.finki.LabsProject.model;


import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;


/**
 * Represents a session entity.
 * A session is a class that a teacher has created.
 * Multiple students can join a session.
 */

@Data
@Entity
@NoArgsConstructor
public class Session {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    private LocalDateTime createdAt;
    private int durationInMinutes;

    @JsonBackReference("teacher-session")
    @ManyToOne
    private User teacher;

    @JsonManagedReference("session-studentSession")
    @OneToMany(mappedBy = "session")
    private List<StudentSession> studentSessions = List.of();

    @ManyToOne(fetch = FetchType.EAGER)
    private Subject subject;

    @Lob
    @Column(name = "qr_code")
    private byte[] qrCode;

    public boolean isExpired() {
        return LocalDateTime.now().isAfter(createdAt.plusMinutes(durationInMinutes));
    }

}
