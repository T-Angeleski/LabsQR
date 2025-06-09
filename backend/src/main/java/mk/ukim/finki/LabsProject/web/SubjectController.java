package mk.ukim.finki.LabsProject.web;

import mk.ukim.finki.LabsProject.model.Subject;
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
    public ResponseEntity<List<Subject>> getAllSubjects() {
        List<Subject> subjects = subjectService.getAllSubjects();
        return ResponseEntity.ok(subjects);
    }


    @PostMapping
    @PreAuthorize("hasRole('PROFESSOR')")
    public ResponseEntity<Subject> createSubject(@RequestBody Subject subject) {
        Subject createdSubject = subjectService.save(subject);
        return ResponseEntity.ok(createdSubject);
    }

    @PreAuthorize("hasRole('PROFESSOR')")
    @GetMapping("/{id}")
    public ResponseEntity<Subject> getSubjectById(@PathVariable UUID id) {
        return subjectService.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('PROFESSOR')")
    public ResponseEntity<Subject> updateSubject(@PathVariable UUID id, @RequestBody Subject subject) {
        Optional<Subject> updatedSubject = subjectService.update(id, subject);

        return updatedSubject.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('PROFESSOR')")
    public ResponseEntity<Void> deleteSubject(@PathVariable UUID id) {
        subjectService.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}