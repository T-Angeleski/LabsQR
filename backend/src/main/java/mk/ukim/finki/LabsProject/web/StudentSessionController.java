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
        UUID sessionUuid = UUID.fromString(sessionId);
        UUID studentUuid = UUID.fromString(studentId);

        Map<String, String> response = studentSessionService.joinSession(studentUuid, sessionUuid);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/{sessionId}")
    public ResponseEntity<?> getStudentSessionsBySessionId(@PathVariable String sessionId) {
        UUID sessionUuid = UUID.fromString(sessionId);
        return ResponseEntity.ok(studentSessionService.getStudentSessionsBySessionId(sessionUuid));
    }
}
