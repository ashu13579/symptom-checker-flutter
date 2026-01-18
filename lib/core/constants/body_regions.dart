enum BodyRegion {
  // Head
  headFront,
  headBack,
  headLeft,
  headRight,
  
  // Neck
  neck,
  
  // Torso Front
  chest,
  abdomen,
  abdomenUpperLeft,
  abdomenUpperRight,
  abdomenLowerLeft,
  abdomenLowerRight,
  
  // Torso Back
  upperBack,
  lowerBack,
  
  // Shoulders
  leftShoulder,
  rightShoulder,
  
  // Arms
  leftArmUpper,
  leftArmLower,
  rightArmUpper,
  rightArmLower,
  
  // Legs
  leftLegUpper,
  leftLegLower,
  rightLegUpper,
  rightLegLower,
}

extension BodyRegionExtension on BodyRegion {
  String get displayName {
    switch (this) {
      case BodyRegion.headFront:
        return 'Head (Front)';
      case BodyRegion.headBack:
        return 'Head (Back)';
      case BodyRegion.headLeft:
        return 'Head (Left)';
      case BodyRegion.headRight:
        return 'Head (Right)';
      case BodyRegion.neck:
        return 'Neck';
      case BodyRegion.chest:
        return 'Chest';
      case BodyRegion.abdomen:
        return 'Abdomen';
      case BodyRegion.abdomenUpperLeft:
        return 'Upper Left Abdomen';
      case BodyRegion.abdomenUpperRight:
        return 'Upper Right Abdomen';
      case BodyRegion.abdomenLowerLeft:
        return 'Lower Left Abdomen';
      case BodyRegion.abdomenLowerRight:
        return 'Lower Right Abdomen';
      case BodyRegion.upperBack:
        return 'Upper Back';
      case BodyRegion.lowerBack:
        return 'Lower Back';
      case BodyRegion.leftShoulder:
        return 'Left Shoulder';
      case BodyRegion.rightShoulder:
        return 'Right Shoulder';
      case BodyRegion.leftArmUpper:
        return 'Left Upper Arm';
      case BodyRegion.leftArmLower:
        return 'Left Forearm';
      case BodyRegion.rightArmUpper:
        return 'Right Upper Arm';
      case BodyRegion.rightArmLower:
        return 'Right Forearm';
      case BodyRegion.leftLegUpper:
        return 'Left Thigh';
      case BodyRegion.leftLegLower:
        return 'Left Lower Leg';
      case BodyRegion.rightLegUpper:
        return 'Right Thigh';
      case BodyRegion.rightLegLower:
        return 'Right Lower Leg';
    }
  }
  
  String get description {
    switch (this) {
      case BodyRegion.headFront:
        return 'Face, forehead, eyes, nose, mouth';
      case BodyRegion.headBack:
        return 'Back of head';
      case BodyRegion.headLeft:
        return 'Left side of head, left ear';
      case BodyRegion.headRight:
        return 'Right side of head, right ear';
      case BodyRegion.neck:
        return 'Neck area, throat';
      case BodyRegion.chest:
        return 'Chest, heart area, lungs';
      case BodyRegion.abdomen:
        return 'Stomach area, belly';
      case BodyRegion.abdomenUpperLeft:
        return 'Stomach, spleen area';
      case BodyRegion.abdomenUpperRight:
        return 'Liver, gallbladder area';
      case BodyRegion.abdomenLowerLeft:
        return 'Lower left abdomen, colon';
      case BodyRegion.abdomenLowerRight:
        return 'Lower right abdomen, appendix area';
      case BodyRegion.upperBack:
        return 'Upper back, shoulder blades';
      case BodyRegion.lowerBack:
        return 'Lower back, lumbar area';
      case BodyRegion.leftShoulder:
        return 'Left shoulder joint';
      case BodyRegion.rightShoulder:
        return 'Right shoulder joint';
      case BodyRegion.leftArmUpper:
        return 'Left upper arm, bicep area';
      case BodyRegion.leftArmLower:
        return 'Left forearm, wrist';
      case BodyRegion.rightArmUpper:
        return 'Right upper arm, bicep area';
      case BodyRegion.rightArmLower:
        return 'Right forearm, wrist';
      case BodyRegion.leftLegUpper:
        return 'Left thigh, hip area';
      case BodyRegion.leftLegLower:
        return 'Left shin, calf, ankle';
      case BodyRegion.rightLegUpper:
        return 'Right thigh, hip area';
      case BodyRegion.rightLegLower:
        return 'Right shin, calf, ankle';
    }
  }
}