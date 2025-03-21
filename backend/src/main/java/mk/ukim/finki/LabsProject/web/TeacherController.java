package mk.ukim.finki.LabsProject.web;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import lombok.AllArgsConstructor;
import mk.ukim.finki.LabsProject.model.StudentSession;
import mk.ukim.finki.LabsProject.service.interfaces.StudentSessionService;

@AllArgsConstructor
@RestController
@RequestMapping("/api/teacher-view")
public class TeacherController {

    private final StudentSessionService studentSessionService;

    @GetMapping("/{studentSessionId}")
    public ResponseEntity<Map<String, Object>> getStudentSessionDetails(@PathVariable UUID studentSessionId) {
        StudentSession studentSession = studentSessionService.getStudentSessionById(studentSessionId);

        Map<String, Object> response = new HashMap<>();
        response.put("studentName", studentSession.getStudent().getName());
        response.put("sessionId", studentSession.getSession().getId());
        response.put("joined_at", studentSession.getJoinedAt());
        response.put("qrcode", studentSession.getQrCode());
        response.put("attendance", studentSession.isAttendanceChecked());

        return ResponseEntity.ok(response);
    }

}