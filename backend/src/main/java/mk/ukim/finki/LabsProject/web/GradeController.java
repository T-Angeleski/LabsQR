package mk.ukim.finki.LabsProject.web;

import jakarta.validation.Valid;
import mk.ukim.finki.LabsProject.model.Grade;
import mk.ukim.finki.LabsProject.model.dto.GradeDTO;
import mk.ukim.finki.LabsProject.service.interfaces.GradeService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/grades")
public class GradeController {

    private final GradeService gradeService;

    public GradeController(GradeService gradeService) {
        this.gradeService = gradeService;
    }

    @PostMapping
    public ResponseEntity<?> createOrUpdateGrade(@Valid @RequestBody GradeDTO gradeDTO) {
        Grade savedGrade = gradeService.save(gradeDTO);
        return ResponseEntity.ok(GradeDTO.from(savedGrade));
    }

    @GetMapping("/student-session/{studentSessionId}")
    public ResponseEntity<GradeDTO> getGradeForStudentSession(
            @PathVariable UUID studentSessionId) {
        return gradeService.getGradeDTOByStudentSessionId(studentSessionId)
                .map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }
}