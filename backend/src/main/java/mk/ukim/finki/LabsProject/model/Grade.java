package mk.ukim.finki.LabsProject.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.annotation.Nullable;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import mk.ukim.finki.LabsProject.model.dto.StudentSessionDTO;

import java.util.UUID;

/**
 * Represents a grade entity.
 * A grade is a grade that a student has received for a session.
 * A grade has points, max points and an (optional) note.
 */

@Data
@Entity
@NoArgsConstructor
@AllArgsConstructor
public class Grade {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    private Integer points;
    private Integer maxPoints;
    @Nullable
    private String note;


    @JsonBackReference // References back to StudentSession
    @OneToOne
    private StudentSession studentSession;

    public Grade(Integer points, Integer maxPoints, String note, StudentSession studentSession) {
        this.points = points;
        this.maxPoints = maxPoints;
        this.note = note;
        this.studentSession = studentSession;
    }

    public Grade(Integer points, Integer maxPoints, String note, StudentSessionDTO studentSession) {

    }
}
