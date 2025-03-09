package mk.ukim.finki.LabsProject.service.implementations;

import lombok.AllArgsConstructor;
import mk.ukim.finki.LabsProject.model.Session;
import mk.ukim.finki.LabsProject.model.Subject;
import mk.ukim.finki.LabsProject.model.User;
import mk.ukim.finki.LabsProject.repository.SessionRepository;
import mk.ukim.finki.LabsProject.repository.SubjectRepository;
import mk.ukim.finki.LabsProject.repository.UserRepository;
import mk.ukim.finki.LabsProject.service.interfaces.SessionService;
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
    public List<Session> getAllSessions() {
        // TODO: paginate
        return sessionRepository.findAll();
    }


    public Session createSession(Session session) {
        if (session.getTeacher() == null || session.getSubject() == null) {
            throw new IllegalArgumentException("Teacher and Subject are required.");
        }


        if (session.getCreatedAt() == null) {
            session.setCreatedAt(LocalDateTime.now());
        }


        User teacher = userRepository.findById(session.getTeacher().getId())
                .orElseThrow(() -> new IllegalArgumentException("Teacher not found."));


        Subject subject = subjectRepository.findById(session.getSubject().getId())
                .orElseThrow(() -> new IllegalArgumentException("Subject not found."));


        session.setTeacher(teacher);
        session.setSubject(subject);

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
