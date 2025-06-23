import 'package:flutter_dotenv/flutter_dotenv.dart';

class DotenvService {  
  Future<void> loadEnv() async {
    await dotenv.load();
  }

  String getApiKey() {
    return dotenv.env["OPENAI_API_KEY"] ?? "";
  }
}