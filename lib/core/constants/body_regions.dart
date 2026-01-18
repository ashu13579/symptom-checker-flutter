enum BodyRegion {
  headFront,
  headBack,
  headLeft,
  headRight,
  chest,
  abdomenUpperLeft,
  abdomenUpperRight,
  abdomenLowerLeft,
  abdomenLowerRight,
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
      case BodyRegion.chest:
        return 'Chest';
      case BodyRegion.abdomenUpperLeft:
        return 'Upper Left Abdomen';
      case BodyRegion.abdomenUpperRight:
        return 'Upper Right Abdomen';
      case BodyRegion.abdomenLowerLeft:
        return 'Lower Left Abdomen';
      case BodyRegion.abdomenLowerRight:
        return 'Lower Right Abdomen';
    }
  }
  
  String get description {
    switch (this) {
      case BodyRegion.headFront:
        return 'Face, forehead, eyes, nose, mouth';
      case BodyRegion.headBack:
        return 'Back of head, neck';
      case BodyRegion.headLeft:
        return 'Left side of head, left ear';
      case BodyRegion.headRight:
        return 'Right side of head, right ear';
      case BodyRegion.chest:
        return 'Chest, heart area, lungs';
      case BodyRegion.abdomenUpperLeft:
        return 'Stomach, spleen area';
      case BodyRegion.abdomenUpperRight:
        return 'Liver, gallbladder area';
      case BodyRegion.abdomenLowerLeft:
        return 'Lower left abdomen, colon';
      case BodyRegion.abdomenLowerRight:
        return 'Lower right abdomen, appendix area';
    }
  }
}