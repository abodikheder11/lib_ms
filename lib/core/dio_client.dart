
import 'package:http/http.dart' as http;
import '../../config/env.dart';

class ApiClient {
  ApiClient._();

  static final http.Client instance = http.Client();

  static const Duration connectTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 20);

  static const Map<String, String> defaultHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  static Uri url(String pathOrUrl) {
    if (pathOrUrl.startsWith('http://') || pathOrUrl.startsWith('https://')) {
      return Uri.parse(pathOrUrl);
    }
    final base = Uri.parse(Env.baseUrl.endsWith('/') ? Env.baseUrl : '${Env.baseUrl}/');
    return base.resolve(pathOrUrl.startsWith('/') ? pathOrUrl.substring(1) : pathOrUrl);
  }
}
