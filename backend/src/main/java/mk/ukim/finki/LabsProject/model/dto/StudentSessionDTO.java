package mk.ukim.finki.LabsProject.model.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import mk.ukim.finki.LabsProject.model.StudentSession;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Data
@NoArgsConstructor
public class StudentSessionDTO {
    private UUID id;
    private UUID sessionId;
    private UUID studentId;
    private LocalDateTime joinedAt;
    private boolean attendanceChecked;
    private String subjectName;
    private String studentName;
    private String studentIndex;
    private GradeDTO grade;

    public static StudentSessionDTO from(StudentSession studentSession) {
        StudentSessionDTO dto = new StudentSessionDTO();
        dto.setId(studentSession.getId());
        dto.setJoinedAt(studentSession.getJoinedAt());
        dto.setAttendanceChecked(studentSession.isAttendanceChecked());
        dto.setSessionId(studentSession.getSession().getId());
        dto.setSubjectName(studentSession.getSession().getSubject().getName());
        dto.setStudentId(studentSession.getStudent().getId());
        dto.setStudentName(studentSession.getStudent().getFullName());
        dto.setStudentIndex(studentSession.getStudent().getIndex());

        if (studentSession.getGrade() != null) {
            dto.setGrade(GradeDTO.from(studentSession.getGrade()));
        }

        return dto;
    }

    public static List<StudentSessionDTO> from(List<StudentSession> studentSessions) {
        return studentSessions.stream()
                .map(StudentSessionDTO::from)
                .collect(Collectors.toList());
    }
}
