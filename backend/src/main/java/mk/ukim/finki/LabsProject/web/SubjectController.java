package mk.ukim.finki.LabsProject.web;

import mk.ukim.finki.LabsProject.model.dto.SubjectDTO;
import mk.ukim.finki.LabsProject.service.interfaces.SubjectService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import lombok.AllArgsConstructor;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@RestController
@RequestMapping("/api/subjects")
@AllArgsConstructor
public class SubjectController {

    private final SubjectService subjectService;

    @PreAuthorize("hasRole('PROFESSOR')")
    @GetMapping
    public ResponseEntity<List<SubjectDTO>> getAllSubjects() {
        List<SubjectDTO> subjects = subjectService.getAllSubjects();
        return ResponseEntity.ok(subjects);
    }
}