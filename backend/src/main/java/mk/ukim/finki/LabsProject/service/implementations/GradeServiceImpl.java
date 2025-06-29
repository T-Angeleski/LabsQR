package mk.ukim.finki.LabsProject.service.implementations;

import jakarta.transaction.Transactional;
import mk.ukim.finki.LabsProject.model.Grade;
import mk.ukim.finki.LabsProject.model.StudentSession;
import mk.ukim.finki.LabsProject.model.dto.GradeDTO;
import mk.ukim.finki.LabsProject.repository.GradeRepository;
import mk.ukim.finki.LabsProject.repository.StudentSessionRepository;
import mk.ukim.finki.LabsProject.service.interfaces.GradeService;
import mk.ukim.finki.LabsProject.service.interfaces.StudentSessionService;
import org.springframework.stereotype.Service;

import java.util.Optional;
import java.util.UUID;

@Service
public class GradeServiceImpl implements GradeService {

    private final GradeRepository gradeRepository;
    private final StudentSessionService studentSessionService;
    private final StudentSessionRepository studentSessionRepository;

    public GradeServiceImpl(GradeRepository gradeRepository,
                            StudentSessionService studentSessionService, StudentSessionRepository studentSessionRepository) {
        this.gradeRepository = gradeRepository;
        this.studentSessionService = studentSessionService;
        this.studentSessionRepository = studentSessionRepository;
    }

    @Override
    @Transactional
    public Grade save(GradeDTO gradeDTO) {
        StudentSession studentSession = studentSessionService.findById(gradeDTO.getStudentSessionId())
                .orElseThrow(() -> new IllegalArgumentException("Student session not found"));

        studentSession.setFinished(true);
        studentSessionRepository.save(studentSession);

        Optional<Grade> existingGrade = gradeRepository.findByStudentSession(studentSession);

        Grade grade;
        if (existingGrade.isPresent()) {
            grade = existingGrade.get();
            grade.setPoints(gradeDTO.getPoints());
            grade.setMaxPoints(gradeDTO.getMaxPoints());
            grade.setNote(gradeDTO.getNote());
        } else {
            grade = new Grade(
                    gradeDTO.getPoints(),
                    gradeDTO.getMaxPoints(),
                    gradeDTO.getNote(),
                    studentSession
            );
        }

        return gradeRepository.save(grade);
    }

    @Override
    public Optional<GradeDTO> getGradeDTOByStudentSessionId(UUID studentSessionId) {
        return gradeRepository.findByStudentSessionId(studentSessionId)
                .map(GradeDTO::from);
    }

}