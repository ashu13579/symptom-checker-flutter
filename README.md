# Symptom Checker Flutter App

A health awareness Flutter application with an interactive body map for symptom guidance. This app provides AI-assisted health insights while maintaining medical safety and ethical standards.

## ⚠️ Important Disclaimer

**This application is for informational purposes only and is NOT a medical diagnosis tool.**

- Always consult with qualified healthcare professionals for medical advice
- This app does not replace professional medical consultation
- In case of emergency, call emergency services immediately

## 🎨 UI Design

### Screen Flow

1. **Welcome/Onboarding** → 2. **Body Selection** → 3. **Symptom Details** → 4. **AI Insights**

### Screen 1: Welcome/Home Page

**Purpose:**
- Set expectations
- Reduce anxiety
- Establish non-diagnostic positioning

**Features:**
- Onboarding carousel with medical imagery
- Friendly headline: "Understand what your body is telling you"
- Clear disclaimer: "For informational purposes only — not a medical diagnosis"
- Primary CTA: **[Start symptom check]**
- Secondary links: Privacy, Terms

### Screen 2: Body Selection (Core Interaction)

**Purpose:**
- Let users indicate WHERE they feel discomfort

**Features:**
- Interactive human body illustration
- Selectable regions:
  - Head (Front, Back, Left, Right)
  - Chest
  - Abdomen (Upper Left, Upper Right, Lower Left, Lower Right)
- Toggle: **Front | Back**
- Multiple region selection with soft glow highlight (not red)
- Tooltip: "Tap one or more areas"
- CTA: **[Continue]**

**UX Notes:**
- Allow multiple regions
- Use glow or soft highlight (avoid alarming red)
- Add tooltip for guidance

### Screen 3: Pain & Sensation Details

**Purpose:**
- Convert body location into structured data

**Features:**
- **Pain intensity slider (1-10)** with color-coded indicator
- **Pain type chips:**
  - Dull
  - Sharp
  - Burning
  - Pressure
  - Stabbing
  - Throbbing
  - Cramping
- **Duration selector:**
  - Just started
  - Hours
  - Days
  - Ongoing
- **Onset:** Sudden | Gradual
- **Triggers:** Movement, Breathing, Eating, Stress, Touch, Rest, None
- Progress indicator: "Step X of 3"
- CTA: **[Next]**

**UX Notes:**
- Use icons + text
- Avoid words like "severe" or "dangerous"
- One screen = one cognitive task
- Allow "Skip" option

### Screen 4: Associated Symptoms (Adaptive)

**Purpose:**
- Gather context without overwhelming users

**Features:**
- Checkboxes/toggles for common symptoms:
  - Fever
  - Nausea
  - Fatigue
  - Shortness of breath
  - And more...
- Conditional follow-ups (e.g., chest → breathing questions)
- Progress indicator
- CTA: **[Continue]**

**UX Notes:**
- Keep questions short
- Ask fewer, smarter questions
- Allow "Skip" option

### Screen 5: AI-Assisted Health Insights (Not Diagnosis)

**Purpose:**
- Reflect user input
- Provide safe, high-value insight

**Sections:**

#### 1. Summary
"You reported discomfort in your lower abdomen with moderate intensity."

#### 2. General Insight
"Symptoms like these can sometimes be associated with digestive or muscular stress."

Possible considerations:
- **Condition Name**: Brief description
- **Another Possibility**: Brief description

#### 3. Wellness Guidance
Practical tips and when to seek care based on urgency level:
- **Low**: Monitor symptoms, rest, OTC remedies
- **Medium**: Schedule appointment within days
- **High**: Seek medical attention soon
- **Emergency**: Seek immediate medical attention

**Features:**
- Color-coded urgency indicators (calm colors, not alarming)
- Red flags section (if applicable)
- Action buttons:
  - **[Save to History]**
  - **[Export as PDF]**
  - **[Start New Check]**

### Screen 6: History/Save/Export (Optional but Powerful)

**Purpose:**
- Encourage repeat use
- Empower users with records

**Features:**
- Timeline of past entries
- Body region icons
- Export/Share with doctor (PDF)
- Privacy-first messaging

## 🎯 Overall UX Principles (Critical)

✅ **Calm, supportive tone**
- Use reassuring language
- Avoid medical jargon
- Be empathetic

✅ **No fear-based colors or language**
- Use soft blues, greens, purples
- Avoid bright reds for non-emergency situations
- Use "discomfort" instead of "pain" where appropriate

✅ **Always show "informational only" subtly**
- Persistent disclaimer banner
- Gentle reminders throughout
- Clear about limitations

## 🏗️ Architecture

### Clean Architecture Layers

```
lib/
├── core/                    # Core utilities and constants
│   ├── constants/          # Body regions, enums
│   └── theme/              # App theme configuration
├── data/                    # Data layer
│   ├── models/             # Data models
│   ├── datasources/        # API clients
│   └── repositories/       # Repository implementations
├── domain/                  # Business logic layer
│   ├── entities/           # Domain entities
│   ├── repositories/       # Repository interfaces
│   └── usecases/           # Use cases
└── presentation/            # UI layer
    ├── bloc/               # State management
    ├── pages/              # Screen widgets
    └── widgets/            # Reusable widgets
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- iOS development tools (for iOS builds)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/ashu13579/symptom-checker-flutter.git
   cd symptom-checker-flutter
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

### Backend Setup

1. **Navigate to backend directory:**
   ```bash
   cd backend
   ```

2. **Create virtual environment:**
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

4. **Run the backend:**
   ```bash
   python main.py
   ```

   The backend will run on `http://localhost:8000`

## 📱 Features

### Current Features

- ✅ Interactive body region selection
- ✅ Multi-step symptom data collection
- ✅ Pain intensity and type tracking
- ✅ Duration and onset tracking
- ✅ Associated symptoms selection
- ✅ AI-powered symptom analysis
- ✅ Urgency level calculation
- ✅ Red flag detection for emergency situations
- ✅ Health insights and guidance
- ✅ Medical safety compliance

### Planned Features

- 🔄 Symptom history tracking
- 🔄 PDF export functionality
- 🔄 Multi-language support
- 🔄 Offline mode
- 🔄 Push notifications for follow-ups
- 🔄 Integration with health APIs

## 🔒 Medical Safety Features

### Red Flag Detection

The app includes rule-based red flag detection that overrides AI analysis for medical safety:

1. **Chest pain + shortness of breath** → Emergency
2. **Severe headache + fever + neck stiffness** → Emergency (possible meningitis)
3. **Abdominal pain + blood in vomit** → Emergency (GI bleeding)
4. **Severe pain (8-10) + confusion/weakness** → Emergency
5. **Chest pain + sweating + palpitations** → Emergency (possible cardiac event)

### Urgency Levels

- **Low**: Monitor symptoms, self-care
- **Medium**: Schedule doctor appointment
- **High**: Seek medical attention soon
- **Emergency**: Immediate medical attention required

## 🛠️ Technology Stack

### Frontend
- **Flutter** - UI framework
- **Bloc** - State management
- **Equatable** - Value equality
- **Google Fonts** - Typography
- **Dio** - HTTP client

### Backend
- **FastAPI** - Python web framework
- **Pydantic** - Data validation
- **Uvicorn** - ASGI server

## 📊 API Endpoints

### POST /api/analyze

Analyzes symptoms and returns structured results.

**Request Body:**
```json
{
  "bodyRegion": "chest",
  "painType": "sharp",
  "intensity": 7,
  "duration": "hours",
  "durationValue": 2,
  "onset": "sudden",
  "triggers": ["breathing"],
  "associatedSymptoms": ["shortnessOfBreath"],
  "timestamp": "2024-01-18T10:30:00Z"
}
```

**Response:**
```json
{
  "urgencyLevel": "emergency",
  "possibleCauses": [...],
  "guidance": "...",
  "redFlags": [...],
  "aiExplanation": "...",
  "isEmergency": true
}
```

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/presentation/bloc/symptom_bloc_test.dart
```

## 🐛 Troubleshooting

See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for common issues and solutions.

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Contributing

Contributions are welcome! Please read our contributing guidelines before submitting PRs.

## 📧 Contact

For questions or support, please open an issue on GitHub.

## ⚖️ Legal & Ethical Considerations

- This app is NOT a medical device
- Does not provide medical diagnosis
- Always includes appropriate disclaimers
- Implements red flag detection for safety
- Encourages users to seek professional medical care
- Complies with health information best practices

---

**Remember:** This is a health awareness tool, not a replacement for professional medical advice. Always consult with qualified healthcare professionals for medical concerns.