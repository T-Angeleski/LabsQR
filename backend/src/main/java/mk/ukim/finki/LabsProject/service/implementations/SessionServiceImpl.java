package mk.ukim.finki.LabsProject.service.implementations;

import jakarta.persistence.EntityNotFoundException;
import lombok.AllArgsConstructor;
import mk.ukim.finki.LabsProject.model.Session;
import mk.ukim.finki.LabsProject.model.Subject;
import mk.ukim.finki.LabsProject.model.User;
import mk.ukim.finki.LabsProject.model.dto.CreateSessionRequestDTO;
import mk.ukim.finki.LabsProject.model.dto.SessionDTO;
import mk.ukim.finki.LabsProject.model.enums.Role;
import mk.ukim.finki.LabsProject.repository.SessionRepository;
import mk.ukim.finki.LabsProject.repository.SubjectRepository;
import mk.ukim.finki.LabsProject.repository.UserRepository;
import mk.ukim.finki.LabsProject.service.interfaces.SessionService;
import mk.ukim.finki.LabsProject.util.QRCodeGenerator;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@AllArgsConstructor
@Service
public class SessionServiceImpl implements SessionService {

    private final SessionRepository sessionRepository;
    private final UserRepository userRepository;
    private final SubjectRepository subjectRepository;

    @Override
    public List<SessionDTO> getAllSessions() {
        List<Session> sessions = sessionRepository.findAll();
        return SessionDTO.from(sessions);
    }

    @Override
    public List<SessionDTO> getActiveSessions() {
        List<Session> sessions = sessionRepository.findAll().stream()
                .filter(session -> session.getCreatedAt()
                        .plusMinutes(session.getDurationInMinutes())
                        .isAfter(LocalDateTime.now()))
                .toList();
        return SessionDTO.from(sessions);
    }

    @Override
    public SessionDTO createSession(CreateSessionRequestDTO requestDTO) {
        if (requestDTO == null || requestDTO.getDurationInMinutes() == null || requestDTO.getSubjectId() == null) {
            throw new IllegalArgumentException("Duration and Subject ID are required.");
        }

        User teacher = userRepository.findByIdAndRole(requestDTO.getTeacherId(), Role.ROLE_PROFESSOR)
                .orElseThrow(() -> new EntityNotFoundException("Teacher not found with ID: " + requestDTO.getTeacherId()));
        Subject subject = subjectRepository.findById(requestDTO.getSubjectId())
                .orElseThrow(() -> new EntityNotFoundException("Subject not found with ID: " + requestDTO.getSubjectId()));

        Session session = new Session();
        session.setDurationInMinutes(requestDTO.getDurationInMinutes());
        session.setTeacher(teacher);
        session.setSubject(subject);
        session.setCreatedAt(LocalDateTime.now());

        Session savedSession = sessionRepository.save(session);

        String qrCodeText = savedSession.getId().toString();
        byte[] qrCodeImage = QRCodeGenerator.generateQrCode(qrCodeText);
        savedSession.setQrCode(qrCodeImage);

        savedSession = sessionRepository.save(session);

        return SessionDTO.from(savedSession);
    }

    @Override
    public SessionDTO getSessionById(UUID sessionId) {
        if (sessionId == null) {
            throw new IllegalArgumentException("Session ID cannot be null");
        }

        Session session = getSessionByIdOrThrow(sessionId);
        return SessionDTO.from(session);
    }

    @Override
    public SessionDTO updateSession(UUID sessionId, Integer durationInMinutes) {
        if (sessionId == null || durationInMinutes == null) {
            throw new IllegalArgumentException("Session ID and duration cannot be null");
        }

        Session session = getSessionByIdOrThrow(sessionId);
        session.setDurationInMinutes(durationInMinutes);
        sessionRepository.save(session);

        return SessionDTO.from(session);
    }

    @Override
    public SessionDTO deleteSession(UUID sessionId) {
        Session session = getSessionByIdOrThrow(sessionId);
        sessionRepository.delete(session);

        return SessionDTO.from(session);
    }

    private Session getSessionByIdOrThrow(UUID sessionId) {
        return sessionRepository.findById(sessionId)
                .orElseThrow(() -> new EntityNotFoundException("Session not found with ID: " + sessionId));
    }
}
