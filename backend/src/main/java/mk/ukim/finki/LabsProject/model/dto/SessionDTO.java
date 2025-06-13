package mk.ukim.finki.LabsProject.model.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import mk.ukim.finki.LabsProject.model.Session;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Data
@NoArgsConstructor
public class SessionDTO {
    private UUID id;
    private UUID teacherId;
    private UUID subjectId;
    private int durationInMinutes;
    private LocalDateTime createdAt;
    private String teacherName;
    private String subjectName;
    private boolean isExpired;

    public static SessionDTO from(Session session) {
        SessionDTO dto = new SessionDTO();
        dto.setId(session.getId());
        dto.setCreatedAt(session.getCreatedAt());
        dto.setDurationInMinutes(session.getDurationInMinutes());
        dto.setTeacherId(session.getTeacher().getId());
        dto.setTeacherName(session.getTeacher().getFullName());
        dto.setSubjectId(session.getSubject().getId());
        dto.setSubjectName(session.getSubject().getName());
        dto.setExpired(session.isExpired());
        return dto;
    }

    public static List<SessionDTO> from(List<Session> sessions) {
        return sessions.stream()
                .map(SessionDTO::from)
                .collect(Collectors.toList());
    }
}