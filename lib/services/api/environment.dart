import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String endpoint = dotenv.env['API_ENDPOINT'] ?? 'default_url';
  // static String endpoint = dotenv.env['API_ENDPOINT_LOCAL'] ?? 'default_url';
  static String apiKey = dotenv.env['API_KEY'] ?? 'default_key';

  static String endpointApi = "${Environment.endpoint}/";
  static String endpointFile = "${Environment.endpoint}/file/get-image/";
}
