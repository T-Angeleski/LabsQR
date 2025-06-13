package mk.ukim.finki.LabsProject.model.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import mk.ukim.finki.LabsProject.model.Grade;
import mk.ukim.finki.LabsProject.model.StudentSession;

import java.util.UUID;

@Data
@NoArgsConstructor
public class GradeDTO {
    private UUID id;
    private UUID studentSessionId;
    private Integer points;
    private Integer maxPoints;
    private String note;

    public static GradeDTO from(Grade grade) {
        GradeDTO dto = new GradeDTO();
        dto.setId(grade.getId());
        dto.setPoints(grade.getPoints());
        dto.setMaxPoints(grade.getMaxPoints());
        dto.setNote(grade.getNote());
        dto.setStudentSessionId(grade.getStudentSession().getId());
        return dto;
    }

    public static Grade toEntity(GradeDTO dto, StudentSession studentSession) {
        Grade grade = new Grade();
        grade.setId(dto.getId());
        grade.setPoints(dto.getPoints());
        grade.setMaxPoints(dto.getMaxPoints());
        grade.setNote(dto.getNote());
        grade.setStudentSession(studentSession);
        return grade;
    }
}
