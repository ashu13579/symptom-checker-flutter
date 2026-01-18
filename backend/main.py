from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional
from enum import Enum
import uvicorn

app = FastAPI(
    title="Symptom Checker API",
    description="Backend API for symptom analysis with medical safety constraints",
    version="1.0.0"
)

# CORS middleware for Flutter app
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, specify your Flutter app's origin
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Enums
class BodyRegion(str, Enum):
    headFront = "headFront"
    headBack = "headBack"
    headLeft = "headLeft"
    headRight = "headRight"
    chest = "chest"
    abdomenUpperLeft = "abdomenUpperLeft"
    abdomenUpperRight = "abdomenUpperRight"
    abdomenLowerLeft = "abdomenLowerLeft"
    abdomenLowerRight = "abdomenLowerRight"

class PainType(str, Enum):
    sharp = "sharp"
    dull = "dull"
    burning = "burning"
    pressure = "pressure"
    stabbing = "stabbing"
    throbbing = "throbbing"
    cramping = "cramping"

class SymptomDuration(str, Enum):
    minutes = "minutes"
    hours = "hours"
    days = "days"
    weeks = "weeks"
    months = "months"

class Onset(str, Enum):
    sudden = "sudden"
    gradual = "gradual"

class Trigger(str, Enum):
    movement = "movement"
    breathing = "breathing"
    eating = "eating"
    stress = "stress"
    touch = "touch"
    rest = "rest"
    none = "none"

class AssociatedSymptom(str, Enum):
    fever = "fever"
    nausea = "nausea"
    vomiting = "vomiting"
    dizziness = "dizziness"
    shortnessOfBreath = "shortnessOfBreath"
    radiatingPain = "radiatingPain"
    numbness = "numbness"
    weakness = "weakness"
    confusion = "confusion"
    visionChanges = "visionChanges"
    hearingChanges = "hearingChanges"
    chestPain = "chestPain"
    palpitations = "palpitations"
    sweating = "sweating"
    chills = "chills"
    fatigue = "fatigue"
    lossOfAppetite = "lossOfAppetite"
    bloodInStool = "bloodInStool"
    bloodInVomit = "bloodInVomit"
    severeHeadache = "severeHeadache"
    neckStiffness = "neckStiffness"

class UrgencyLevel(str, Enum):
    low = "low"
    medium = "medium"
    high = "high"
    emergency = "emergency"

# Request Models
class SymptomDataRequest(BaseModel):
    bodyRegion: BodyRegion
    painType: Optional[PainType] = None
    intensity: Optional[int] = None
    duration: Optional[SymptomDuration] = None
    durationValue: Optional[int] = None
    onset: Optional[Onset] = None
    triggers: List[Trigger] = []
    associatedSymptoms: List[AssociatedSymptom] = []
    ageRange: Optional[str] = None
    biologicalSex: Optional[str] = None
    timestamp: str

# Response Models
class PossibleCause(BaseModel):
    name: str
    description: str
    probability: float
    matchingSymptoms: List[str]

class AnalysisResult(BaseModel):
    urgencyLevel: UrgencyLevel
    possibleCauses: List[PossibleCause]
    guidance: str
    redFlags: List[str]
    aiExplanation: str
    isEmergency: bool

# Red Flag Detection (Rule-based, highest priority)
def check_red_flags(data: SymptomDataRequest) -> Optional[AnalysisResult]:
    """
    Rule-based red flag detection
    These override any AI analysis for medical safety
    """
    symptoms = data.associatedSymptoms
    region = data.bodyRegion
    intensity = data.intensity or 0
    
    # RED FLAG 1: Chest pain + shortness of breath
    if region == BodyRegion.chest and AssociatedSymptom.shortnessOfBreath in symptoms:
        return AnalysisResult(
            urgencyLevel=UrgencyLevel.emergency,
            possibleCauses=[
                PossibleCause(
                    name="Cardiac Event",
                    description="Chest pain with breathing difficulty may indicate a serious cardiac condition.",
                    probability=0.8,
                    matchingSymptoms=["Chest pain", "Shortness of breath"]
                )
            ],
            guidance="🚨 SEEK IMMEDIATE MEDICAL ATTENTION. Call emergency services or go to the nearest emergency room immediately.",
            redFlags=["Chest pain with shortness of breath"],
            aiExplanation="This combination of symptoms requires immediate medical evaluation to rule out serious cardiac conditions.",
            isEmergency=True
        )
    
    # RED FLAG 2: Severe headache + fever + neck stiffness
    if (region in [BodyRegion.headFront, BodyRegion.headBack, BodyRegion.headLeft, BodyRegion.headRight] and
        AssociatedSymptom.severeHeadache in symptoms and
        AssociatedSymptom.fever in symptoms and
        AssociatedSymptom.neckStiffness in symptoms):
        return AnalysisResult(
            urgencyLevel=UrgencyLevel.emergency,
            possibleCauses=[
                PossibleCause(
                    name="Meningitis",
                    description="Severe headache with fever and neck stiffness may indicate meningitis.",
                    probability=0.7,
                    matchingSymptoms=["Severe headache", "Fever", "Neck stiffness"]
                )
            ],
            guidance="🚨 SEEK IMMEDIATE MEDICAL ATTENTION. This combination requires urgent evaluation.",
            redFlags=["Severe headache", "Fever", "Neck stiffness"],
            aiExplanation="These symptoms together may indicate a serious infection requiring immediate treatment.",
            isEmergency=True
        )
    
    # RED FLAG 3: Abdominal pain + blood in vomit
    if (region in [BodyRegion.abdomenUpperLeft, BodyRegion.abdomenUpperRight, 
                   BodyRegion.abdomenLowerLeft, BodyRegion.abdomenLowerRight] and
        AssociatedSymptom.bloodInVomit in symptoms):
        return AnalysisResult(
            urgencyLevel=UrgencyLevel.emergency,
            possibleCauses=[
                PossibleCause(
                    name="Gastrointestinal Bleeding",
                    description="Abdominal pain with blood in vomit indicates serious GI bleeding.",
                    probability=0.85,
                    matchingSymptoms=["Abdominal pain", "Blood in vomit"]
                )
            ],
            guidance="🚨 SEEK IMMEDIATE MEDICAL ATTENTION. Go to the emergency room immediately.",
            redFlags=["Abdominal pain with blood in vomit"],
            aiExplanation="Gastrointestinal bleeding requires immediate medical intervention.",
            isEmergency=True
        )
    
    # RED FLAG 4: Severe pain (8-10) with confusion or weakness
    if intensity >= 8 and (AssociatedSymptom.confusion in symptoms or AssociatedSymptom.weakness in symptoms):
        return AnalysisResult(
            urgencyLevel=UrgencyLevel.emergency,
            possibleCauses=[
                PossibleCause(
                    name="Serious Medical Condition",
                    description="Severe pain with neurological symptoms requires immediate evaluation.",
                    probability=0.75,
                    matchingSymptoms=["Severe pain", "Confusion or weakness"]
                )
            ],
            guidance="🚨 SEEK IMMEDIATE MEDICAL ATTENTION. These symptoms require urgent evaluation.",
            redFlags=["Severe pain with neurological symptoms"],
            aiExplanation="The combination of severe pain and neurological symptoms needs immediate medical assessment.",
            isEmergency=True
        )
    
    # RED FLAG 5: Chest pain + sweating + palpitations
    if (region == BodyRegion.chest and
        AssociatedSymptom.sweating in symptoms and
        AssociatedSymptom.palpitations in symptoms):
        return AnalysisResult(
            urgencyLevel=UrgencyLevel.emergency,
            possibleCauses=[
                PossibleCause(
                    name="Cardiac Event",
                    description="Chest pain with sweating and palpitations may indicate a heart attack.",
                    probability=0.8,
                    matchingSymptoms=["Chest pain", "Sweating", "Palpitations"]
                )
            ],
            guidance="🚨 SEEK IMMEDIATE MEDICAL ATTENTION. Call emergency services immediately.",
            redFlags=["Chest pain with sweating and palpitations"],
            aiExplanation="These are classic symptoms of a potential cardiac event requiring immediate care.",
            isEmergency=True
        )
    
    return None

def calculate_urgency(data: SymptomDataRequest) -> UrgencyLevel:
    """Calculate urgency level based on symptoms"""
    intensity = data.intensity or 0
    symptoms = data.associatedSymptoms
    
    # High urgency indicators
    if (intensity >= 8 or
        AssociatedSymptom.shortnessOfBreath in symptoms or
        AssociatedSymptom.chestPain in symptoms or
        AssociatedSymptom.confusion in symptoms or
        AssociatedSymptom.visionChanges in symptoms):
        return UrgencyLevel.high
    
    # Medium urgency indicators
    if (intensity >= 5 or
        AssociatedSymptom.fever in symptoms or
        AssociatedSymptom.vomiting in symptoms or
        AssociatedSymptom.dizziness in symptoms or
        data.duration == SymptomDuration.weeks):
        return UrgencyLevel.medium
    
    return UrgencyLevel.low

def generate_possible_causes(data: SymptomDataRequest) -> List[PossibleCause]:
    """
    Generate possible causes based on symptoms
    In production, this would integrate with an AI service
    """
    causes = []
    
    # Example logic - in production, use AI with safety constraints
    if data.bodyRegion in [BodyRegion.headFront, BodyRegion.headBack, 
                           BodyRegion.headLeft, BodyRegion.headRight]:
        if data.painType == PainType.throbbing:
            causes.append(PossibleCause(
                name="Tension Headache",
                description="Common type of headache often caused by stress or muscle tension.",
                probability=0.6,
                matchingSymptoms=["Head pain", "Throbbing sensation"]
            ))
            causes.append(PossibleCause(
                name="Migraine",
                description="Severe headache that may be accompanied by sensitivity to light and sound.",
                probability=0.4,
                matchingSymptoms=["Head pain", "Throbbing sensation"]
            ))
    
    elif data.bodyRegion == BodyRegion.chest:
        if data.painType == PainType.pressure:
            causes.append(PossibleCause(
                name="Muscle Strain",
                description="Chest wall muscle strain from physical activity or poor posture.",
                probability=0.5,
                matchingSymptoms=["Chest pressure"]
            ))
            causes.append(PossibleCause(
                name="Anxiety",
                description="Anxiety can cause chest tightness and pressure sensations.",
                probability=0.3,
                matchingSymptoms=["Chest pressure"]
            ))
    
    elif data.bodyRegion == BodyRegion.abdomenUpperRight:
        if AssociatedSymptom.nausea in data.associatedSymptoms:
            causes.append(PossibleCause(
                name="Gallbladder Issues",
                description="Upper right abdominal pain with nausea may indicate gallbladder problems.",
                probability=0.5,
                matchingSymptoms=["Upper right abdominal pain", "Nausea"]
            ))
    
    elif data.bodyRegion == BodyRegion.abdomenLowerRight:
        if data.intensity and data.intensity >= 6:
            causes.append(PossibleCause(
                name="Appendicitis",
                description="Lower right abdominal pain may indicate appendicitis, especially if severe.",
                probability=0.4,
                matchingSymptoms=["Lower right abdominal pain"]
            ))
    
    if not causes:
        causes.append(PossibleCause(
            name="General Discomfort",
            description="Various benign causes may lead to discomfort in this area.",
            probability=0.5,
            matchingSymptoms=["Pain in selected region"]
        ))
    
    # Sort by probability
    causes.sort(key=lambda x: x.probability, reverse=True)
    return causes

def generate_ai_explanation(data: SymptomDataRequest, causes: List[PossibleCause]) -> str:
    """
    Generate AI explanation with safety constraints
    In production, this would call an LLM with strict prompts
    """
    region_name = data.bodyRegion.value
    intensity = data.intensity or 0
    
    explanation = f"Based on your reported symptoms in the {region_name} area "
    
    if intensity > 0:
        explanation += f"with an intensity of {intensity}/10, "
    
    explanation += "there are several possible explanations to consider:\n\n"
    
    for cause in causes:
        probability = int(cause.probability * 100)
        explanation += f"• {cause.name} ({probability}% match): {cause.description}\n\n"
    
    explanation += "\n⚠️ Important: This information is for educational purposes only. "
    explanation += "It is not a medical diagnosis. Please consult with a healthcare "
    explanation += "professional for proper evaluation and treatment."
    
    return explanation

@app.get("/")
async def root():
    return {
        "message": "Symptom Checker API",
        "version": "1.0.0",
        "status": "operational"
    }

@app.get("/health")
async def health_check():
    return {"status": "healthy"}

@app.post("/api/analyze", response_model=AnalysisResult)
async def analyze_symptoms(data: SymptomDataRequest):
    """
    Analyze symptoms and return structured result
    Priority: Red flags > Urgency calculation > AI analysis
    """
    try:
        # Step 1: Check for red flags (highest priority)
        red_flag_result = check_red_flags(data)
        if red_flag_result:
            return red_flag_result
        
        # Step 2: Calculate urgency
        urgency_level = calculate_urgency(data)
        
        # Step 3: Generate possible causes
        possible_causes = generate_possible_causes(data)
        
        # Step 4: Generate guidance
        guidance_map = {
            UrgencyLevel.low: "Monitor your symptoms. Consider rest and over-the-counter remedies if appropriate.",
            UrgencyLevel.medium: "Consider scheduling an appointment with your healthcare provider within the next few days.",
            UrgencyLevel.high: "Seek medical attention soon. Contact your doctor or visit an urgent care facility.",
            UrgencyLevel.emergency: "Seek immediate medical attention. Call emergency services or go to the nearest emergency room."
        }
        guidance = guidance_map[urgency_level]
        
        # Step 5: Generate AI explanation
        ai_explanation = generate_ai_explanation(data, possible_causes)
        
        return AnalysisResult(
            urgencyLevel=urgency_level,
            possibleCauses=possible_causes,
            guidance=guidance,
            redFlags=[],
            aiExplanation=ai_explanation,
            isEmergency=urgency_level == UrgencyLevel.emergency
        )
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Analysis failed: {str(e)}")

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)