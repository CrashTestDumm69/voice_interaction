class LiveApiConfig {
  static const String instructions =  """
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

  static String websocketUrl = "wss://generativelanguage.googleapis.com/ws/google.ai.generativelanguage.v1beta.GenerativeService.BidiGenerateContent";

  static const String model = "gemini-2.5-flash-preview-native-audio-dialog";
  static const int _maxOutputTokens = 4096;
  static const List<String> _modalities = ["AUDIO"];
  
  static const Map<String, dynamic> generationConfig = {
    "maxOutputTokens": _maxOutputTokens,
    "responseModalities": _modalities,
  };
}