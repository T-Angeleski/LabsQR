package mk.ukim.finki.LabsProject.service.implementations;

import jakarta.persistence.EntityNotFoundException;
import lombok.AllArgsConstructor;
import mk.ukim.finki.LabsProject.model.QRCode;
import mk.ukim.finki.LabsProject.model.Session;
import mk.ukim.finki.LabsProject.model.StudentSession;
import mk.ukim.finki.LabsProject.model.User;
import mk.ukim.finki.LabsProject.repository.SessionRepository;
import mk.ukim.finki.LabsProject.repository.StudentSessionRepository;
import mk.ukim.finki.LabsProject.service.interfaces.SessionService;
import mk.ukim.finki.LabsProject.service.interfaces.StudentSessionService;
import mk.ukim.finki.LabsProject.service.interfaces.UserService;
import mk.ukim.finki.LabsProject.util.QRCodeGenerator;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.*;

@AllArgsConstructor
@Service
public class StudentSessionServiceImpl implements StudentSessionService {
    private final SessionRepository sessionRepository;
    private final StudentSessionRepository studentSessionRepository;
    private final UserService userService;
    private final SessionService sessionService;

    @Override
    public StudentSession createStudentSession(User student, Session session) {
        // TODO: validations (already in session, is a student, etc)
        // TODO: check if the session is active

        StudentSession studentSession = new StudentSession();
        studentSession.setStudent(student);
        studentSession.setSession(session);
        studentSession.setJoinedAt(LocalDateTime.now());
//        studentSession.setQrCode(); TODO: implement QR code generation

        return studentSessionRepository.save(studentSession);
    }

    @Override
    public List<StudentSession> getStudentsBySessionId(UUID sessionId) {
        Session session = sessionRepository.findById(sessionId)
                .orElseThrow(() -> new EntityNotFoundException("Session not found"));
        // TODO: why is this studentsessions
        return session.getStudentSessions();
    }

    @Override
    public StudentSession getStudentSessionById(UUID studentSessionId) {
        return studentSessionRepository.findById(studentSessionId)
                .orElseThrow(() -> new EntityNotFoundException("StudentSession not found"));
    }

    @Override
    public void saveStudentSession(StudentSession studentSession) {
        studentSessionRepository.save(studentSession);
    }

    @Override
    public List<StudentSession> getStudentSessionsBySessionId(UUID sessionUuid) {
        return studentSessionRepository.findBySessionId(sessionUuid);
    }

    @Override
    public Map<String, String> joinSession(UUID studentId, UUID sessionId) {
        User student = userService.getStudentById(studentId);
        Session session = sessionService.getSessionById(sessionId);
        StudentSession studentSession = createStudentSession(student, session);
        String teacherUrl = "http://localhost:8080/api/teacher-view/" + studentSession.getId();
        byte[] qrCodeImage = QRCodeGenerator.getQRCodeImage(teacherUrl);
        String qrCodeBase64 = Base64.getEncoder().encodeToString(qrCodeImage);

        QRCode qrCode = new QRCode();
        qrCode.setQrCode(qrCodeImage);
        qrCode.setStudentSession(studentSession);
        studentSession.setQrCode(qrCode);

        saveStudentSession(studentSession);

        Map<String, String> response = new HashMap<>();
        response.put("qrCode", qrCodeBase64);
        response.put("teacherUrl", teacherUrl);
        response.put("joinedAt", studentSession.getJoinedAt().toString());
        response.put("attendanceChecked", String.valueOf(studentSession.isAttendanceChecked()));
        return response;
    }

}
