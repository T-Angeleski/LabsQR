package mk.ukim.finki.LabsProject.service.interfaces;


import java.util.List;
import java.util.Optional;
import java.util.UUID;

import mk.ukim.finki.LabsProject.model.Subject;

public interface SubjectService {
    List<Subject> getAllSubjects();

    Subject save(Subject subject);

    Optional<Subject> findById(UUID id);

    Optional<Subject> update(UUID id, Subject subject);

    void deleteById(UUID id);
}
