package mk.ukim.finki.LabsProject.web;

import lombok.AllArgsConstructor;
import mk.ukim.finki.LabsProject.model.QRCode;
import mk.ukim.finki.LabsProject.model.Session;
import mk.ukim.finki.LabsProject.model.StudentSession;
import mk.ukim.finki.LabsProject.model.User;
import mk.ukim.finki.LabsProject.service.interfaces.QRCodeService;
import mk.ukim.finki.LabsProject.service.interfaces.SessionService;
import mk.ukim.finki.LabsProject.service.interfaces.StudentSessionService;
import mk.ukim.finki.LabsProject.service.interfaces.UserService;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@AllArgsConstructor
@RestController
@RequestMapping("/api/student-sessions")
public class StudentSessionController {
    private final StudentSessionService studentSessionService;
    private final SessionService sessionService;
    private final UserService userService;
    @Qualifier("QRCodeService")
    private final QRCodeService qrCodeService;

    @PostMapping("/join/{sessionId}/student/{studentId}")
    public ResponseEntity<Map<String, String>> joinSession(
        @PathVariable String sessionId,
        @PathVariable String studentId
    ) {

        UUID sessionUuid;
        UUID studentUuid;
        try {
            sessionUuid = UUID.fromString(sessionId);
            studentUuid = UUID.fromString(studentId);
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("Invalid UUID format");
        }

        User student = userService.getStudentById(studentUuid);
        Session session = sessionService.getSessionById(sessionUuid);

        StudentSession studentSession = studentSessionService.createStudentSession(student, session);

        String teacherUrl = "http://localhost:8080/api/teacher-view/" + studentSession.getId();

        byte[] qrCodeImage = qrCodeService.generateQRCode(teacherUrl, 200, 200);

        String qrCodeBase64 = Base64.getEncoder().encodeToString(qrCodeImage);

        QRCode qrCode = new QRCode();
        qrCode.setQrCode(qrCodeImage);
        qrCode.setStudentSession(studentSession);
        studentSession.setQrCode(qrCode);

        studentSessionService.saveStudentSession(studentSession);

        Map<String, String> response = new HashMap<>();
        response.put("qrCode", qrCodeBase64);
        response.put("teacherUrl", teacherUrl);
        response.put("joinedAt", studentSession.getJoinedAt().toString());
        response.put("attendanceChecked", String.valueOf(studentSession.isAttendanceChecked()));
        return ResponseEntity.ok(response);

    }

    @GetMapping("/{sessionId}")
    public ResponseEntity<?> getStudentSessionsBySessionId(@PathVariable String sessionId) {
        try {
            if (!isValidUUID(sessionId)) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Invalid session ID format");
            }

            UUID sessionUuid = UUID.fromString(sessionId);
            List<StudentSession> studentSession = studentSessionService.getStudentSessionsBySessionId(sessionUuid);

            if (studentSession == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Student session not found");
            }

            return ResponseEntity.ok(studentSession);
        } catch (Exception e) {
            System.out.println("Error fetching student session with ID: " + sessionId + " " + e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("An error occurred while processing the request");
        }
    }


    private boolean isValidUUID(String uuid) {
        try {
            UUID.fromString(uuid);
            return true;
        } catch (IllegalArgumentException e) {
            return false;
        }
    }
    
}
