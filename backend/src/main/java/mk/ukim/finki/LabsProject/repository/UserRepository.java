package mk.ukim.finki.LabsProject.repository;

import mk.ukim.finki.LabsProject.model.User;
import mk.ukim.finki.LabsProject.model.enums.Role;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface UserRepository extends JpaRepository<User, UUID> {
    List<User> findAllByRole(Role role);

    Optional<User> findByEmail(String email);

    Optional<User> findByIdAndRole(UUID id, Role role);
}
