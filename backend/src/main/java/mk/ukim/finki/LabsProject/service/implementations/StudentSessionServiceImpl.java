package mk.ukim.finki.LabsProject.service.implementations;

import jakarta.persistence.EntityNotFoundException;
import lombok.AllArgsConstructor;
import mk.ukim.finki.LabsProject.model.Session;
import mk.ukim.finki.LabsProject.model.StudentSession;
import mk.ukim.finki.LabsProject.model.User;
import mk.ukim.finki.LabsProject.model.dto.StudentSessionDTO;
import mk.ukim.finki.LabsProject.repository.SessionRepository;
import mk.ukim.finki.LabsProject.repository.StudentSessionRepository;
import mk.ukim.finki.LabsProject.repository.UserRepository;
import mk.ukim.finki.LabsProject.service.interfaces.StudentSessionService;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.*;

@AllArgsConstructor
@Service
public class StudentSessionServiceImpl implements StudentSessionService {
    private final SessionRepository sessionRepository;
    private final StudentSessionRepository studentSessionRepository;
    private final UserRepository userRepository;

    @Override
    public StudentSessionDTO joinSession(UUID studentId, UUID sessionId) {
        if (studentId == null || sessionId == null) {
            throw new IllegalArgumentException("Student ID and Session ID cannot be null");
        }

        User student = userRepository.findById(studentId)
                .orElseThrow(() -> new EntityNotFoundException("Student not found with ID: " + studentId));

        Session session = sessionRepository.findById(sessionId)
                .orElseThrow(() -> new EntityNotFoundException("Session not found with ID: " + sessionId));

        if (studentSessionRepository.existsByStudentIdAndSessionId(studentId, sessionId)) {
            throw new IllegalStateException("Student is already in this session");
        }

        StudentSession studentSession = createStudentSession(student, session);
        return StudentSessionDTO.from(studentSession);
    }

    @Override
    public StudentSessionDTO getStudentSessionById(UUID studentSessionId) {
        if (studentSessionId == null) {
            throw new IllegalArgumentException("StudentSession ID cannot be null");
        }

        StudentSession studentSession = studentSessionRepository.findById(studentSessionId)
                .orElseThrow(() -> new EntityNotFoundException("StudentSession with ID " + studentSessionId + " not found"));

        return StudentSessionDTO.from(studentSession);
    }

    @Override
    public List<StudentSessionDTO> getStudentSessionsBySessionId(UUID sessionUuid) {
        if (sessionUuid == null)
            throw new IllegalArgumentException("Session ID cannot be null");

        List<StudentSession> sessions = studentSessionRepository.findBySessionId(sessionUuid);
        return StudentSessionDTO.from(sessions);
    }

    @Override
    public Optional<StudentSession> findById(UUID studentSessionId) {
        StudentSession studentSessionById = studentSessionRepository.findStudentSessionById(studentSessionId);
        if (studentSessionById == null)
            throw new IllegalArgumentException("Session ID cannot be null");

        return Optional.of(studentSessionById);
    }

    public StudentSessionDTO getStudentSessionByStudentId(UUID studentId) {
        if (studentId == null)
            throw new IllegalArgumentException("Student ID cannot be null");

        StudentSession studentSession = studentSessionRepository.findByStudentId(studentId);
        return StudentSessionDTO.from(studentSession);
    }

    private StudentSession createStudentSession(User student, Session session) {
        // TODO: validations (already in session, is a student, etc)
        // TODO: check if the session is active

        StudentSession studentSession = new StudentSession();
        studentSession.setStudent(student);
        studentSession.setSession(session);
        studentSession.setJoinedAt(LocalDateTime.now());
        studentSessionRepository.save(studentSession);

        return studentSession;
    }
}
