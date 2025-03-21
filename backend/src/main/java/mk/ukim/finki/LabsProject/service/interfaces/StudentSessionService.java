package mk.ukim.finki.LabsProject.service.interfaces;

import mk.ukim.finki.LabsProject.model.QRCode;
import mk.ukim.finki.LabsProject.model.Session;
import mk.ukim.finki.LabsProject.model.StudentSession;
import mk.ukim.finki.LabsProject.model.User;

import java.util.List;
import java.util.UUID;

public interface StudentSessionService {
    StudentSession createStudentSession(User student, Session session);

    List<StudentSession> getStudentsBySessionId(UUID sessionId);

    StudentSession getStudentSessionById(UUID studentSessionId);

    void saveStudentSession(StudentSession studentSession);


    List<StudentSession> getStudentSessionsBySessionId(UUID sessionUuid);
}
