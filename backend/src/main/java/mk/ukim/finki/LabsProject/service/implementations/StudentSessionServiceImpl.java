package mk.ukim.finki.LabsProject.service.implementations;

import lombok.AllArgsConstructor;
import mk.ukim.finki.LabsProject.model.QRCode;
import mk.ukim.finki.LabsProject.model.Session;
import mk.ukim.finki.LabsProject.model.StudentSession;
import mk.ukim.finki.LabsProject.model.User;
import mk.ukim.finki.LabsProject.repository.SessionRepository;
import mk.ukim.finki.LabsProject.repository.StudentSessionRepository;
import mk.ukim.finki.LabsProject.service.interfaces.StudentSessionService;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.UUID;

@AllArgsConstructor
@Service
public class StudentSessionServiceImpl implements StudentSessionService {
    private final SessionRepository sessionRepository;
    private final StudentSessionRepository studentSessionRepository;

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
                .orElseThrow(() -> new IllegalArgumentException("Session not found"));

        return session.getStudentSessions();
    }

    @Override
    public StudentSession getStudentSessionById(UUID studentSessionId) {

        StudentSession s = studentSessionRepository.findById(studentSessionId)
        .orElseThrow(() -> new IllegalArgumentException("Session not found"));

        return s;
    }



    @Override
    public void saveStudentSession(StudentSession studentSession) {
        studentSessionRepository.save(studentSession);
    }

    @Override
    public List<StudentSession> getStudentSessionsBySessionId(UUID sessionUuid) {
        return studentSessionRepository.findBySessionId(sessionUuid);
    }

}
