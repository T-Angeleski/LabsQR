package mk.ukim.finki.LabsProject.repository;

import mk.ukim.finki.LabsProject.model.Grade;
import mk.ukim.finki.LabsProject.model.StudentSession;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface GradeRepository extends JpaRepository<Grade, UUID> {
    Optional<Grade> findByStudentSession(StudentSession studentSession);
    Optional<Grade> findByStudentSessionId(UUID studentSessionId);
}
