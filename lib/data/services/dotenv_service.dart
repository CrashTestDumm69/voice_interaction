import 'package:flutter_dotenv/flutter_dotenv.dart';

class DotenvService {  
  DotenvService() {
    _loadEnv();
  }
  
  void _loadEnv() async {
    await dotenv.load();
  }

  static String getApiKey() {
    return dotenv.env["OPENAI_API_KEY"] ?? "";
  }
}