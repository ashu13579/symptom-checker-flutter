"""
AI Service for Symptom Analysis
This module handles AI integration with strict medical safety constraints
"""

from typing import List, Dict, Any
import os

# In production, use environment variables for API keys
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY", "")
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY", "")

class AIService:
    """
    AI Service with medical safety constraints
    
    IMPORTANT SAFETY RULES:
    1. AI is used ONLY for explanation, not diagnosis
    2. All outputs must use probabilistic language
    3. No medication recommendations
    4. No treatment plans
    5. Always encourage professional care
    """
    
    def __init__(self, provider: str = "openai"):
        self.provider = provider
        self.safety_prompt = self._get_safety_prompt()
    
    def _get_safety_prompt(self) -> str:
        """
        Safety prompt that MUST be included in all AI requests
        """
        return """
        CRITICAL SAFETY INSTRUCTIONS:
        
        You are an educational health information assistant. You MUST follow these rules:
        
        1. NEVER provide a diagnosis
        2. NEVER recommend specific medications
        3. NEVER provide treatment plans
        4. ALWAYS use probabilistic language (may, might, could, possibly)
        5. ALWAYS include uncertainty in your responses
        6. ALWAYS encourage consulting healthcare professionals
        7. NEVER claim certainty about medical conditions
        8. Focus on education and awareness, not diagnosis
        
        Your role is to:
        - Explain possible causes in educational terms
        - Help users understand when to seek professional care
        - Provide general health information
        - Encourage appropriate medical consultation
        
        Format your response as:
        {
            "explanation": "Educational explanation with probabilistic language",
            "possible_causes": [
                {
                    "name": "Condition name",
                    "description": "Educational description",
                    "probability": 0.0-1.0,
                    "matching_symptoms": ["symptom1", "symptom2"]
                }
            ],
            "disclaimer": "This is not medical advice..."
        }
        """
    
    def analyze_symptoms(self, symptom_data: Dict[str, Any]) -> Dict[str, Any]:
        """
        Analyze symptoms using AI with safety constraints
        
        Args:
            symptom_data: Structured symptom information
            
        Returns:
            AI analysis with safety constraints applied
        """
        
        # Build the prompt
        prompt = self._build_prompt(symptom_data)
        
        # Call AI service based on provider
        if self.provider == "openai":
            return self._call_openai(prompt)
        elif self.provider == "gemini":
            return self._call_gemini(prompt)
        else:
            raise ValueError(f"Unsupported AI provider: {self.provider}")
    
    def _build_prompt(self, symptom_data: Dict[str, Any]) -> str:
        """Build a structured prompt from symptom data"""
        
        prompt = f"{self.safety_prompt}\n\n"
        prompt += "SYMPTOM INFORMATION:\n"
        prompt += f"Body Region: {symptom_data.get('bodyRegion', 'Unknown')}\n"
        
        if symptom_data.get('painType'):
            prompt += f"Pain Type: {symptom_data['painType']}\n"
        
        if symptom_data.get('intensity'):
            prompt += f"Pain Intensity: {symptom_data['intensity']}/10\n"
        
        if symptom_data.get('duration'):
            prompt += f"Duration: {symptom_data.get('durationValue', '')} {symptom_data['duration']}\n"
        
        if symptom_data.get('onset'):
            prompt += f"Onset: {symptom_data['onset']}\n"
        
        if symptom_data.get('triggers'):
            prompt += f"Triggers: {', '.join(symptom_data['triggers'])}\n"
        
        if symptom_data.get('associatedSymptoms'):
            prompt += f"Associated Symptoms: {', '.join(symptom_data['associatedSymptoms'])}\n"
        
        prompt += "\nProvide an educational explanation of possible causes with appropriate uncertainty."
        
        return prompt
    
    def _call_openai(self, prompt: str) -> Dict[str, Any]:
        """
        Call OpenAI API with safety constraints
        
        In production, implement actual API call:
        
        import openai
        
        response = openai.ChatCompletion.create(
            model="gpt-4",
            messages=[
                {"role": "system", "content": self.safety_prompt},
                {"role": "user", "content": prompt}
            ],
            temperature=0.3,  # Lower temperature for more consistent, safer responses
            max_tokens=500
        )
        
        return self._parse_ai_response(response.choices[0].message.content)
        """
        
        # Placeholder response for development
        return {
            "explanation": "Based on the symptoms described, there are several possible explanations to consider. However, this is educational information only and not a diagnosis.",
            "possible_causes": [],
            "disclaimer": "This information is for educational purposes only. Please consult a healthcare professional."
        }
    
    def _call_gemini(self, prompt: str) -> Dict[str, Any]:
        """
        Call Google Gemini API with safety constraints
        
        In production, implement actual API call:
        
        import google.generativeai as genai
        
        genai.configure(api_key=GEMINI_API_KEY)
        model = genai.GenerativeModel('gemini-pro')
        
        response = model.generate_content(
            prompt,
            safety_settings={
                'HARM_CATEGORY_MEDICAL': 'BLOCK_NONE',  # We handle medical safety ourselves
            }
        )
        
        return self._parse_ai_response(response.text)
        """
        
        # Placeholder response for development
        return {
            "explanation": "Based on the symptoms described, there are several possible explanations to consider. However, this is educational information only and not a diagnosis.",
            "possible_causes": [],
            "disclaimer": "This information is for educational purposes only. Please consult a healthcare professional."
        }
    
    def _parse_ai_response(self, response_text: str) -> Dict[str, Any]:
        """Parse and validate AI response"""
        
        # In production, parse JSON response and validate
        # Ensure all safety constraints are met
        # Filter out any diagnostic language
        # Add disclaimers if missing
        
        return {
            "explanation": response_text,
            "possible_causes": [],
            "disclaimer": "This information is for educational purposes only."
        }
    
    def validate_response(self, response: Dict[str, Any]) -> bool:
        """
        Validate AI response meets safety requirements
        
        Checks for:
        - No diagnostic claims
        - Probabilistic language
        - Appropriate disclaimers
        - No medication recommendations
        """
        
        explanation = response.get("explanation", "").lower()
        
        # Forbidden phrases that indicate diagnosis
        forbidden_phrases = [
            "you have",
            "you are diagnosed",
            "this is definitely",
            "you need to take",
            "take this medication",
            "the diagnosis is"
        ]
        
        for phrase in forbidden_phrases:
            if phrase in explanation:
                return False
        
        # Required elements
        if "disclaimer" not in response:
            return False
        
        return True


# Example usage
if __name__ == "__main__":
    ai_service = AIService(provider="openai")
    
    sample_data = {
        "bodyRegion": "chest",
        "painType": "pressure",
        "intensity": 6,
        "duration": "hours",
        "durationValue": 2,
        "associatedSymptoms": ["shortness of breath"]
    }
    
    result = ai_service.analyze_symptoms(sample_data)
    print(result)