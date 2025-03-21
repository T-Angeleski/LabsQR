package mk.ukim.finki.LabsProject.service.interfaces;

import java.io.ByteArrayOutputStream;
import org.springframework.stereotype.Service;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;

@Service
public interface QRCodeService {

    public byte[] generateQRCode(String text, int width, int height);
}