package mk.ukim.finki.LabsProject.service.implementations;

import mk.ukim.finki.LabsProject.model.StudentSession;
import mk.ukim.finki.LabsProject.repository.QRCodeRepository;
import mk.ukim.finki.LabsProject.repository.StudentSessionRepository;
import mk.ukim.finki.LabsProject.service.interfaces.QRCodeService;
import mk.ukim.finki.LabsProject.util.QRCodeGenerator;
import org.springframework.stereotype.Service;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;

import java.io.ByteArrayOutputStream;
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
    public byte[] generateQRCode(String text, int width, int height) {
        try {
            QRCodeWriter qrCodeWriter = new QRCodeWriter();
            BitMatrix bitMatrix = qrCodeWriter.encode(text, BarcodeFormat.QR_CODE, width, height);

            ByteArrayOutputStream pngOutputStream = new ByteArrayOutputStream();
            MatrixToImageWriter.writeToStream(bitMatrix, "PNG", pngOutputStream);
            return pngOutputStream.toByteArray();
        } catch (Exception e) {
            throw new RuntimeException("Failed to generate QR code", e);
        }
    }
}
