import 'package:equatable/equatable.dart';
import 'package:symptom_checker/core/constants/body_regions.dart';

enum PainType {
  sharp,
  dull,
  burning,
  pressure,
  stabbing,
  throbbing,
  cramping,
}

enum Duration {
  minutes,
  hours,
  days,
  weeks,
  months,
}

enum Onset {
  sudden,
  gradual,
}

enum Trigger {
  movement,
  breathing,
  eating,
  stress,
  touch,
  rest,
  none,
}

class SymptomData extends Equatable {
  final BodyRegion bodyRegion;
  final PainType? painType;
  final int? intensity; // 1-10
  final Duration? duration;
  final int? durationValue;
  final Onset? onset;
  final List<Trigger> triggers;
  final List<AssociatedSymptom> associatedSymptoms;
  final String? ageRange;
  final String? biologicalSex;
  final DateTime timestamp;

  const SymptomData({
    required this.bodyRegion,
    this.painType,
    this.intensity,
    this.duration,
    this.durationValue,
    this.onset,
    this.triggers = const [],
    this.associatedSymptoms = const [],
    this.ageRange,
    this.biologicalSex,
    required this.timestamp,
  });

  SymptomData copyWith({
    BodyRegion? bodyRegion,
    PainType? painType,
    int? intensity,
    Duration? duration,
    int? durationValue,
    Onset? onset,
    List<Trigger>? triggers,
    List<AssociatedSymptom>? associatedSymptoms,
    String? ageRange,
    String? biologicalSex,
    DateTime? timestamp,
  }) {
    return SymptomData(
      bodyRegion: bodyRegion ?? this.bodyRegion,
      painType: painType ?? this.painType,
      intensity: intensity ?? this.intensity,
      duration: duration ?? this.duration,
      durationValue: durationValue ?? this.durationValue,
      onset: onset ?? this.onset,
      triggers: triggers ?? this.triggers,
      associatedSymptoms: associatedSymptoms ?? this.associatedSymptoms,
      ageRange: ageRange ?? this.ageRange,
      biologicalSex: biologicalSex ?? this.biologicalSex,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bodyRegion': bodyRegion.name,
      'painType': painType?.name,
      'intensity': intensity,
      'duration': duration?.name,
      'durationValue': durationValue,
      'onset': onset?.name,
      'triggers': triggers.map((t) => t.name).toList(),
      'associatedSymptoms': associatedSymptoms.map((s) => s.name).toList(),
      'ageRange': ageRange,
      'biologicalSex': biologicalSex,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        bodyRegion,
        painType,
        intensity,
        duration,
        durationValue,
        onset,
        triggers,
        associatedSymptoms,
        ageRange,
        biologicalSex,
        timestamp,
      ];
}

enum AssociatedSymptom {
  fever,
  nausea,
  vomiting,
  dizziness,
  shortnessOfBreath,
  radiatingPain,
  numbness,
  weakness,
  confusion,
  visionChanges,
  hearingChanges,
  chestPain,
  palpitations,
  sweating,
  chills,
  fatigue,
  lossOfAppetite,
  bloodInStool,
  bloodInVomit,
  severeHeadache,
  neckStiffness,
}

extension AssociatedSymptomExtension on AssociatedSymptom {
  String get displayName {
    switch (this) {
      case AssociatedSymptom.fever:
        return 'Fever';
      case AssociatedSymptom.nausea:
        return 'Nausea';
      case AssociatedSymptom.vomiting:
        return 'Vomiting';
      case AssociatedSymptom.dizziness:
        return 'Dizziness';
      case AssociatedSymptom.shortnessOfBreath:
        return 'Shortness of Breath';
      case AssociatedSymptom.radiatingPain:
        return 'Radiating Pain';
      case AssociatedSymptom.numbness:
        return 'Numbness';
      case AssociatedSymptom.weakness:
        return 'Weakness';
      case AssociatedSymptom.confusion:
        return 'Confusion';
      case AssociatedSymptom.visionChanges:
        return 'Vision Changes';
      case AssociatedSymptom.hearingChanges:
        return 'Hearing Changes';
      case AssociatedSymptom.chestPain:
        return 'Chest Pain';
      case AssociatedSymptom.palpitations:
        return 'Heart Palpitations';
      case AssociatedSymptom.sweating:
        return 'Excessive Sweating';
      case AssociatedSymptom.chills:
        return 'Chills';
      case AssociatedSymptom.fatigue:
        return 'Fatigue';
      case AssociatedSymptom.lossOfAppetite:
        return 'Loss of Appetite';
      case AssociatedSymptom.bloodInStool:
        return 'Blood in Stool';
      case AssociatedSymptom.bloodInVomit:
        return 'Blood in Vomit';
      case AssociatedSymptom.severeHeadache:
        return 'Severe Headache';
      case AssociatedSymptom.neckStiffness:
        return 'Neck Stiffness';
    }
  }
}