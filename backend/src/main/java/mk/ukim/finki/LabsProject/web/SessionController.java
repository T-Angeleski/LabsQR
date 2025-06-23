package mk.ukim.finki.LabsProject.web;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import mk.ukim.finki.LabsProject.model.dto.CreateSessionRequestDTO;
import mk.ukim.finki.LabsProject.model.dto.SessionDTO;
import mk.ukim.finki.LabsProject.service.interfaces.SessionService;
import mk.ukim.finki.LabsProject.util.QRCodeGenerator;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@AllArgsConstructor
@RestController
@RequestMapping("/api/sessions")
@Tag(name = "Session Management")
public class SessionController {
    private final SessionService sessionService;

//    @PreAuthorize("hasRole('PROFESSOR')") Temporary visible to all for testing on app
    @GetMapping("/sessions")
    @Operation(summary = "Get all sessions", description = "Returns a list of all available sessions")
    public ResponseEntity<List<SessionDTO>> getSessions() {
        return ResponseEntity.ok(sessionService.getAllSessions());
    }

//    @PreAuthorize("hasRole('PROFESSOR')")
    @GetMapping("/{sessionId}")
    public ResponseEntity<SessionDTO> getSession(@PathVariable UUID sessionId) {
        return ResponseEntity.ok(sessionService.getSessionById(sessionId));
    }

    @PreAuthorize("hasRole('PROFESSOR')")
    @PostMapping("/create")
    public void createSession(
            @RequestBody @Valid CreateSessionRequestDTO requestDTO
    ) {
        sessionService.createSession(requestDTO);
    }

    @PreAuthorize("hasRole('PROFESSOR')")
    @GetMapping("/qr-code/{sessionId}")
    public ResponseEntity<Map<String, String>> getSessionQRCode(@PathVariable UUID sessionId) {
        SessionDTO session = sessionService.getSessionById(sessionId);
        if (session == null) {
            return ResponseEntity.notFound().build();
        }

        String qrCodeBase64 = Base64.getEncoder().encodeToString(session.getQrCode());

        Map<String, String> response = new HashMap<>();
        response.put("session", session.getId().toString());
        response.put("qrCode", qrCodeBase64);

        return ResponseEntity.ok(response);
    }
}
