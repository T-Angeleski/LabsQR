package mk.ukim.finki.LabsProject.web;

import lombok.AllArgsConstructor;
import mk.ukim.finki.LabsProject.service.interfaces.StudentSessionService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@AllArgsConstructor
@RestController
@RequestMapping("/api/student-sessions")
public class StudentSessionController {
    private final StudentSessionService studentSessionService;

    @PostMapping("/join/{sessionId}/student/{studentId}")
    public ResponseEntity<Map<String, String>> joinSession(
            @PathVariable String sessionId,
            @PathVariable String studentId
    ) {
        try {
            UUID sessionUuid = UUID.fromString(sessionId);
            UUID studentUuid = UUID.fromString(studentId);

            Map<String, String> response = studentSessionService.joinSession(studentUuid, sessionUuid);
            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("error", "Invalid UUID format"));
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(Map.of("error", "Failed to join session: " + e.getMessage()));
        }
    }

    @GetMapping("/{sessionId}")
    public ResponseEntity<?> getStudentSessionsBySessionId(@PathVariable String sessionId) {
        try {
            UUID sessionUuid = UUID.fromString(sessionId);
            return ResponseEntity.ok(studentSessionService.getStudentSessionsBySessionId(sessionUuid));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body("Invalid session ID format");
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body("Error fetching student sessions: " + e.getMessage());
        }
    }
}
