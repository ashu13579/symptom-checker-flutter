# Contributing to Symptom Checker

Thank you for your interest in contributing! This document provides guidelines for contributing to the project.

## Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inclusive environment for all contributors.

### Medical Safety First

**CRITICAL**: All contributions must prioritize medical safety. Any feature that could compromise user safety will be rejected, regardless of technical merit.

## How to Contribute

### Reporting Bugs

1. **Check existing issues** to avoid duplicates
2. **Use the bug report template**
3. **Include**:
   - Flutter version
   - Platform (Android/iOS/Web)
   - Steps to reproduce
   - Expected vs actual behavior
   - Screenshots if applicable

### Suggesting Features

1. **Check existing feature requests**
2. **Use the feature request template**
3. **Consider**:
   - Medical safety implications
   - User benefit
   - Technical feasibility
   - Compliance requirements

### Pull Requests

#### Before You Start

1. **Discuss major changes** in an issue first
2. **Review medical safety guidelines** in MEDICAL_SAFETY.md
3. **Ensure you understand** the architecture (ARCHITECTURE.md)

#### Development Process

1. **Fork the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/symptom-checker-flutter.git
   ```

2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow code style guidelines
   - Add tests for new features
   - Update documentation

4. **Test thoroughly**
   ```bash
   flutter test
   flutter analyze
   flutter format .
   ```

5. **Commit with clear messages**
   ```bash
   git commit -m "feat: Add new symptom category"
   ```

6. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

7. **Create Pull Request**
   - Use the PR template
   - Link related issues
   - Describe changes clearly

## Code Style Guidelines

### Dart/Flutter

```dart
// Use meaningful variable names
final int painIntensity = 7;  // Good
final int x = 7;              // Bad

// Add comments for complex logic
/// Checks for red flag symptoms that require immediate attention
bool _checkRedFlags(SymptomData data) {
  // Implementation
}

// Use const where possible
const Text('Hello');  // Good
Text('Hello');        // Less optimal

// Follow Flutter naming conventions
class SymptomBloc {}        // PascalCase for classes
void analyzeSymptoms() {}   // camelCase for methods
final String userName = ''; // camelCase for variables
```

### Python

```python
# Follow PEP 8
def analyze_symptoms(symptom_data: dict) -> dict:
    """
    Analyze symptoms with safety constraints.
    
    Args:
        symptom_data: Structured symptom information
        
    Returns:
        Analysis result with urgency level
    """
    pass

# Use type hints
def calculate_urgency(intensity: int) -> UrgencyLevel:
    pass

# Clear variable names
pain_intensity = 7  # Good
x = 7              # Bad
```

## Testing Requirements

### Unit Tests

Required for:
- BLoC logic
- Use cases
- Data models
- Utility functions

```dart
test('should detect red flag for chest pain with shortness of breath', () {
  // Arrange
  final symptomData = SymptomData(/* ... */);
  
  // Act
  final result = analyzeSymptoms(symptomData);
  
  // Assert
  expect(result.urgencyLevel, UrgencyLevel.emergency);
});
```

### Integration Tests

Required for:
- API endpoints
- Data flow
- Critical user journeys

### Widget Tests

Required for:
- Custom widgets
- Page layouts
- User interactions

## Medical Safety Checklist

Before submitting a PR, verify:

- [ ] No diagnostic claims in code or UI
- [ ] Disclaimers present where needed
- [ ] Probabilistic language used
- [ ] Red flags not bypassed
- [ ] Emergency guidance clear
- [ ] Professional care encouraged
- [ ] No medication recommendations
- [ ] No treatment plans

## Documentation

Update documentation when:
- Adding new features
- Changing architecture
- Modifying APIs
- Updating safety rules

Required documentation:
- Code comments for complex logic
- README updates for new features
- API documentation for endpoints
- Architecture docs for structural changes

## Commit Message Format

Use conventional commits:

```
type(scope): subject

body (optional)

footer (optional)
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Code style changes
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance tasks

**Examples:**
```
feat(body-map): Add interactive SVG body map

Implemented custom painter for body region selection
with hover effects and tap detection.

Closes #123
```

```
fix(red-flags): Correct chest pain detection logic

Fixed issue where chest pain without shortness of breath
was incorrectly flagged as emergency.

Fixes #456
```

## Review Process

### What We Look For

1. **Medical Safety**
   - No diagnostic claims
   - Appropriate disclaimers
   - Safe user guidance

2. **Code Quality**
   - Clean, readable code
   - Proper error handling
   - Adequate test coverage

3. **Documentation**
   - Clear comments
   - Updated docs
   - API documentation

4. **Performance**
   - No unnecessary computations
   - Efficient algorithms
   - Proper resource management

### Review Timeline

- Initial review: Within 3 days
- Follow-up reviews: Within 2 days
- Merge decision: After all checks pass

## Getting Help

### Questions?

- Open a discussion on GitHub
- Check existing documentation
- Review similar PRs

### Stuck?

- Ask in the PR comments
- Tag maintainers
- Join community discussions

## Recognition

Contributors will be:
- Listed in CONTRIBUTORS.md
- Mentioned in release notes
- Credited in documentation

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Medical Disclaimer for Contributors

As a contributor, you acknowledge that:
1. This is an educational tool, not a medical device
2. Your contributions must not provide medical advice
3. Medical safety is the top priority
4. You are not liable for medical decisions made by users

---

Thank you for contributing to making health information more accessible while maintaining the highest safety standards!