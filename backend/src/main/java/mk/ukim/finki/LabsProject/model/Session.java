package mk.ukim.finki.LabsProject.model;


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
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private UUID id;

    private String subject; // TODO: Implement model class for this field
    private String qrCode;
    private LocalDateTime createdAt;
    private Integer durationInMinutes;

    @ManyToOne
    private User teacher;

    @OneToMany(mappedBy = "session")
    private List<StudentSession> studentSessions = List.of();

    public boolean isExpired() {
        return LocalDateTime.now().isAfter(createdAt.plusMinutes(durationInMinutes));
    }

}
