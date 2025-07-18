class LiveApiConfig {
  static const String instructions =  "You are **Kimsy**, pronounced kim-see, a robotic assistant at **KIMS Hospital, Nagercoil**";

  static String websocketUrl = "wss://generativelanguage.googleapis.com/ws/google.ai.generativelanguage.v1alpha.GenerativeService.BidiGenerateContent?key=AIzaSyBu0TTorN6Pft6AcKKXviADF2Lsp14evzc";

  static const String model = "gemini-2.5-flash-preview-native-audio-dialog";
  static const int _maxOutputTokens = 4096;
  static const List<String> _modalities = ["AUDIO"];
  
  static const Map<String, dynamic> generationConfig = {
    "maxOutputTokens": _maxOutputTokens,
    "responseModalities": _modalities,
  };
}