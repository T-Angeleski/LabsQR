package mk.ukim.finki.LabsProject.service.interfaces;

import mk.ukim.finki.LabsProject.model.Grade;
import mk.ukim.finki.LabsProject.model.StudentSession;
import mk.ukim.finki.LabsProject.model.dto.GradeDTO;
import mk.ukim.finki.LabsProject.model.dto.StudentSessionDTO;

import java.util.Optional;
import java.util.UUID;

public interface GradeService {
    Grade save(GradeDTO gradeDTO);

    Optional<GradeDTO> getGradeDTOByStudentSessionId(UUID studentSessionId);

}