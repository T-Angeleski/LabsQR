package mk.ukim.finki.LabsProject.repository;

import mk.ukim.finki.LabsProject.model.StudentSession;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface StudentSessionRepository extends JpaRepository<StudentSession, UUID> {
}
