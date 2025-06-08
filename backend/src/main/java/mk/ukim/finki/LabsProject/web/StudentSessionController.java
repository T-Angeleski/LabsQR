package mk.ukim.finki.LabsProject.web;

import lombok.AllArgsConstructor;
import mk.ukim.finki.LabsProject.model.User;
import mk.ukim.finki.LabsProject.service.interfaces.StudentSessionService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@AllArgsConstructor
@RestController
@RequestMapping("/api/student-sessions")
public class StudentSessionController {
    private final StudentSessionService studentSessionService;

    @PreAuthorize("hasRole('STUDENT')")
    @PostMapping("/join/{sessionId}")
    public ResponseEntity<Map<String, String>> joinSession(
            @PathVariable String sessionId,
            @AuthenticationPrincipal User user
    ) {
        UUID sessionUuid = UUID.fromString(sessionId);
        Map<String, String> response = studentSessionService.joinSession(user.getId(), sessionUuid);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/{sessionId}")
    public ResponseEntity<?> getStudentSessionsBySessionId(@PathVariable String sessionId) {
        UUID sessionUuid = UUID.fromString(sessionId);
        return ResponseEntity.ok(studentSessionService.getStudentSessionsBySessionId(sessionUuid));
    }
}
