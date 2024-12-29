package mk.ukim.finki.LabsProject.service.implementations;

import mk.ukim.finki.LabsProject.model.StudentSession;
import mk.ukim.finki.LabsProject.repository.QRCodeRepository;
import mk.ukim.finki.LabsProject.repository.StudentSessionRepository;
import mk.ukim.finki.LabsProject.service.interfaces.QRCodeService;
import mk.ukim.finki.LabsProject.util.QRCodeGenerator;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
public class QRCodeServiceImpl implements QRCodeService {

    private final StudentSessionRepository studentSessionRepository;
    private final QRCodeRepository qrCodeRepository;

    public QRCodeServiceImpl(StudentSessionRepository studentSessionRepository, QRCodeRepository qrCodeRepository) {
        this.studentSessionRepository = studentSessionRepository;
        this.qrCodeRepository = qrCodeRepository;
    }

    @Override
    public byte[] generateQRCode(UUID sessionId) {
        StudentSession studentSession = studentSessionRepository.findById(sessionId)
                .orElseThrow(() -> new IllegalArgumentException("Student session not found"));

        String sessionInfo = studentSession.getSession().getId().toString()
                + studentSession.getStudent().getId().toString();

        try {
            return QRCodeGenerator.getQRCodeImage(sessionInfo);
        } catch (Exception e) {
            throw new IllegalArgumentException("Error while generating QR code");
        }
    }
}
