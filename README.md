# Symptom Checker Flutter App

A cross-platform Flutter health awareness application with an interactive human body map for symptom guidance and educational support.

## ⚠️ Important Medical Disclaimer

**This application is for educational purposes only and does not provide medical diagnosis, treatment, or professional medical advice.**

- This app provides general health information and symptom awareness
- It is NOT a substitute for professional medical care
- Always consult qualified healthcare providers for medical concerns
- In case of emergency, call your local emergency services immediately

## Features

### 🎯 Core Functionality
- **Interactive Body Map**: Tap-based region selection with visual feedback
- **Structured Symptom Collection**: Comprehensive data gathering without free-text ambiguity
- **Rule-Based Red Flags**: Immediate detection of potentially serious conditions
- **AI-Assisted Insights**: Educational explanations with safety constraints
- **Urgency Classification**: Clear guidance on next steps (Monitor / Consult / Urgent)

### 🏗️ Architecture
- **Frontend**: Flutter (Android + iOS)
- **State Management**: Bloc pattern for clean architecture
- **Backend**: FastAPI REST API
- **AI Layer**: LLM integration with medical safety filters
- **Privacy-First**: No personal data storage by default

## Body Regions

The interactive body map includes:
- **Head**: Front/Back, Left/Right
- **Chest**: Central region
- **Abdomen**: Upper/Lower, Left/Right quadrants

## Symptom Data Collection

After selecting a body region, users provide:
- Pain type (sharp, dull, burning, pressure, stabbing)
- Intensity (1-10 scale)
- Duration (minutes/hours/days/weeks)
- Onset (sudden/gradual)
- Triggers (movement, breathing, eating, stress)
- Associated symptoms (fever, nausea, dizziness, etc.)

## Safety Features

### Red Flag Detection
Automatic detection of potentially serious conditions:
- Chest pain + shortness of breath → High urgency
- Severe headache + fever + neck stiffness → Urgent
- Abdominal pain + vomiting blood → Emergency

### AI Safety Constraints
- Uses probabilistic language only
- No diagnostic claims
- No medication recommendations
- Encourages professional care when appropriate

## Project Structure

```
symptom-checker-flutter/
├── lib/
│   ├── main.dart
│   ├── core/
│   │   ├── constants/
│   │   ├── theme/
│   │   └── utils/
│   ├── data/
│   │   ├── models/
│   │   ├── repositories/
│   │   └── datasources/
│   ├── domain/
│   │   ├── entities/
│   │   ├── repositories/
│   │   └── usecases/
│   ├── presentation/
│   │   ├── bloc/
│   │   ├── pages/
│   │   └── widgets/
│   └── assets/
│       └── body_map.svg
├── backend/
│   ├── main.py
│   ├── models/
│   ├── services/
│   └── api/
└── test/
```

## Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Python 3.9+ (for backend)
- Android Studio / Xcode

### Installation

1. Clone the repository:
```bash
git clone https://github.com/ashu13579/symptom-checker-flutter.git
cd symptom-checker-flutter
```

2. Install Flutter dependencies:
```bash
flutter pub get
```

3. Set up backend (optional for local development):
```bash
cd backend
pip install -r requirements.txt
python main.py
```

4. Run the app:
```bash
flutter run
```

## Compliance & Positioning

This app is positioned as:
- ✅ Health awareness tool
- ✅ Symptom guidance system
- ✅ Educational support platform

This app is NOT:
- ❌ A medical device
- ❌ A diagnostic tool
- ❌ A treatment recommendation system

## Privacy & Data

- No personal identifiers required
- No permanent storage by default
- GDPR-friendly architecture
- Clear privacy notices in-app

## Technology Stack

- **Frontend**: Flutter, Dart
- **State Management**: flutter_bloc
- **UI**: flutter_svg, custom_paint
- **Backend**: FastAPI, Python
- **AI**: OpenAI API / Gemini (with safety filters)
- **Database**: Optional (PostgreSQL for analytics only)

## Contributing

Contributions are welcome! Please ensure:
1. Medical safety is never compromised
2. No diagnostic claims are made
3. Code follows clean architecture principles
4. Tests are included for critical paths

## License

MIT License - See LICENSE file for details

## Contact

For questions or concerns about medical safety, please open an issue.

---

**Remember**: This is an educational tool. Always seek professional medical advice for health concerns.