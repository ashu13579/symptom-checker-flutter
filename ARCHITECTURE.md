# Architecture Documentation

## System Overview

The Symptom Checker app follows a clean architecture pattern with clear separation of concerns and medical safety as the top priority.

## Architecture Layers

### 1. Presentation Layer (`lib/presentation/`)
- **Pages**: UI screens for user interaction
  - `home_page.dart`: Landing page with disclaimer
  - `body_map_page.dart`: Interactive body region selection
  - `symptom_input_page.dart`: Structured symptom data collection
  - `results_page.dart`: Analysis results with urgency display

- **Widgets**: Reusable UI components
  - `body_map_widget.dart`: Custom painted interactive body map

- **BLoC**: State management
  - `symptom_bloc.dart`: Manages symptom collection and analysis flow

### 2. Domain Layer (`lib/domain/`)
- **Use Cases**: Business logic
  - `analyze_symptoms.dart`: Core symptom analysis with red flag detection

- **Entities**: Business models (defined in data layer for simplicity)

### 3. Data Layer (`lib/data/`)
- **Models**: Data structures
  - `symptom_data.dart`: Symptom information model
  - `analysis_result.dart`: Analysis output model

- **Repositories**: Data access abstraction
  - `symptom_repository_impl.dart`: Repository implementation

- **Data Sources**: External data access
  - `remote_data_source.dart`: API communication

### 4. Core Layer (`lib/core/`)
- **Constants**: App-wide constants
  - `body_regions.dart`: Body region definitions

- **Theme**: UI styling
  - `app_theme.dart`: Material theme configuration

## Backend Architecture (`backend/`)

### FastAPI Server
- **main.py**: REST API endpoints
  - `/api/analyze`: Symptom analysis endpoint
  - `/health`: Health check endpoint

- **ai_service.py**: AI integration with safety constraints
  - OpenAI/Gemini integration
  - Safety prompt enforcement
  - Response validation

## Data Flow

```
User Input → BLoC → Repository → Use Case → Analysis Logic
                                              ↓
                                    Red Flag Check (Priority 1)
                                              ↓
                                    Urgency Calculation (Priority 2)
                                              ↓
                                    AI Analysis (Priority 3)
                                              ↓
Results ← BLoC ← Repository ← Structured Result
```

## Medical Safety Architecture

### Three-Layer Safety System

1. **Rule-Based Red Flags (Highest Priority)**
   - Hard-coded medical emergency patterns
   - Override all other analysis
   - Examples:
     - Chest pain + shortness of breath
     - Severe headache + fever + neck stiffness
     - Abdominal pain + blood in vomit

2. **Urgency Calculation (Medium Priority)**
   - Structured logic based on:
     - Pain intensity
     - Associated symptoms
     - Duration
   - Four levels: Low, Medium, High, Emergency

3. **AI Analysis (Lowest Priority)**
   - Educational explanations only
   - Probabilistic language required
   - No diagnostic claims
   - Safety constraints enforced

### Safety Constraints

#### AI Prompt Safety
```
MUST INCLUDE:
- Probabilistic language (may, might, could)
- Uncertainty acknowledgment
- Professional consultation encouragement
- Educational framing

MUST EXCLUDE:
- Diagnostic claims
- Medication recommendations
- Treatment plans
- Certainty statements
```

#### Response Validation
- Filter forbidden phrases
- Verify disclaimers present
- Check for diagnostic language
- Ensure probabilistic framing

## State Management

### BLoC Pattern
```
Events:
- SelectBodyRegion: User selects body area
- UpdateSymptomData: User provides symptom details
- AnalyzeSymptoms: Trigger analysis
- ResetSymptoms: Start new check

States:
- SymptomInitial: App start
- BodyRegionSelected: Region chosen
- SymptomDataCollecting: Gathering details
- SymptomAnalyzing: Processing
- SymptomAnalyzed: Results ready
- SymptomError: Error occurred
```

## API Design

### POST /api/analyze

**Request:**
```json
{
  "bodyRegion": "chest",
  "painType": "pressure",
  "intensity": 7,
  "duration": "hours",
  "durationValue": 2,
  "onset": "sudden",
  "triggers": ["breathing", "movement"],
  "associatedSymptoms": ["shortnessOfBreath", "sweating"],
  "ageRange": "31-50",
  "biologicalSex": "male",
  "timestamp": "2024-01-01T12:00:00Z"
}
```

**Response:**
```json
{
  "urgencyLevel": "emergency",
  "possibleCauses": [
    {
      "name": "Cardiac Event",
      "description": "...",
      "probability": 0.8,
      "matchingSymptoms": ["Chest pain", "Shortness of breath"]
    }
  ],
  "guidance": "🚨 SEEK IMMEDIATE MEDICAL ATTENTION...",
  "redFlags": ["Chest pain with shortness of breath"],
  "aiExplanation": "This combination requires...",
  "isEmergency": true
}
```

## Security & Privacy

### Data Handling
- No personal identifiers required
- No permanent storage by default
- Optional demographics anonymized
- GDPR-friendly design

### API Security
- CORS configured for Flutter app
- Input validation on all endpoints
- Error handling without data leakage
- Rate limiting (production)

## Scalability Considerations

### Current Architecture
- Monolithic Flutter app
- Single FastAPI backend
- In-memory processing

### Future Scaling
- Microservices for AI analysis
- Database for analytics (opt-in)
- CDN for static assets
- Load balancing for API
- Caching layer for common patterns

## Testing Strategy

### Unit Tests
- BLoC event/state transitions
- Use case logic
- Red flag detection
- Urgency calculation

### Integration Tests
- API endpoint responses
- Repository data flow
- End-to-end symptom analysis

### UI Tests
- Body map interaction
- Form validation
- Navigation flow
- Results display

## Deployment

### Flutter App
- Android: Google Play Store
- iOS: Apple App Store
- Web: Static hosting (optional)

### Backend
- Docker container
- Cloud hosting (AWS/GCP/Azure)
- Environment variables for API keys
- Health monitoring

## Compliance

### Medical Device Regulations
- **NOT a medical device**
- Educational tool only
- Clear disclaimers throughout
- No diagnostic claims

### App Store Guidelines
- Health & Fitness category
- Medical disclaimer prominent
- Privacy policy included
- Terms of service

## Future Enhancements

### Planned Features
1. Multi-language support
2. Symptom history tracking (opt-in)
3. Export results as PDF
4. Integration with health records (FHIR)
5. Telemedicine referral links
6. Accessibility improvements

### AI Improvements
1. Fine-tuned medical LLM
2. Multi-modal analysis (images)
3. Personalized risk assessment
4. Continuous learning from feedback

## Monitoring & Analytics

### Key Metrics
- User engagement
- Symptom patterns (anonymized)
- Red flag detection rate
- User satisfaction
- App performance

### Error Tracking
- Crash reporting
- API error rates
- User feedback
- Performance bottlenecks