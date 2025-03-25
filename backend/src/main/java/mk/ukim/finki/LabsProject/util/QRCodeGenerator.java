package mk.ukim.finki.LabsProject.util;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;

import java.io.ByteArrayOutputStream;

public class QRCodeGenerator {
    static QRCodeWriter qrCodeWriter = new QRCodeWriter();
    static ByteArrayOutputStream pngOutputStream = new ByteArrayOutputStream();
    private static final int IMAGE_DIMENSION = 200;

    public static byte[] getQRCodeImage(String text) {
        try {
            BitMatrix bitMatrix = qrCodeWriter.encode(text, BarcodeFormat.QR_CODE, IMAGE_DIMENSION, IMAGE_DIMENSION);
            MatrixToImageWriter.writeToStream(bitMatrix, "PNG", pngOutputStream);
            return pngOutputStream.toByteArray();
        } catch (Exception e) {
            throw new RuntimeException("Failed to generate QR code", e);
        }
    }
}
