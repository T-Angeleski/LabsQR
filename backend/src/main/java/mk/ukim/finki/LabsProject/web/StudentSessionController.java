package mk.ukim.finki.LabsProject.web;

import mk.ukim.finki.LabsProject.model.Session;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;

@RestController
@RequestMapping("/api/student-sessions")
public class StudentSessionController {
//    private final StudentSessionService studentSessionService;

    @PostMapping("/join/{sessionId}/student/{studentId}")
    public ResponseEntity<Session> joinSession(@PathVariable UUID sessionId, @PathVariable UUID studentId) {
        // TODO: Implement this
        return ResponseEntity.ok(null);
    }
}
