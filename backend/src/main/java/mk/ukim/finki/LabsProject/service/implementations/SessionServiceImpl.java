package mk.ukim.finki.LabsProject.service.implementations;

import lombok.AllArgsConstructor;
import mk.ukim.finki.LabsProject.model.Session;
import mk.ukim.finki.LabsProject.repository.SessionRepository;
import mk.ukim.finki.LabsProject.service.interfaces.SessionService;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@AllArgsConstructor
@Service
public class SessionServiceImpl implements SessionService {

    private final SessionRepository sessionRepository;

    @Override
    public List<Session> getAllSessions() {
        // TODO: paginate
        return sessionRepository.findAll();
    }

    @Override
    public Session createSession(Session session) {
        session.setCreatedAt(LocalDateTime.now());
        return sessionRepository.save(session);
    }

    @Override
    public Session getSessionById(UUID sessionId) {
        return sessionRepository.findById(sessionId).orElseThrow(() -> new IllegalArgumentException("Session not found"));
    }

    @Override
    public Session updateSession(UUID sessionId, Integer durationInMinutes) {
        // TODO: rethink what to update
        Session session = getSessionById(sessionId);
        session.setDurationInMinutes(durationInMinutes);

        return sessionRepository.save(session);
    }

    @Override
    public Session deleteSession(UUID sessionId) {
        Session session = getSessionById(sessionId);
        sessionRepository.delete(session);
        return session;
    }
}
