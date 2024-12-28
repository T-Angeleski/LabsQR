package mk.ukim.finki.LabsProject.model.QRCode;

import com.google.zxing.WriterException;
import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import mk.ukim.finki.LabsProject.model.StudentSession;

import java.io.IOException;
import java.util.UUID;

@Entity
@Data
@NoArgsConstructor
public class QRCode {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private UUID id;

    @OneToOne()
    private StudentSession studentSession;

    private byte[] qrCode;

    public void generateQRCode() throws WriterException, IOException {
        String qrContent = "Session ID: " + id;
        this.qrCode = QRCodeGenerator.getQRCodeImage(qrContent, 200, 200);
    }

}
