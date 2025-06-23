package mk.ukim.finki.LabsProject.service.interfaces;


import java.util.List;
import java.util.UUID;

import mk.ukim.finki.LabsProject.model.Subject;
import mk.ukim.finki.LabsProject.model.dto.CreateSubjectDTO;
import mk.ukim.finki.LabsProject.model.dto.SubjectDTO;

public interface SubjectService {
    List<SubjectDTO> getAllSubjects();
    SubjectDTO findByName(String name);
    SubjectDTO create(CreateSubjectDTO subjectDTO);

    SubjectDTO findById(UUID id);

    SubjectDTO update(UUID id, Subject subject);

    void deleteById(UUID id);
}
