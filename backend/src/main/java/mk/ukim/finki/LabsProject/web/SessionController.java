package mk.ukim.finki.LabsProject.web;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import mk.ukim.finki.LabsProject.model.Session;
import mk.ukim.finki.LabsProject.service.interfaces.SessionService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/sessions")
@Tag(name = "Session Management")
public class SessionController {
    private final SessionService sessionService;

    public SessionController(SessionService sessionService) {
        this.sessionService = sessionService;
    }

    @GetMapping("/sessions")
    @Operation(summary = "Get all sessions", description = "Returns a list of all available sessions")
    public ResponseEntity<List<Session>> getSessions() {
        return ResponseEntity.ok(sessionService.getAllSessions());
    }

    @GetMapping("/{sessionId}")
    public ResponseEntity<Session> getSession(@PathVariable UUID sessionId) {
        return ResponseEntity.ok(sessionService.getSessionById(sessionId));
    }

    @PostMapping("/create")
    public ResponseEntity<Session> createSession(@RequestBody Session session) {

        Session createdSession = sessionService.createSession(session);
        return ResponseEntity.ok(createdSession);
    }
}
