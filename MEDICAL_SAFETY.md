# Medical Safety Guidelines

## Core Principle

**This application is for educational purposes only and does NOT provide medical diagnosis, treatment, or professional medical advice.**

## Safety Architecture

### 1. Rule-Based Red Flag System

The highest priority safety mechanism that overrides all other analysis.

#### Implemented Red Flags

1. **Cardiac Emergency**
   - Chest pain + shortness of breath
   - Chest pain + sweating + palpitations
   - **Action**: Immediate emergency care

2. **Neurological Emergency**
   - Severe headache + fever + neck stiffness (meningitis)
   - Severe pain + confusion/weakness
   - **Action**: Immediate emergency care

3. **Gastrointestinal Emergency**
   - Abdominal pain + blood in vomit
   - Abdominal pain + blood in stool
   - **Action**: Immediate emergency care

#### Adding New Red Flags

When adding red flags, follow this process:

```dart
// In analyze_symptoms.dart
AnalysisResult? _checkRedFlags(SymptomData data) {
  // Check condition
  if (condition_met) {
    return AnalysisResult(
      urgencyLevel: UrgencyLevel.emergency,
      possibleCauses: [/* specific causes */],
      guidance: "🚨 SEEK IMMEDIATE MEDICAL ATTENTION...",
      redFlags: ["Description of red flag"],
      aiExplanation: "Medical reasoning",
      isEmergency: true,
    );
  }
}
```

**Requirements for new red flags:**
- Medical literature support
- Clear emergency criteria
- Specific guidance
- No false positives acceptable

### 2. AI Safety Constraints

#### Mandatory Safety Prompt

All AI requests MUST include:

```
CRITICAL SAFETY INSTRUCTIONS:

You are an educational health information assistant. You MUST follow these rules:

1. NEVER provide a diagnosis
2. NEVER recommend specific medications
3. NEVER provide treatment plans
4. ALWAYS use probabilistic language (may, might, could, possibly)
5. ALWAYS include uncertainty in your responses
6. ALWAYS encourage consulting healthcare professionals
7. NEVER claim certainty about medical conditions
8. Focus on education and awareness, not diagnosis
```

#### Forbidden AI Outputs

The AI must NEVER:
- State "You have [condition]"
- Say "This is definitely [diagnosis]"
- Recommend "Take [medication]"
- Provide "Treatment: [specific treatment]"
- Claim certainty about any condition

#### Required AI Outputs

The AI must ALWAYS:
- Use probabilistic language
- Include uncertainty
- Encourage professional consultation
- Frame as educational information
- Include disclaimers

#### Response Validation

```python
def validate_response(response: Dict[str, Any]) -> bool:
    explanation = response.get("explanation", "").lower()
    
    # Forbidden phrases
    forbidden = [
        "you have",
        "you are diagnosed",
        "this is definitely",
        "you need to take",
        "take this medication",
        "the diagnosis is"
    ]
    
    for phrase in forbidden:
        if phrase in explanation:
            return False  # REJECT
    
    # Required elements
    if "disclaimer" not in response:
        return False  # REJECT
    
    return True
```

### 3. User Interface Safety

#### Disclaimers

**Home Page:**
- Prominent medical disclaimer
- Clear statement: "NOT a substitute for professional care"
- Emergency guidance

**Results Page:**
- Disclaimer on every results screen
- Clear urgency level display
- Specific guidance for each urgency level

#### Visual Safety Cues

- 🚨 Emergency icon for critical situations
- Color coding:
  - Red: Emergency/High urgency
  - Orange: Medium urgency
  - Green: Low urgency

### 4. Data Collection Safety

#### What We Collect
- Body region (required)
- Symptom characteristics (required)
- Age range (optional, anonymized)
- Biological sex (optional, anonymized)

#### What We DON'T Collect
- Name
- Email
- Phone number
- Address
- Medical history
- Insurance information

### 5. Positioning & Compliance

#### Correct Positioning
✅ "Health awareness tool"
✅ "Symptom guidance system"
✅ "Educational support"
✅ "When to seek care advisor"

#### Incorrect Positioning
❌ "Diagnosis tool"
❌ "Medical device"
❌ "Treatment recommender"
❌ "Doctor replacement"

### 6. Legal Compliance

#### Medical Device Regulations
- **Status**: NOT a medical device
- **Reason**: Educational only, no diagnosis
- **Compliance**: FDA guidance followed

#### App Store Requirements
- Health & Fitness category (not Medical)
- Clear disclaimers
- Privacy policy
- Terms of service
- Age restrictions (13+)

### 7. Testing Requirements

#### Safety Testing Checklist

- [ ] All red flags trigger correctly
- [ ] Emergency guidance displays properly
- [ ] Disclaimers present on all screens
- [ ] AI responses validated
- [ ] No diagnostic language in outputs
- [ ] Urgency levels calculated correctly
- [ ] Edge cases handled safely

#### Test Cases

1. **Red Flag Detection**
   ```
   Input: Chest pain + shortness of breath
   Expected: Emergency urgency, immediate care guidance
   ```

2. **AI Safety**
   ```
   Input: Any symptom combination
   Expected: No diagnostic claims, probabilistic language
   ```

3. **Disclaimer Presence**
   ```
   Check: Every results screen
   Expected: Medical disclaimer visible
   ```

### 8. Incident Response

#### If Unsafe Output Detected

1. **Immediate Actions**
   - Log the incident
   - Block the output
   - Show generic safe response
   - Alert development team

2. **Investigation**
   - Review input that caused issue
   - Check AI response
   - Identify safety constraint failure
   - Document root cause

3. **Remediation**
   - Update safety constraints
   - Add validation rules
   - Test fix thoroughly
   - Deploy update

4. **Prevention**
   - Update safety prompts
   - Add test cases
   - Review similar scenarios
   - Update documentation

### 9. Continuous Monitoring

#### Metrics to Track
- Red flag detection rate
- Emergency urgency frequency
- User feedback on accuracy
- Reported safety issues
- AI response validation failures

#### Review Schedule
- Daily: Error logs
- Weekly: User feedback
- Monthly: Safety metrics
- Quarterly: Full safety audit

### 10. Developer Guidelines

#### When Adding Features

**Ask yourself:**
1. Could this be interpreted as medical advice?
2. Does this maintain educational framing?
3. Are disclaimers still prominent?
4. Could this create false confidence?
5. Is professional care still encouraged?

**If any answer is concerning, redesign the feature.**

#### Code Review Checklist

- [ ] No diagnostic language
- [ ] Disclaimers present
- [ ] Safety constraints enforced
- [ ] Red flags not bypassed
- [ ] Probabilistic language used
- [ ] Professional care encouraged

### 11. User Education

#### In-App Guidance

**What This App Does:**
- Helps you understand your symptoms
- Provides educational information
- Guides you on when to seek care
- Offers possible explanations

**What This App Doesn't Do:**
- Diagnose medical conditions
- Replace doctor visits
- Recommend medications
- Provide treatment plans

### 12. Emergency Protocols

#### When Emergency Detected

1. **Display**: Large, clear emergency banner
2. **Message**: "🚨 SEEK IMMEDIATE MEDICAL ATTENTION"
3. **Guidance**: "Call emergency services or go to ER"
4. **No Delay**: No additional steps required
5. **Clear Action**: Specific next steps provided

#### Emergency Contact Integration

Future enhancement:
- One-tap emergency call
- Location-based ER finder
- Emergency contact notification

## Conclusion

Medical safety is not negotiable. Every feature, every line of code, every AI response must prioritize user safety over functionality. When in doubt, err on the side of caution and encourage professional medical care.

**Remember: We provide information, not diagnosis. We guide, not treat. We educate, not prescribe.**