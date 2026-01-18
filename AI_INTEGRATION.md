# AI Integration Guide

## Overview

This document provides templates and guidelines for integrating AI services (OpenAI, Gemini, etc.) with strict medical safety constraints.

## Safety-First Approach

**CRITICAL**: AI is used ONLY for educational explanations, never for diagnosis.

## AI Prompt Templates

### 1. System Prompt (Required for All Requests)

```
You are a health education assistant. Your role is to provide educational information about symptoms, NOT to diagnose.

STRICT RULES YOU MUST FOLLOW:

1. LANGUAGE CONSTRAINTS:
   - Use ONLY probabilistic language: "may", "might", "could", "possibly", "sometimes"
   - NEVER use: "you have", "this is", "definitely", "certainly"
   - Always express uncertainty

2. FORBIDDEN ACTIONS:
   - NO diagnoses
   - NO medication recommendations
   - NO treatment plans
   - NO certainty claims

3. REQUIRED ELEMENTS:
   - Encourage professional medical consultation
   - Include educational framing
   - Acknowledge limitations
   - Provide context, not conclusions

4. OUTPUT FORMAT:
   Provide possible explanations ranked by likelihood, with:
   - Educational description
   - Matching symptoms
   - Probability estimate (0.0-1.0)
   - Disclaimer

Remember: You are an educational tool, not a medical professional.
```

### 2. User Prompt Template

```
SYMPTOM INFORMATION:
Body Region: {body_region}
Pain Type: {pain_type}
Intensity: {intensity}/10
Duration: {duration_value} {duration_unit}
Onset: {onset}
Triggers: {triggers}
Associated Symptoms: {associated_symptoms}

TASK:
Provide educational information about possible causes of these symptoms.
Use probabilistic language and include appropriate uncertainty.
Rank possible causes by likelihood (0.0-1.0).
Include a disclaimer that this is not medical advice.

FORMAT YOUR RESPONSE AS JSON:
{
  "explanation": "Educational overview with probabilistic language",
  "possible_causes": [
    {
      "name": "Condition name",
      "description": "Educational description",
      "probability": 0.0-1.0,
      "matching_symptoms": ["symptom1", "symptom2"],
      "educational_note": "Additional context"
    }
  ],
  "when_to_seek_care": "Guidance on when professional care is needed",
  "disclaimer": "This is educational information only..."
}
```

### 3. Example Prompts by Scenario

#### Scenario A: Headache

```
SYMPTOM INFORMATION:
Body Region: Head (Front)
Pain Type: Throbbing
Intensity: 6/10
Duration: 4 hours
Onset: Gradual
Triggers: Stress, bright lights
Associated Symptoms: Nausea, sensitivity to light

TASK: Provide educational information about possible causes.

EXPECTED SAFE RESPONSE:
{
  "explanation": "Throbbing head pain with light sensitivity and nausea may be associated with several conditions. The most common possibilities include tension headaches and migraines, though other causes are possible.",
  "possible_causes": [
    {
      "name": "Migraine",
      "description": "Migraines are a type of headache that can cause throbbing pain, often on one side of the head. They may be accompanied by nausea and sensitivity to light or sound.",
      "probability": 0.6,
      "matching_symptoms": ["throbbing pain", "nausea", "light sensitivity"],
      "educational_note": "Migraines are common and can be triggered by stress, certain foods, or hormonal changes."
    },
    {
      "name": "Tension Headache",
      "description": "Tension headaches are the most common type of headache, often caused by stress or muscle tension in the neck and shoulders.",
      "probability": 0.3,
      "matching_symptoms": ["head pain", "stress trigger"],
      "educational_note": "These headaches typically respond well to rest and stress management."
    }
  ],
  "when_to_seek_care": "Consider seeing a healthcare provider if headaches are severe, frequent, or accompanied by fever, confusion, or vision changes.",
  "disclaimer": "This information is for educational purposes only and is not a medical diagnosis. Please consult a healthcare professional for proper evaluation."
}
```

#### Scenario B: Chest Pain (High Risk)

```
SYMPTOM INFORMATION:
Body Region: Chest
Pain Type: Pressure
Intensity: 8/10
Duration: 30 minutes
Onset: Sudden
Triggers: None identified
Associated Symptoms: Shortness of breath, sweating

TASK: Provide educational information about possible causes.

EXPECTED SAFE RESPONSE:
{
  "explanation": "Chest pressure with shortness of breath and sweating requires immediate medical evaluation. While there are various possible causes, this combination of symptoms can indicate serious conditions that need urgent assessment.",
  "possible_causes": [
    {
      "name": "Cardiac Event",
      "description": "Chest pressure with breathing difficulty and sweating may indicate a cardiac event. This is a medical emergency.",
      "probability": 0.8,
      "matching_symptoms": ["chest pressure", "shortness of breath", "sweating"],
      "educational_note": "Immediate medical attention is critical for proper diagnosis and treatment."
    }
  ],
  "when_to_seek_care": "SEEK IMMEDIATE MEDICAL ATTENTION. Call emergency services or go to the nearest emergency room.",
  "disclaimer": "This is a potentially serious situation. Do not delay seeking emergency medical care."
}
```

## Implementation Examples

### OpenAI Integration

```python
import openai
import json

def analyze_with_openai(symptom_data: dict) -> dict:
    """
    Analyze symptoms using OpenAI with safety constraints
    """
    
    system_prompt = """
    You are a health education assistant. Your role is to provide 
    educational information about symptoms, NOT to diagnose.
    
    [Include full safety prompt from above]
    """
    
    user_prompt = f"""
    SYMPTOM INFORMATION:
    Body Region: {symptom_data['bodyRegion']}
    Pain Type: {symptom_data.get('painType', 'Not specified')}
    Intensity: {symptom_data.get('intensity', 'Not specified')}/10
    Duration: {symptom_data.get('durationValue', '')} {symptom_data.get('duration', '')}
    
    [Include full user prompt template]
    """
    
    try:
        response = openai.ChatCompletion.create(
            model="gpt-4",
            messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": user_prompt}
            ],
            temperature=0.3,  # Lower for consistency
            max_tokens=800,
            response_format={"type": "json_object"}
        )
        
        result = json.loads(response.choices[0].message.content)
        
        # Validate response
        if not validate_ai_response(result):
            raise ValueError("AI response failed safety validation")
        
        return result
        
    except Exception as e:
        # Fallback to safe default
        return get_safe_fallback_response()

def validate_ai_response(response: dict) -> bool:
    """
    Validate AI response meets safety requirements
    """
    explanation = response.get("explanation", "").lower()
    
    # Check for forbidden phrases
    forbidden = [
        "you have", "you are diagnosed", "this is definitely",
        "you need to take", "take this medication", "the diagnosis is"
    ]
    
    for phrase in forbidden:
        if phrase in explanation:
            return False
    
    # Check required elements
    if "disclaimer" not in response:
        return False
    
    if "possible_causes" not in response:
        return False
    
    # Check probabilistic language
    probabilistic_words = ["may", "might", "could", "possibly", "sometimes"]
    if not any(word in explanation for word in probabilistic_words):
        return False
    
    return True

def get_safe_fallback_response() -> dict:
    """
    Safe fallback when AI fails
    """
    return {
        "explanation": "Based on your symptoms, there are several possible explanations. However, a proper evaluation by a healthcare professional is recommended for accurate assessment.",
        "possible_causes": [
            {
                "name": "Various Possible Causes",
                "description": "Your symptoms could have multiple causes that require professional evaluation.",
                "probability": 0.5,
                "matching_symptoms": [],
                "educational_note": "A healthcare provider can perform appropriate tests and examinations."
            }
        ],
        "when_to_seek_care": "Consider consulting a healthcare provider for proper evaluation of your symptoms.",
        "disclaimer": "This information is for educational purposes only. Please consult a healthcare professional."
    }
```

### Google Gemini Integration

```python
import google.generativeai as genai
import json

def analyze_with_gemini(symptom_data: dict) -> dict:
    """
    Analyze symptoms using Google Gemini with safety constraints
    """
    
    genai.configure(api_key=GEMINI_API_KEY)
    
    # Configure safety settings
    safety_settings = {
        genai.types.HarmCategory.HARM_CATEGORY_MEDICAL: genai.types.HarmBlockThreshold.BLOCK_NONE,
        # We handle medical safety ourselves with strict prompts
    }
    
    model = genai.GenerativeModel(
        'gemini-pro',
        safety_settings=safety_settings
    )
    
    prompt = f"""
    {SYSTEM_PROMPT}
    
    {format_user_prompt(symptom_data)}
    """
    
    try:
        response = model.generate_content(
            prompt,
            generation_config={
                'temperature': 0.3,
                'max_output_tokens': 800,
            }
        )
        
        result = json.loads(response.text)
        
        if not validate_ai_response(result):
            raise ValueError("AI response failed safety validation")
        
        return result
        
    except Exception as e:
        return get_safe_fallback_response()
```

## Response Filtering

### Post-Processing Pipeline

```python
def post_process_ai_response(response: dict) -> dict:
    """
    Post-process AI response to ensure safety
    """
    
    # 1. Filter explanation
    explanation = response.get("explanation", "")
    explanation = filter_diagnostic_language(explanation)
    explanation = add_uncertainty_markers(explanation)
    
    # 2. Filter possible causes
    causes = response.get("possible_causes", [])
    causes = [filter_cause(cause) for cause in causes]
    
    # 3. Ensure disclaimer
    if "disclaimer" not in response or not response["disclaimer"]:
        response["disclaimer"] = DEFAULT_DISCLAIMER
    
    # 4. Add safety notes
    response["safety_note"] = "This is educational information only, not medical advice."
    
    return response

def filter_diagnostic_language(text: str) -> str:
    """
    Remove or replace diagnostic language
    """
    replacements = {
        "you have": "this may indicate",
        "you are suffering from": "symptoms may be associated with",
        "this is": "this could be",
        "definitely": "possibly",
        "certainly": "potentially",
    }
    
    for old, new in replacements.items():
        text = text.replace(old, new)
    
    return text

def add_uncertainty_markers(text: str) -> str:
    """
    Add uncertainty markers if missing
    """
    if not any(word in text.lower() for word in ["may", "might", "could", "possibly"]):
        text = "Possibly, " + text
    
    return text
```

## Testing AI Integration

### Test Cases

```python
def test_ai_safety():
    """
    Test AI responses for safety compliance
    """
    
    test_cases = [
        {
            "name": "Headache - Should be safe",
            "input": {
                "bodyRegion": "headFront",
                "painType": "throbbing",
                "intensity": 5
            },
            "expected": {
                "has_disclaimer": True,
                "no_diagnosis": True,
                "probabilistic_language": True
            }
        },
        {
            "name": "Chest pain - Should trigger emergency",
            "input": {
                "bodyRegion": "chest",
                "painType": "pressure",
                "intensity": 8,
                "associatedSymptoms": ["shortnessOfBreath"]
            },
            "expected": {
                "urgency": "emergency",
                "immediate_care_guidance": True
            }
        }
    ]
    
    for test in test_cases:
        result = analyze_symptoms(test["input"])
        assert validate_test_expectations(result, test["expected"])
```

## Monitoring & Logging

### Log AI Interactions

```python
import logging

def log_ai_interaction(symptom_data: dict, ai_response: dict, validation_result: bool):
    """
    Log AI interactions for monitoring
    """
    
    log_entry = {
        "timestamp": datetime.now().isoformat(),
        "symptom_summary": summarize_symptoms(symptom_data),
        "ai_provider": "openai",  # or "gemini"
        "response_valid": validation_result,
        "urgency_level": ai_response.get("urgency_level"),
        "red_flags": ai_response.get("red_flags", [])
    }
    
    logging.info(f"AI Interaction: {json.dumps(log_entry)}")
    
    # Alert if validation failed
    if not validation_result:
        logging.error(f"AI Safety Validation Failed: {log_entry}")
        send_alert_to_team(log_entry)
```

## Cost Optimization

### Caching Strategy

```python
from functools import lru_cache
import hashlib

def get_cache_key(symptom_data: dict) -> str:
    """
    Generate cache key for similar symptoms
    """
    key_data = {
        "region": symptom_data["bodyRegion"],
        "pain_type": symptom_data.get("painType"),
        "intensity_range": (symptom_data.get("intensity", 0) // 2) * 2,  # Round to nearest 2
        "symptoms": sorted(symptom_data.get("associatedSymptoms", []))
    }
    return hashlib.md5(json.dumps(key_data, sort_keys=True).encode()).hexdigest()

@lru_cache(maxsize=1000)
def get_cached_analysis(cache_key: str) -> dict:
    """
    Get cached AI analysis if available
    """
    # Implementation depends on caching backend
    pass
```

## Conclusion

AI integration must prioritize safety over functionality. Every response must be validated, filtered, and monitored. When in doubt, use the safe fallback response and encourage professional medical consultation.