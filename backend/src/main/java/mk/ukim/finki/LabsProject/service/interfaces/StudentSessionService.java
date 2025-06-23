package mk.ukim.finki.LabsProject.service.interfaces;

import mk.ukim.finki.LabsProject.model.Session;
import mk.ukim.finki.LabsProject.model.StudentSession;
import mk.ukim.finki.LabsProject.model.User;
import mk.ukim.finki.LabsProject.model.dto.StudentSessionDTO;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

public interface StudentSessionService {
    StudentSessionDTO joinSession(UUID studentId, UUID sessionId);

    StudentSessionDTO getStudentSessionById(UUID studentSessionId);

    List<StudentSessionDTO> getStudentSessionsBySessionId(UUID sessionUuid);

    Optional<StudentSession> findById(UUID studentSessionId);
    StudentSessionDTO getStudentSessionByStudentId(UUID studentId);
}
