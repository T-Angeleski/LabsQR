package mk.ukim.finki.LabsProject.model;

import jakarta.annotation.Nullable;
import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

/**
 * Represents a grade entity.
 * A grade is a grade that a student has received for a session.
 * A grade has points, max points and an (optional) note.
 */

@Data
@Entity
@NoArgsConstructor
public class Grade {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    private Integer points;
    private Integer maxPoints;
    @Nullable
    private String note;

    @OneToOne
    private StudentSession studentSession;

}
