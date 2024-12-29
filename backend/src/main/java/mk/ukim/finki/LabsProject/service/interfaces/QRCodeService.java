package mk.ukim.finki.LabsProject.service.interfaces;

import java.util.UUID;

public interface QRCodeService {
    byte[] generateQRCode(UUID sessionId);
}
