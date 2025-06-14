package mk.ukim.finki.LabsProject.service.implementations;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import lombok.AllArgsConstructor;
import mk.ukim.finki.LabsProject.model.dto.CreateSubjectDTO;
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
    public SubjectDTO create(CreateSubjectDTO subjectDTO) {
        if (subjectDTO == null) {
            throw new IllegalArgumentException("Subject name cannot be null or empty");
        }

        Subject subject = new Subject();
        subject.setName(subjectDTO.getName());
        subject = subjectRepository.save(subject);
        return SubjectDTO.from(subject);
    }

    @Override
    public SubjectDTO findById(UUID id) {
        if (id == null) {
            throw new IllegalArgumentException("Subject ID cannot be null");
        }

        Optional<Subject> subject = subjectRepository.findById(id);
        return subject.map(SubjectDTO::from)
                .orElseThrow(() -> new IllegalArgumentException("Subject with ID " + id + " not found"));
    }

    @Override
    public SubjectDTO update(UUID id, Subject subject) {
        if (id == null || subject == null) {
            throw new IllegalArgumentException("Subject ID and subject cannot be null");
        }

        Optional<Subject> existingSubject = subjectRepository.findById(id);
        if (existingSubject.isEmpty()) {
            throw new IllegalArgumentException("Subject with ID " + id + " not found");
        }

        Subject updatedSubject = existingSubject.get();
        updatedSubject.setName(subject.getName());
        updatedSubject = subjectRepository.save(updatedSubject);
        return SubjectDTO.from(updatedSubject);
    }

    @Override
    public void deleteById(UUID id) {
        if (id == null) {
            throw new IllegalArgumentException("Subject ID cannot be null");
        }

        Optional<Subject> subject = subjectRepository.findById(id);
        if (subject.isEmpty()) {
            throw new IllegalArgumentException("Subject with ID " + id + " not found");
        }

        subjectRepository.delete(subject.get());
    }
}
