package mk.ukim.finki.LabsProject.model;

import com.google.zxing.WriterException;
import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import mk.ukim.finki.LabsProject.util.QRCodeGenerator;

import java.io.IOException;
import java.util.UUID;

@Entity
@Data
@NoArgsConstructor
public class QRCode {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @OneToOne()
    private StudentSession studentSession;

    private byte[] qrCode;

}
