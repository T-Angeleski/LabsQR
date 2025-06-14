package mk.ukim.finki.LabsProject.config;

import lombok.AllArgsConstructor;
import mk.ukim.finki.LabsProject.model.*;
import mk.ukim.finki.LabsProject.model.enums.Role;
import mk.ukim.finki.LabsProject.repository.*;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

import java.time.LocalDateTime;
import java.util.List;

@Configuration
@AllArgsConstructor
public class DataSeederConfig {

    private final UserRepository userRepository;
    private final SubjectRepository subjectRepository;
    private final SessionRepository sessionRepository;
    private final StudentSessionRepository studentSessionRepository;
    private final GradeRepository gradeRepository;

    @Bean
    @Profile("h2")
    public CommandLineRunner seedData() {
        return args -> {
            System.out.println("Seeding data...");

            User teacher = new User("Professor Smith", "smith@example.com", "password", Role.ROLE_PROFESSOR, null);
            User student1 = new User("John Doe", "john@example.com", "password", Role.ROLE_STUDENT, "111111");
            User student2 = new User("Jane Smith", "jane@example.com", "password", Role.ROLE_STUDENT, "222222");
            userRepository.saveAll(List.of(teacher, student1, student2));

            Subject webProgramming = new Subject();
            webProgramming.setName("Web Programming");
            Subject softwareEngineering = new Subject();
            softwareEngineering.setName("Software Engineering");
            subjectRepository.saveAll(List.of(webProgramming, softwareEngineering));

            Session webSession = new Session();
            webSession.setCreatedAt(LocalDateTime.now().minusHours(1));
            webSession.setDurationInMinutes(120);
            webSession.setTeacher(teacher);
            webSession.setSubject(webProgramming);

            Session seSession = new Session();
            seSession.setCreatedAt(LocalDateTime.now());
            seSession.setDurationInMinutes(90);
            seSession.setTeacher(teacher);
            seSession.setSubject(softwareEngineering);
            sessionRepository.saveAll(List.of(webSession, seSession));

            StudentSession johnWebSession = new StudentSession();
            johnWebSession.setStudent(student1);
            johnWebSession.setSession(webSession);
            johnWebSession.setJoinedAt(LocalDateTime.now().minusMinutes(45));
            johnWebSession.setAttendanceChecked(true);

            StudentSession janeWebSession = new StudentSession();
            janeWebSession.setStudent(student2);
            janeWebSession.setSession(webSession);
            janeWebSession.setJoinedAt(LocalDateTime.now().minusMinutes(30));
            janeWebSession.setAttendanceChecked(true);

            StudentSession johnSeSession = new StudentSession();
            johnSeSession.setStudent(student1);
            johnSeSession.setSession(seSession);
            johnSeSession.setJoinedAt(LocalDateTime.now().minusMinutes(10));
            johnSeSession.setAttendanceChecked(false);

            studentSessionRepository.saveAll(
                    List.of(johnWebSession, janeWebSession, johnSeSession));

            Grade johnWebGrade = new Grade();
            johnWebGrade.setPoints(85);
            johnWebGrade.setMaxPoints(100);
            johnWebGrade.setNote("Good work");
            johnWebGrade.setStudentSession(johnWebSession);

            Grade janeWebGrade = new Grade();
            janeWebGrade.setPoints(92);
            janeWebGrade.setMaxPoints(100);
            janeWebGrade.setNote("Excellent");
            janeWebGrade.setStudentSession(janeWebSession);

            gradeRepository.saveAll(List.of(johnWebGrade, janeWebGrade));

//            QRCode johnQrCode = new QRCode();
//            johnQrCode.setStudentSession(johnWebSession);
//            johnQrCode.setQrCode("sample-qr-data-1".getBytes());
//
//            QRCode janeQrCode = new QRCode();
//            janeQrCode.setStudentSession(janeWebSession);
//            janeQrCode.setQrCode("sample-qr-data-2".getBytes());

//            qrCodeRepository.saveAll(List.of(johnQrCode, janeQrCode));

            System.out.println("Data seeding completed!");
        };
    }
}