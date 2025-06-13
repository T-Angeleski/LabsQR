package mk.ukim.finki.LabsProject.service.interfaces;

import mk.ukim.finki.LabsProject.model.dto.CreateSessionRequestDTO;
import mk.ukim.finki.LabsProject.model.dto.SessionDTO;

import java.util.List;
import java.util.UUID;

public interface SessionService {
    List<SessionDTO> getAllSessions();

    SessionDTO createSession(CreateSessionRequestDTO requestDTO);

    SessionDTO getSessionById(UUID sessionId);

    SessionDTO updateSession(UUID sessionId, Integer durationInMinutes);

    SessionDTO deleteSession(UUID sessionId);
}
