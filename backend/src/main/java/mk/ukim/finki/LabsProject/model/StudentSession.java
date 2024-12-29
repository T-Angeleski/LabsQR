package mk.ukim.finki.LabsProject.model;

import jakarta.persistence.*;
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
public class StudentSession {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    private LocalDateTime joinedAt;
    private boolean attendanceChecked;

    @ManyToOne
    private Session session;

    @OneToOne
    private User student;

    @OneToOne
    private QRCode qrCode;
}
