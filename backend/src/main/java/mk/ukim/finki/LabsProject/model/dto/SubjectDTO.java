package mk.ukim.finki.LabsProject.model.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import mk.ukim.finki.LabsProject.model.Subject;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;


@Data
@NoArgsConstructor
public class SubjectDTO {
    private UUID id;
    private String name;

    public static SubjectDTO from(Subject subject) {
        SubjectDTO dto = new SubjectDTO();
        dto.setId(subject.getId());
        dto.setName(subject.getName());
        return dto;
    }

    public static List<SubjectDTO> from(List<Subject> subjects) {
        return subjects.stream()
                .map(SubjectDTO::from)
                .collect(Collectors.toList());
    }

    public static Subject toEntity(SubjectDTO dto) {
        Subject subject = new Subject();
        subject.setId(dto.getId());
        subject.setName(dto.getName());
        return subject;
    }
}
