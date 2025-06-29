package mk.ukim.finki.LabsProject.web;

import lombok.AllArgsConstructor;
import mk.ukim.finki.LabsProject.model.User;
import mk.ukim.finki.LabsProject.model.dto.StudentSessionDTO;
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
    public ResponseEntity<StudentSessionDTO> joinSession(@PathVariable String sessionId,  @AuthenticationPrincipal User user) {
        UUID sessionUuid = UUID.fromString(sessionId);
        StudentSessionDTO response = studentSessionService.joinSession(user.getId(), sessionUuid);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/{sessionId}")
    public ResponseEntity<List<StudentSessionDTO>> getStudentSessionsBySessionId(@PathVariable String sessionId) {
        UUID sessionUuid = UUID.fromString(sessionId);
        List<StudentSessionDTO> studentSessionDTOS = studentSessionService.getStudentSessionsBySessionId(sessionUuid);
        return ResponseEntity.ok(studentSessionDTOS);
    }

    @GetMapping("/user/{userId}")
    @PreAuthorize("hasRole('STUDENT')")
    public ResponseEntity<StudentSessionDTO> getStudentSessionByUser(@PathVariable String userId) {
        UUID userUuid = UUID.fromString(userId);
        StudentSessionDTO dto = studentSessionService.getStudentSessionByStudentId(userUuid);
        return ResponseEntity.ok(dto);
    }

    @GetMapping("/user/{userId}/active")
    @PreAuthorize("hasRole('STUDENT')")
    public ResponseEntity<StudentSessionDTO> getActiveStudentSessionByUser(@PathVariable String userId) {
        UUID userUuid = UUID.fromString(userId);
        StudentSessionDTO dto = studentSessionService.getStudentSessionByStudentIdAndIsFinishedFalse(userUuid);
        return ResponseEntity.ok(dto);
    }

    @GetMapping("/{userId}/{sessionId}")
    @PreAuthorize("hasRole('STUDENT')")
    public ResponseEntity<StudentSessionDTO> getStudentSessionByStudentIdAndSessionId(@PathVariable String userId, @PathVariable String sessionId) {
        UUID userUuid = UUID.fromString(userId);
        UUID sessionUuid = UUID.fromString(sessionId);
        StudentSessionDTO dto = studentSessionService.findByStudentIdAndSessionId(userUuid, sessionUuid);
        return ResponseEntity.ok(dto);
    }

    @PostMapping("/finish/{userId}/{studentSessionId}")
    @PreAuthorize("hasRole('STUDENT')")
    public ResponseEntity<StudentSessionDTO> finishSession(@PathVariable String userId, @PathVariable String studentSessionId) {
        UUID userUuid = UUID.fromString(userId);
        UUID studentSessionUuid = UUID.fromString(studentSessionId);
        StudentSessionDTO dto = studentSessionService.finishSession(userUuid, studentSessionUuid);
        return ResponseEntity.ok(dto);
    }

    @PostMapping("/attendance/{userId}/{studentSessionId}")
    @PreAuthorize("hasRole('PROFESSOR')")
    public ResponseEntity<StudentSessionDTO> markAttendance(@PathVariable String userId, @PathVariable String studentSessionId) {
        UUID userUuid = UUID.fromString(userId);
        UUID studentSessionUuid = UUID.fromString(studentSessionId);
        StudentSessionDTO dto = studentSessionService.markAttendance(userUuid, studentSessionUuid);
        return ResponseEntity.ok(dto);
    }

}
