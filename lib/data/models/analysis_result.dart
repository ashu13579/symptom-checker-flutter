import 'package:equatable/equatable.dart';

enum UrgencyLevel {
  low,
  medium,
  high,
  emergency,
}

extension UrgencyLevelExtension on UrgencyLevel {
  String get displayName {
    switch (this) {
      case UrgencyLevel.low:
        return 'Low Urgency';
      case UrgencyLevel.medium:
        return 'Medium Urgency';
      case UrgencyLevel.high:
        return 'High Urgency';
      case UrgencyLevel.emergency:
        return 'Emergency';
    }
  }

  String get guidance {
    switch (this) {
      case UrgencyLevel.low:
        return 'Monitor your symptoms. Consider rest and over-the-counter remedies if appropriate.';
      case UrgencyLevel.medium:
        return 'Consider scheduling an appointment with your healthcare provider within the next few days.';
      case UrgencyLevel.high:
        return 'Seek medical attention soon. Contact your doctor or visit an urgent care facility.';
      case UrgencyLevel.emergency:
        return 'Seek immediate medical attention. Call emergency services or go to the nearest emergency room.';
    }
  }
}

class PossibleCause extends Equatable {
  final String name;
  final String description;
  final double probability; // 0.0 to 1.0
  final List<String> matchingSymptoms;

  const PossibleCause({
    required this.name,
    required this.description,
    required this.probability,
    required this.matchingSymptoms,
  });

  factory PossibleCause.fromJson(Map<String, dynamic> json) {
    return PossibleCause(
      name: json['name'] as String,
      description: json['description'] as String,
      probability: (json['probability'] as num).toDouble(),
      matchingSymptoms: List<String>.from(json['matchingSymptoms'] as List),
    );
  }

  @override
  List<Object?> get props => [name, description, probability, matchingSymptoms];
}

class AnalysisResult extends Equatable {
  final UrgencyLevel urgencyLevel;
  final List<PossibleCause> possibleCauses;
  final String guidance;
  final List<String> redFlags;
  final String aiExplanation;
  final bool isEmergency;

  const AnalysisResult({
    required this.urgencyLevel,
    required this.possibleCauses,
    required this.guidance,
    required this.redFlags,
    required this.aiExplanation,
    required this.isEmergency,
  });

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      urgencyLevel: UrgencyLevel.values.firstWhere(
        (e) => e.name == json['urgencyLevel'],
      ),
      possibleCauses: (json['possibleCauses'] as List)
          .map((c) => PossibleCause.fromJson(c as Map<String, dynamic>))
          .toList(),
      guidance: json['guidance'] as String,
      redFlags: List<String>.from(json['redFlags'] as List),
      aiExplanation: json['aiExplanation'] as String,
      isEmergency: json['isEmergency'] as bool,
    );
  }

  @override
  List<Object?> get props => [
        urgencyLevel,
        possibleCauses,
        guidance,
        redFlags,
        aiExplanation,
        isEmergency,
      ];
}