package mk.ukim.finki.LabsProject.web;

import lombok.AllArgsConstructor;
import mk.ukim.finki.LabsProject.model.Session;
import mk.ukim.finki.LabsProject.model.StudentSession;
import mk.ukim.finki.LabsProject.model.User;
import mk.ukim.finki.LabsProject.service.interfaces.SessionService;
import mk.ukim.finki.LabsProject.service.interfaces.StudentSessionService;
import mk.ukim.finki.LabsProject.service.interfaces.UserService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;

@AllArgsConstructor
@RestController
@RequestMapping("/api/student-sessions")
public class StudentSessionController {
    private final StudentSessionService studentSessionService;
    private final SessionService sessionService;
    private final UserService userService;

    @PostMapping("/join/{sessionId}/student/{studentId}")
    public ResponseEntity<StudentSession> joinSession(@PathVariable UUID sessionId, @PathVariable UUID studentId) {
        User student = userService.getStudentById(studentId);
        Session session = sessionService.getSessionById(sessionId);

        return ResponseEntity.ok(studentSessionService.createStudentSession(student, session));
    }
}
