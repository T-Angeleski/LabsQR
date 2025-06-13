package mk.ukim.finki.LabsProject.web;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import mk.ukim.finki.LabsProject.model.Session;
import mk.ukim.finki.LabsProject.model.dto.CreateSessionRequestDTO;
import mk.ukim.finki.LabsProject.model.dto.SessionDTO;
import mk.ukim.finki.LabsProject.service.interfaces.SessionService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@AllArgsConstructor
@RestController
@RequestMapping("/api/sessions")
@Tag(name = "Session Management")
public class SessionController {
    private final SessionService sessionService;

    @GetMapping("/sessions")
    @Operation(summary = "Get all sessions", description = "Returns a list of all available sessions")
    public ResponseEntity<List<SessionDTO>> getSessions() {
        return ResponseEntity.ok(sessionService.getAllSessions());
    }

    @GetMapping("/{sessionId}")
    public ResponseEntity<SessionDTO> getSession(@PathVariable UUID sessionId) {
        return ResponseEntity.ok(sessionService.getSessionById(sessionId));
    }

    @PostMapping("/create")
    public ResponseEntity<SessionDTO> createSession(@RequestBody @Valid CreateSessionRequestDTO requestDTO) {
        SessionDTO createdSession = sessionService.createSession(requestDTO);
        return ResponseEntity.ok(createdSession);
    }
}
