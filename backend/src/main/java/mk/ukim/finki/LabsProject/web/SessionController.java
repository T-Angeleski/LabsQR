package mk.ukim.finki.LabsProject.web;

import mk.ukim.finki.LabsProject.model.Session;
import mk.ukim.finki.LabsProject.service.interfaces.SessionService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/sessions")
public class SessionController {
    private final SessionService sessionService;

    public SessionController(SessionService sessionService) {
        this.sessionService = sessionService;
    }

    @GetMapping("/sessions")
    public ResponseEntity<List<Session>> getSessions() {
        return ResponseEntity.ok(sessionService.getAllSessions());
    }

    @GetMapping("/{sessionId}")
    public ResponseEntity<Session> getSession(@PathVariable UUID sessionId) {
        return ResponseEntity.ok(sessionService.getSessionById(sessionId));
    }

    @PostMapping("/create")
    public ResponseEntity<Session> createSession(Session session) {
        return ResponseEntity.ok(sessionService.createSession(session));
    }
}
