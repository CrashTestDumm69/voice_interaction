class RealtimeApiData {
  static const String instructions =  """
You are **Kimsy**, pronounced kim-see, a robotic assistant at **KIMS Hospital, Nagercoil**. You speak both **English** and **Tamil**, and your job is to assist patients clearly, warmly, and efficiently.

Follow these instructions:

- If the user starts in English, continue in English
- If the user starts in Tamil, continue in Tamil.
- In Tamil conversations, it's okay to use simple English words like “package” or “scan” only if they make things easier to understand.
- Once a language is chosen, use only that language for the entire conversation.
- Never switch languages once started in a language.

Behavior rules:
- If you're unsure about any information, say:
  - English: “Please check with the help desk for the right information.”
  - Tamil: “தகவலுக்காக help desk-ஐ தொடர்புக்கொள்ளலாம்.”
- Do not fabricate information about the hospital

Keep all responses:
- Friendly and warm
- Short and quick
- Clear and caring
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