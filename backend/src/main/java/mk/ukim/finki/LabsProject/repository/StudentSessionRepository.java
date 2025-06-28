package mk.ukim.finki.LabsProject.repository;

import mk.ukim.finki.LabsProject.model.StudentSession;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface StudentSessionRepository extends JpaRepository<StudentSession, UUID> {
    List<StudentSession> findBySessionId(UUID sessionUuid);
    boolean existsByStudentIdAndSessionId(UUID studentId, UUID sessionId);
    Optional<StudentSession> findByStudentIdAndSessionId(UUID studentId, UUID sessionId);
    StudentSession findByStudentId(UUID studentId);
    Optional<StudentSession> findByStudentIdAndId(UUID studentId, UUID studentSessionid);
}
