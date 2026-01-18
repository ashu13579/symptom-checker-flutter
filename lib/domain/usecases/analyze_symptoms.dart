import 'package:symptom_checker/data/models/symptom_data.dart';
import 'package:symptom_checker/data/models/analysis_result.dart';
import 'package:symptom_checker/core/constants/body_regions.dart';

class AnalyzeSymptomsUseCase {
  /// Analyzes symptoms and returns structured result with urgency level
  /// This includes rule-based red flag detection that overrides AI
  Future<AnalysisResult> execute(SymptomData symptomData) async {
    // Step 1: Check for red flags (rule-based, highest priority)
    final redFlagResult = _checkRedFlags(symptomData);
    
    if (redFlagResult != null) {
      return redFlagResult;
    }
    
    // Step 2: Calculate urgency based on symptoms
    final urgencyLevel = _calculateUrgency(symptomData);
    
    // Step 3: Generate possible causes (would call AI service in production)
    final possibleCauses = _generatePossibleCauses(symptomData);
    
    // Step 4: Generate guidance
    final guidance = urgencyLevel.guidance;
    
    return AnalysisResult(
      urgencyLevel: urgencyLevel,
      possibleCauses: possibleCauses,
      guidance: guidance,
      redFlags: [],
      aiExplanation: _generateAIExplanation(symptomData, possibleCauses),
      isEmergency: urgencyLevel == UrgencyLevel.emergency,
    );
  }
  
  /// Rule-based red flag detection
  /// These override any AI analysis for safety
  AnalysisResult? _checkRedFlags(SymptomData data) {
    final symptoms = data.associatedSymptoms;
    final region = data.bodyRegion;
    final intensity = data.intensity ?? 0;
    
    // RED FLAG 1: Chest pain + shortness of breath
    if (region == BodyRegion.chest && 
        symptoms.contains(AssociatedSymptom.shortnessOfBreath)) {
      return AnalysisResult(
        urgencyLevel: UrgencyLevel.emergency,
        possibleCauses: const [
          PossibleCause(
            name: 'Cardiac Event',
            description: 'Chest pain with breathing difficulty may indicate a serious cardiac condition.',
            probability: 0.8,
            matchingSymptoms: ['Chest pain', 'Shortness of breath'],
          ),
        ],
        guidance: '🚨 SEEK IMMEDIATE MEDICAL ATTENTION. Call emergency services or go to the nearest emergency room immediately.',
        redFlags: ['Chest pain with shortness of breath'],
        aiExplanation: 'This combination of symptoms requires immediate medical evaluation to rule out serious cardiac conditions.',
        isEmergency: true,
      );
    }
    
    // RED FLAG 2: Severe headache + fever + neck stiffness
    if ((region == BodyRegion.headFront || 
         region == BodyRegion.headBack ||
         region == BodyRegion.headLeft ||
         region == BodyRegion.headRight) &&
        symptoms.contains(AssociatedSymptom.severeHeadache) &&
        symptoms.contains(AssociatedSymptom.fever) &&
        symptoms.contains(AssociatedSymptom.neckStiffness)) {
      return AnalysisResult(
        urgencyLevel: UrgencyLevel.emergency,
        possibleCauses: const [
          PossibleCause(
            name: 'Meningitis',
            description: 'Severe headache with fever and neck stiffness may indicate meningitis.',
            probability: 0.7,
            matchingSymptoms: ['Severe headache', 'Fever', 'Neck stiffness'],
          ),
        ],
        guidance: '🚨 SEEK IMMEDIATE MEDICAL ATTENTION. This combination requires urgent evaluation.',
        redFlags: ['Severe headache', 'Fever', 'Neck stiffness'],
        aiExplanation: 'These symptoms together may indicate a serious infection requiring immediate treatment.',
        isEmergency: true,
      );
    }
    
    // RED FLAG 3: Abdominal pain + blood in vomit
    if ((region == BodyRegion.abdomenUpperLeft ||
         region == BodyRegion.abdomenUpperRight ||
         region == BodyRegion.abdomenLowerLeft ||
         region == BodyRegion.abdomenLowerRight) &&
        symptoms.contains(AssociatedSymptom.bloodInVomit)) {
      return AnalysisResult(
        urgencyLevel: UrgencyLevel.emergency,
        possibleCauses: const [
          PossibleCause(
            name: 'Gastrointestinal Bleeding',
            description: 'Abdominal pain with blood in vomit indicates serious GI bleeding.',
            probability: 0.85,
            matchingSymptoms: ['Abdominal pain', 'Blood in vomit'],
          ),
        ],
        guidance: '🚨 SEEK IMMEDIATE MEDICAL ATTENTION. Go to the emergency room immediately.',
        redFlags: ['Abdominal pain with blood in vomit'],
        aiExplanation: 'Gastrointestinal bleeding requires immediate medical intervention.',
        isEmergency: true,
      );
    }
    
    // RED FLAG 4: Severe pain (8-10) with confusion or weakness
    if (intensity >= 8 && 
        (symptoms.contains(AssociatedSymptom.confusion) ||
         symptoms.contains(AssociatedSymptom.weakness))) {
      return AnalysisResult(
        urgencyLevel: UrgencyLevel.emergency,
        possibleCauses: const [
          PossibleCause(
            name: 'Serious Medical Condition',
            description: 'Severe pain with neurological symptoms requires immediate evaluation.',
            probability: 0.75,
            matchingSymptoms: ['Severe pain', 'Confusion or weakness'],
          ),
        ],
        guidance: '🚨 SEEK IMMEDIATE MEDICAL ATTENTION. These symptoms require urgent evaluation.',
        redFlags: ['Severe pain with neurological symptoms'],
        aiExplanation: 'The combination of severe pain and neurological symptoms needs immediate medical assessment.',
        isEmergency: true,
      );
    }
    
    // RED FLAG 5: Chest pain + sweating + palpitations
    if (region == BodyRegion.chest &&
        symptoms.contains(AssociatedSymptom.sweating) &&
        symptoms.contains(AssociatedSymptom.palpitations)) {
      return AnalysisResult(
        urgencyLevel: UrgencyLevel.emergency,
        possibleCauses: const [
          PossibleCause(
            name: 'Cardiac Event',
            description: 'Chest pain with sweating and palpitations may indicate a heart attack.',
            probability: 0.8,
            matchingSymptoms: ['Chest pain', 'Sweating', 'Palpitations'],
          ),
        ],
        guidance: '🚨 SEEK IMMEDIATE MEDICAL ATTENTION. Call emergency services immediately.',
        redFlags: ['Chest pain with sweating and palpitations'],
        aiExplanation: 'These are classic symptoms of a potential cardiac event requiring immediate care.',
        isEmergency: true,
      );
    }
    
    return null; // No red flags detected
  }
  
  /// Calculate urgency level based on symptoms
  UrgencyLevel _calculateUrgency(SymptomData data) {
    final intensity = data.intensity ?? 0;
    final symptoms = data.associatedSymptoms;
    
    // High urgency indicators
    if (intensity >= 8 ||
        symptoms.contains(AssociatedSymptom.shortnessOfBreath) ||
        symptoms.contains(AssociatedSymptom.chestPain) ||
        symptoms.contains(AssociatedSymptom.confusion) ||
        symptoms.contains(AssociatedSymptom.visionChanges)) {
      return UrgencyLevel.high;
    }
    
    // Medium urgency indicators
    if (intensity >= 5 ||
        symptoms.contains(AssociatedSymptom.fever) ||
        symptoms.contains(AssociatedSymptom.vomiting) ||
        symptoms.contains(AssociatedSymptom.dizziness) ||
        data.duration == Duration.weeks) {
      return UrgencyLevel.medium;
    }
    
    // Low urgency
    return UrgencyLevel.low;
  }
  
  /// Generate possible causes based on symptoms
  /// In production, this would call an AI service
  List<PossibleCause> _generatePossibleCauses(SymptomData data) {
    final causes = <PossibleCause>[];
    
    // Example logic - in production, this would use AI
    switch (data.bodyRegion) {
      case BodyRegion.headFront:
      case BodyRegion.headBack:
      case BodyRegion.headLeft:
      case BodyRegion.headRight:
        if (data.painType == PainType.throbbing) {
          causes.add(const PossibleCause(
            name: 'Tension Headache',
            description: 'Common type of headache often caused by stress or muscle tension.',
            probability: 0.6,
            matchingSymptoms: ['Head pain', 'Throbbing sensation'],
          ));
          causes.add(const PossibleCause(
            name: 'Migraine',
            description: 'Severe headache that may be accompanied by sensitivity to light and sound.',
            probability: 0.4,
            matchingSymptoms: ['Head pain', 'Throbbing sensation'],
          ));
        }
        break;
        
      case BodyRegion.chest:
        if (data.painType == PainType.pressure) {
          causes.add(const PossibleCause(
            name: 'Muscle Strain',
            description: 'Chest wall muscle strain from physical activity or poor posture.',
            probability: 0.5,
            matchingSymptoms: ['Chest pressure'],
          ));
          causes.add(const PossibleCause(
            name: 'Anxiety',
            description: 'Anxiety can cause chest tightness and pressure sensations.',
            probability: 0.3,
            matchingSymptoms: ['Chest pressure'],
          ));
        }
        break;
        
      case BodyRegion.abdomenUpperRight:
        if (data.associatedSymptoms.contains(AssociatedSymptom.nausea)) {
          causes.add(const PossibleCause(
            name: 'Gallbladder Issues',
            description: 'Upper right abdominal pain with nausea may indicate gallbladder problems.',
            probability: 0.5,
            matchingSymptoms: ['Upper right abdominal pain', 'Nausea'],
          ));
        }
        break;
        
      case BodyRegion.abdomenLowerRight:
        if (data.intensity != null && data.intensity! >= 6) {
          causes.add(const PossibleCause(
            name: 'Appendicitis',
            description: 'Lower right abdominal pain may indicate appendicitis, especially if severe.',
            probability: 0.4,
            matchingSymptoms: ['Lower right abdominal pain'],
          ));
        }
        break;
        
      default:
        causes.add(const PossibleCause(
          name: 'General Discomfort',
          description: 'Various benign causes may lead to discomfort in this area.',
          probability: 0.5,
          matchingSymptoms: ['Pain in selected region'],
        ));
    }
    
    // Sort by probability
    causes.sort((a, b) => b.probability.compareTo(a.probability));
    
    return causes;
  }
  
  /// Generate AI explanation
  /// In production, this would call an LLM with safety constraints
  String _generateAIExplanation(SymptomData data, List<PossibleCause> causes) {
    final region = data.bodyRegion.displayName;
    final intensity = data.intensity ?? 0;
    
    String explanation = 'Based on your reported symptoms in the $region area ';
    
    if (intensity > 0) {
      explanation += 'with an intensity of $intensity/10, ';
    }
    
    explanation += 'there are several possible explanations to consider:\n\n';
    
    for (var cause in causes) {
      final probability = (cause.probability * 100).toStringAsFixed(0);
      explanation += '• ${cause.name} (${probability}% match): ${cause.description}\n\n';
    }
    
    explanation += '\n⚠️ Important: This information is for educational purposes only. ';
    explanation += 'It is not a medical diagnosis. Please consult with a healthcare ';
    explanation += 'professional for proper evaluation and treatment.';
    
    return explanation;
  }
}