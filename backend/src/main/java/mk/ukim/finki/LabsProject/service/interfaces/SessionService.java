package mk.ukim.finki.LabsProject.service.interfaces;

import mk.ukim.finki.LabsProject.model.Session;

import java.util.List;
import java.util.UUID;

public interface SessionService {
    List<Session> getAllSessions();

    Session createSession(Session session);

    Session getSessionById(UUID sessionId);

    Session updateSession(UUID sessionId, Integer durationInMinutes);

    Session deleteSession(UUID sessionId);
}
