package mk.ukim.finki.LabsProject.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.UUID;

@Entity
@Data
@NoArgsConstructor
public class QRCode {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @JsonBackReference // References back to StudentSession
    @OneToOne
    private StudentSession studentSession;

    @Lob
    private byte[] qrCode;

}
