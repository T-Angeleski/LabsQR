package mk.ukim.finki.LabsProject.service.implementations;

import mk.ukim.finki.LabsProject.model.Grade;
import mk.ukim.finki.LabsProject.model.StudentSession;
import mk.ukim.finki.LabsProject.model.dto.GradeDTO;
import mk.ukim.finki.LabsProject.repository.GradeRepository;
import mk.ukim.finki.LabsProject.service.interfaces.GradeService;
import mk.ukim.finki.LabsProject.service.interfaces.StudentSessionService;
import org.springframework.stereotype.Service;

import java.util.Optional;
import java.util.UUID;

@Service
public class GradeServiceImpl implements GradeService {

    private final GradeRepository gradeRepository;
    private final StudentSessionService studentSessionService;

    public GradeServiceImpl(GradeRepository gradeRepository,
                            StudentSessionService studentSessionService) {
        this.gradeRepository = gradeRepository;
        this.studentSessionService = studentSessionService;
    }

    @Override
    public Grade save(GradeDTO gradeDTO) {
        StudentSession studentSession = studentSessionService.findById(gradeDTO.getStudentSessionId())
                .orElseThrow(() -> new IllegalArgumentException("Student session not found"));

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