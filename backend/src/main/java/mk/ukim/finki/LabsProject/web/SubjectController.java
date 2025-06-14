package mk.ukim.finki.LabsProject.web;

import jakarta.validation.Valid;
import mk.ukim.finki.LabsProject.model.Subject;
import mk.ukim.finki.LabsProject.model.dto.CreateSubjectDTO;
import mk.ukim.finki.LabsProject.model.dto.SubjectDTO;
import mk.ukim.finki.LabsProject.service.interfaces.SubjectService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import lombok.AllArgsConstructor;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/subjects")
@AllArgsConstructor
public class SubjectController {

    private final SubjectService subjectService;

    @GetMapping
    @PreAuthorize("hasRole('PROFESSOR')")
    public ResponseEntity<List<SubjectDTO>> getAllSubjects() {
        List<SubjectDTO> subjects = subjectService.getAllSubjects();
        return ResponseEntity.ok(subjects);
    }

    @PostMapping
    @PreAuthorize("hasRole('PROFESSOR')")
    public ResponseEntity<SubjectDTO> createSubject(@RequestBody @Valid CreateSubjectDTO requestDTO) {
        SubjectDTO createdSubjectDTO = subjectService.create(requestDTO);
        return ResponseEntity.ok(createdSubjectDTO);
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasRole('PROFESSOR')")
    public ResponseEntity<SubjectDTO> getSubjectById(@PathVariable UUID id) {
        SubjectDTO subject = subjectService.findById(id);
        return ResponseEntity.ok(subject);
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('PROFESSOR')")
    public ResponseEntity<SubjectDTO> updateSubject(@PathVariable UUID id, @RequestBody Subject subject) {
        SubjectDTO subjectDTO = subjectService.update(id, subject);
        return ResponseEntity.ok(subjectDTO);
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('PROFESSOR')")
    public ResponseEntity<Void> deleteSubject(@PathVariable UUID id) {
        subjectService.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}