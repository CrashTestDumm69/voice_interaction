import 'package:flutter_dotenv/flutter_dotenv.dart';

class DotenvService {  
  static void loadEnv() {
    dotenv.load();
  }

  static String getApiKey() {
    return dotenv.env["OPENAI_API_KEY"] ?? "";
  }
}