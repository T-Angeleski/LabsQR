package mk.ukim.finki.LabsProject.repository;

import mk.ukim.finki.LabsProject.model.StudentSession;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface StudentSessionRepository extends JpaRepository<StudentSession, UUID> {
    List<StudentSession> findBySessionId(UUID sessionUuid);

    StudentSession findStudentSessionById(UUID studentSessionUuid);

    boolean existsByStudentIdAndSessionId(UUID studentId, UUID sessionId);
    StudentSession findByStudentId(UUID studentId);
}
