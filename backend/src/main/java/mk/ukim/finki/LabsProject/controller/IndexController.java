package mk.ukim.finki.LabsProject.controller;


import mk.ukim.finki.LabsProject.model.QRCode.QRCode;
import mk.ukim.finki.LabsProject.model.StudentSession;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;

@RestController
public class IndexController {

    @GetMapping("/")
    public String getIndexPage() {
        return "Hello from the index ddd!";

    }

    @GetMapping("/qrcode")
    public ResponseEntity<byte[]> getQRCode() {
        QRCode qrCode = new QRCode();

        try {
            qrCode.generateQRCode();
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }

        HttpHeaders headers = new HttpHeaders();
        headers.set("Content-Type", "image/png");

        return new ResponseEntity<>(qrCode.getQrCode(), headers, HttpStatus.OK);


    }
}
