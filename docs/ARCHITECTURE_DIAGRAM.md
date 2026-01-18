# Architecture Diagram

## System Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                         USER INTERFACE                          │
│                         (Flutter App)                           │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                      PRESENTATION LAYER                         │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │  Home Page   │  │  Body Map    │  │ Symptom Input│         │
│  │              │→ │   Page       │→ │    Page      │         │
│  └──────────────┘  └──────────────┘  └──────────────┘         │
│                                              │                   │
│                                              ▼                   │
│  ┌──────────────────────────────────────────────────────┐      │
│  │              Symptom BLoC                            │      │
│  │  Events: Select, Update, Analyze, Reset              │      │
│  │  States: Initial, Collecting, Analyzing, Analyzed    │      │
│  └──────────────────────────────────────────────────────┘      │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                        DOMAIN LAYER                             │
│  ┌──────────────────────────────────────────────────────┐      │
│  │         Analyze Symptoms Use Case                    │      │
│  │                                                       │      │
│  │  1. Check Red Flags (Priority 1) ──────────┐        │      │
│  │  2. Calculate Urgency (Priority 2)         │        │      │
│  │  3. Generate Causes (Priority 3)           │        │      │
│  │  4. AI Analysis (Optional)                 │        │      │
│  └────────────────────────────────────────────┼────────┘      │
└─────────────────────────────────────────────────┼──────────────┘
                                                  │
                                                  ▼
┌─────────────────────────────────────────────────────────────────┐
│                         DATA LAYER                              │
│  ┌──────────────────────────────────────────────────────┐      │
│  │           Symptom Repository                         │      │
│  └──────────────────────────────────────────────────────┘      │
│                          │                                       │
│                          ▼                                       │
│  ┌──────────────────────────────────────────────────────┐      │
│  │         Remote Data Source (API Client)              │      │
│  └──────────────────────────────────────────────────────┘      │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                      BACKEND (FastAPI)                          │
│  ┌──────────────────────────────────────────────────────┐      │
│  │              POST /api/analyze                       │      │
│  │                                                       │      │
│  │  1. Validate Input                                   │      │
│  │  2. Check Red Flags ────────────────┐               │      │
│  │  3. Calculate Urgency               │               │      │
│  │  4. Generate Causes                 │               │      │
│  │  5. Call AI Service (Optional) ─────┼───┐           │      │
│  │  6. Return Analysis Result          │   │           │      │
│  └─────────────────────────────────────┼───┼───────────┘      │
│                                         │   │                   │
│  ┌──────────────────────────────────┐  │   │                   │
│  │     Red Flag Rules Engine        │◄─┘   │                   │
│  │  (Hard-coded safety patterns)    │      │                   │
│  └──────────────────────────────────┘      │                   │
│                                             │                   │
│  ┌──────────────────────────────────┐      │                   │
│  │        AI Service                │◄─────┘                   │
│  │  - OpenAI / Gemini Integration   │                          │
│  │  - Safety Prompt Enforcement     │                          │
│  │  - Response Validation           │                          │
│  └──────────────────────────────────┘                          │
└─────────────────────────────────────────────────────────────────┘
```

## Data Flow Diagram

```
User Input
    │
    ▼
┌─────────────────┐
│  Body Region    │
│   Selection     │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Symptom Data    │
│   Collection    │
│                 │
│ • Pain Type     │
│ • Intensity     │
│ • Duration      │
│ • Triggers      │
│ • Associated    │
└────────┬────────┘
         │
         ▼
┌─────────────────────────────────────┐
│      Analysis Pipeline              │
│                                     │
│  ┌──────────────────────────────┐  │
│  │  1. RED FLAG CHECK           │  │
│  │     (Highest Priority)       │  │
│  │                              │  │
│  │  If detected:                │  │
│  │  → Emergency urgency         │  │
│  │  → Immediate care guidance   │  │
│  │  → Skip other analysis       │  │
│  └──────────────────────────────┘  │
│              │                      │
│              ▼                      │
│  ┌──────────────────────────────┐  │
│  │  2. URGENCY CALCULATION      │  │
│  │     (Medium Priority)        │  │
│  │                              │  │
│  │  Based on:                   │  │
│  │  • Intensity (1-10)          │  │
│  │  • Associated symptoms       │  │
│  │  • Duration                  │  │
│  │                              │  │
│  │  Output: Low/Medium/High     │  │
│  └──────────────────────────────┘  │
│              │                      │
│              ▼                      │
│  ┌──────────────────────────────┐  │
│  │  3. CAUSE GENERATION         │  │
│  │     (Lower Priority)         │  │
│  │                              │  │
│  │  • Pattern matching          │  │
│  │  • Probability ranking       │  │
│  │  • Educational framing       │  │
│  └──────────────────────────────┘  │
│              │                      │
│              ▼                      │
│  ┌──────────────────────────────┐  │
│  │  4. AI EXPLANATION           │  │
│  │     (Optional, Lowest)       │  │
│  │                              │  │
│  │  • Safety constraints        │  │
│  │  • Probabilistic language    │  │
│  │  • No diagnosis              │  │
│  └──────────────────────────────┘  │
└─────────────────────────────────────┘
         │
         ▼
┌─────────────────┐
│ Analysis Result │
│                 │
│ • Urgency Level │
│ • Possible      │
│   Causes        │
│ • Guidance      │
│ • Red Flags     │
│ • AI Explain    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Results Page   │
│   Display       │
│                 │
│ • Color-coded   │
│ • Clear actions │
│ • Disclaimers   │
└─────────────────┘
```

## Safety Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    SAFETY LAYER 1                           │
│              RULE-BASED RED FLAGS                           │
│                (Highest Priority)                           │
│                                                             │
│  ┌──────────────────────────────────────────────────┐     │
│  │  Chest pain + Shortness of breath                │     │
│  │  → EMERGENCY                                      │     │
│  └──────────────────────────────────────────────────┘     │
│  ┌──────────────────────────────────────────────────┐     │
│  │  Severe headache + Fever + Neck stiffness        │     │
│  │  → EMERGENCY                                      │     │
│  └──────────────────────────────────────────────────┘     │
│  ┌──────────────────────────────────────────────────┐     │
│  │  Abdominal pain + Blood in vomit                 │     │
│  │  → EMERGENCY                                      │     │
│  └──────────────────────────────────────────────────┘     │
│                                                             │
│  If ANY red flag detected:                                 │
│  → Override all other analysis                             │
│  → Display emergency guidance                              │
│  → Skip AI analysis                                        │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    SAFETY LAYER 2                           │
│              URGENCY CALCULATION                            │
│                (Medium Priority)                            │
│                                                             │
│  Intensity >= 8  ──┐                                        │
│  Chest pain     ───┼──→  HIGH URGENCY                      │
│  Confusion      ───┘                                        │
│                                                             │
│  Intensity >= 5  ──┐                                        │
│  Fever          ───┼──→  MEDIUM URGENCY                    │
│  Vomiting       ───┘                                        │
│                                                             │
│  Intensity < 5   ──→  LOW URGENCY                          │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    SAFETY LAYER 3                           │
│                  AI ANALYSIS                                │
│              (Lowest Priority)                              │
│                                                             │
│  ┌──────────────────────────────────────────────────┐     │
│  │         SAFETY CONSTRAINTS                       │     │
│  │                                                   │     │
│  │  ✓ Probabilistic language only                   │     │
│  │  ✓ Include uncertainty                           │     │
│  │  ✓ Encourage professional care                   │     │
│  │  ✓ Educational framing                           │     │
│  │                                                   │     │
│  │  ✗ NO diagnoses                                  │     │
│  │  ✗ NO medication recommendations                 │     │
│  │  ✗ NO treatment plans                            │     │
│  │  ✗ NO certainty claims                           │     │
│  └──────────────────────────────────────────────────┘     │
│                                                             │
│  ┌──────────────────────────────────────────────────┐     │
│  │         RESPONSE VALIDATION                      │     │
│  │                                                   │     │
│  │  Check for forbidden phrases:                    │     │
│  │  • "you have"                                    │     │
│  │  • "this is definitely"                          │     │
│  │  • "take this medication"                        │     │
│  │                                                   │     │
│  │  If validation fails:                            │     │
│  │  → Use safe fallback response                    │     │
│  └──────────────────────────────────────────────────┘     │
└─────────────────────────────────────────────────────────────┘
```

## State Management Flow (BLoC)

```
┌──────────────┐
│    EVENTS    │
└──────────────┘
       │
       ├─→ SelectBodyRegion(region)
       │        │
       │        ▼
       │   BodyRegionSelected(region)
       │        │
       │        ▼
       │   SymptomDataCollecting(data)
       │
       ├─→ UpdateSymptomData(data)
       │        │
       │        ▼
       │   SymptomDataCollecting(updated_data)
       │
       ├─→ AnalyzeSymptoms()
       │        │
       │        ▼
       │   SymptomAnalyzing(data)
       │        │
       │        ▼ (async analysis)
       │   SymptomAnalyzed(data, result)
       │
       └─→ ResetSymptoms()
                │
                ▼
           SymptomInitial()
```

## Component Interaction

```
┌─────────────────────────────────────────────────────────────┐
│                      UI COMPONENTS                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  HomePage                                                   │
│    │                                                        │
│    ├─→ Disclaimer Display                                  │
│    ├─→ Feature List                                        │
│    └─→ Start Button → Navigate to BodyMapPage             │
│                                                             │
│  BodyMapPage                                                │
│    │                                                        │
│    ├─→ BodyMapWidget (Custom Painter)                      │
│    │     │                                                  │
│    │     ├─→ Tap Detection                                 │
│    │     ├─→ Hover Effects                                 │
│    │     └─→ Region Highlighting                           │
│    │                                                        │
│    └─→ Region List (Alternative Selection)                 │
│          │                                                  │
│          └─→ Dispatch: SelectBodyRegion(region)            │
│                │                                            │
│                └─→ Navigate to SymptomInputPage            │
│                                                             │
│  SymptomInputPage                                           │
│    │                                                        │
│    ├─→ Pain Type Selector                                  │
│    ├─→ Intensity Slider                                    │
│    ├─→ Duration Input                                      │
│    ├─→ Onset Selector                                      │
│    ├─→ Triggers Checklist                                  │
│    ├─→ Associated Symptoms Checklist                       │
│    └─→ Analyze Button                                      │
│          │                                                  │
│          ├─→ Dispatch: UpdateSymptomData(data)             │
│          ├─→ Dispatch: AnalyzeSymptoms()                   │
│          └─→ Navigate to ResultsPage                       │
│                                                             │
│  ResultsPage                                                │
│    │                                                        │
│    ├─→ Emergency Banner (if applicable)                    │
│    ├─→ Urgency Card (color-coded)                          │
│    ├─→ Red Flags Display                                   │
│    ├─→ Guidance Card                                       │
│    ├─→ Possible Causes List                                │
│    ├─→ AI Explanation Card                                 │
│    ├─→ Disclaimer Card                                     │
│    └─→ Action Buttons                                      │
│          │                                                  │
│          ├─→ New Check → Reset & Navigate Home             │
│          └─→ Save Results → Local Storage                  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Deployment Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    PRODUCTION SETUP                         │
└─────────────────────────────────────────────────────────────┘

┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│   Android    │     │     iOS      │     │     Web      │
│  Play Store  │     │  App Store   │     │   Hosting    │
└──────┬───────┘     └──────┬───────┘     └──────┬───────┘
       │                    │                     │
       └────────────────────┼─────────────────────┘
                            │
                            ▼
                  ┌──────────────────┐
                  │   Flutter App    │
                  │   (Client Side)  │
                  └────────┬─────────┘
                           │
                           │ HTTPS
                           │
                           ▼
                  ┌──────────────────┐
                  │   Load Balancer  │
                  └────────┬─────────┘
                           │
                ┌──────────┴──────────┐
                │                     │
                ▼                     ▼
       ┌─────────────────┐   ┌─────────────────┐
       │  FastAPI Server │   │  FastAPI Server │
       │   (Instance 1)  │   │   (Instance 2)  │
       └────────┬────────┘   └────────┬────────┘
                │                     │
                └──────────┬──────────┘
                           │
                           ▼
                  ┌──────────────────┐
                  │   AI Service     │
                  │  (OpenAI/Gemini) │
                  └──────────────────┘
```

---

**Note**: All diagrams are conceptual representations. Actual implementation may vary based on specific requirements and optimizations.