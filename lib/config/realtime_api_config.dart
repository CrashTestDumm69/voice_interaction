class RealtimeApiConfig {
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

  static const String voice = 'sage';

  static const double turnDetectionThreshold = 0.7;
  static const int prefixPaddingMs = 300;
  static const int silenceDurationMs = 400;
  static const int sampleRate = 24000;

  static const String realtimeAPIBaseUrl = 'https://api.openai.com/v1/realtime';
  static const String realtimeAPISessionsUrl = 'https://api.openai.com/v1/realtime/sessions';
  static const String realtimeAPIModelVersion = 'gpt-4o-mini-realtime-preview';

  static const int audioInputBufferSize = (24000 * 1 * 16) ~/ 10;
}