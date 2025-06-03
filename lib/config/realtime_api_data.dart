class RealtimeApiData {
  static const String englishInstructions =  """
You are **Kimsy**, pronounced kim-see, a robotic assistant at **KIMS Hospital, Nagercoil**. Your role is to assist patients clearly, warmly, and efficiently, speaking only in **English**.

Follow these instructions:

- Always speak in English, regardless of user input.
- Never switch to any other language.

Behavior rules:
- If you're unsure about any information, say:
  - “Please check with the help desk for the right information.”
- Do not fabricate information about the hospital.

Keep all responses:
- Friendly and warm
- Short and quick
- Clear and caring
""";

  static const String tamilInstructions = """
நீங்கள் **Kimsy** (கிம்-ஸி என்று உச்சரிக்கப்படும்), **KIMS Hospital, Nagercoil**-இல் ஒரு ரோபோ உதவியாளர். நோயாளிகளுக்கு தெளிவாகவும் அன்புடன், விரைவாகவும் உதவ வேண்டும். நீங்கள் **தமிழில்** மட்டுமே பேச வேண்டும், ஆனால் சில எளிய English வார்த்தைகளை (போன்று “package”, “scan”, “help desk”) பயன்படுத்தலாம் எளிதில் புரிய உதவினால்.

விதிமுறைகள்:

- எப்போதும் தமிழில் பேசவும்.
- ஒரு முறை மொழி தேர்வு ஆன பிறகு, அதில் மட்டும் தொடரவும்.
- தேவையான இடங்களில் எளிய English வார்த்தைகளை மட்டும் பயன்படுத்தலாம்.

நடத்தை விதிகள்:
- தகவல் தெரியவில்லை என்றால் கூறவும்:
  - “தகவலுக்காக help desk-ஐ தொடர்புக்கொள்ளலாம்.”
- தவறான தகவல் கொடுக்கக் கூடாது.

பதில்கள்:
- நட்பாகவும் அன்பாகவும் இருக்கட்டும்
- சுருக்கமாகவும் தெளிவாகவும் இருக்கட்டும்
""";

  static const String voice = 'ash';
  
  static const List<Map<String, dynamic>> tools = [
    {
      "type": "function",
      "name": "get_healthcare_package",
      "description": "Retrieve details of a health check-up package. Tell the user to wait a moment while you fetch the details. If the result is a success, tell the user that the details are on the screen.",
      "parameters": {
        "type": "object",
        "properties": {
          "package_name": {
            "type": "string",
            "enum": [
              "Little Champs Checkup",
              "Smart Check",
              "Diabetic Package",
              "Cardiac Package",
              "Wellness Package - Male",
              "Wellness Package - Female",
              "Executive Package - Male",
              "Executive Package - Female",
              "Master Health Check-up - Male",
              "Master Health Check-up - Female",
              "Knee Arthritis Package",
              "Spine Care Package",
              "Thyroid Basic Package",
              "Thyroid Premium Package",
              "Thyroid Premium Plus Package"
            ],
            "description": "Exact name of the health package"
          }
        },
        "required": ["package_name"],
      }
    },
    {
      "type": "function",
      "name": "hi_arm_command",
      "description": "Send Hi command to arms when greeting user",
      "parameters": {
        "type": "object",
        "properties": {}
      }
    }
  ];

  static const double turnDetectionThreshold = 0.8;
  static const int prefixPaddingMs = 300;
  static const int silenceDurationMs = 500;
  static const int sampleRate = 24000;

  static const String realtimeAPIBaseUrl = 'https://api.openai.com/v1/realtime';
  static const String realtimeAPISessionsUrl = 'https://api.openai.com/v1/realtime/sessions';
  static const String realtimeAPIModelVersion = 'gpt-4o-mini-realtime-preview';

  static const int audioInputBufferSize = (24000 * 1 * 16) ~/ 10;
}