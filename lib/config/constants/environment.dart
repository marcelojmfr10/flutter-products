import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static initEnvironment() async {
    await dotenv.load();
  }

  static String apiURL =
      dotenv.env['API_URL'] ?? 'No está configurado el API_URL';
}
