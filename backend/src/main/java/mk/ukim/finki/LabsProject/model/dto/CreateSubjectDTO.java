package mk.ukim.finki.LabsProject.model.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.NoArgsConstructor;
import mk.ukim.finki.LabsProject.model.Subject;

import java.util.List;
import java.util.stream.Collectors;


@Data
@NoArgsConstructor
public class CreateSubjectDTO {
    @NotNull
    @NotBlank
    private String name;

    public static CreateSubjectDTO from(Subject subject) {
        CreateSubjectDTO dto = new CreateSubjectDTO();
        dto.setName(subject.getName());
        return dto;
    }

    public static List<CreateSubjectDTO> from(List<Subject> subjects) {
        return subjects.stream()
                .map(CreateSubjectDTO::from)
                .collect(Collectors.toList());
    }
}
