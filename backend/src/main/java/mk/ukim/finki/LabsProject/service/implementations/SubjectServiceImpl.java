package mk.ukim.finki.LabsProject.service.implementations;

import java.util.List;

import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import mk.ukim.finki.LabsProject.model.Subject;
import mk.ukim.finki.LabsProject.repository.SubjectRepository;
import mk.ukim.finki.LabsProject.service.interfaces.SubjectService;

@AllArgsConstructor
@Service
public class SubjectServiceImpl implements SubjectService {
    private final SubjectRepository subjectRepository;

    public List<Subject> getAllSubjects() {
        return subjectRepository.findAll();
    }
}
