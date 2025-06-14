package mk.ukim.finki.LabsProject.service.implementations;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import lombok.AllArgsConstructor;
import mk.ukim.finki.LabsProject.model.dto.SubjectDTO;
import org.springframework.stereotype.Service;

import mk.ukim.finki.LabsProject.model.Subject;
import mk.ukim.finki.LabsProject.repository.SubjectRepository;
import mk.ukim.finki.LabsProject.service.interfaces.SubjectService;

@AllArgsConstructor
@Service
public class SubjectServiceImpl implements SubjectService {
    private final SubjectRepository subjectRepository;

    public List<SubjectDTO> getAllSubjects() {
        List<Subject> subjects = subjectRepository.findAll();
        return SubjectDTO.from(subjects);
    }

    @Override
    public Subject save(Subject subject) {
        return subjectRepository.save(subject);
    }

    @Override
    public Optional<Subject> findById(UUID id) {
        return subjectRepository.findById(id);
    }

    // todo mozebi
    @Override
    public Optional<Subject> update(UUID id, Subject subject) {
        return Optional.empty();
    }

    @Override
    public void deleteById(UUID id) {

    }


}
