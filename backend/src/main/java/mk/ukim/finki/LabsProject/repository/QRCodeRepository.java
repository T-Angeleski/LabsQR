package mk.ukim.finki.LabsProject.repository;

import mk.ukim.finki.LabsProject.model.QRCode;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface QRCodeRepository extends JpaRepository<QRCode, UUID> {
}
