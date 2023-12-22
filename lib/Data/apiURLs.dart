import 'package:http/http.dart';

class ApiURLs {
  static String baseURL = 'almassra-env.eba-gpnkbmm4.eu-central-1.elasticbeanstalk.com';
  static Uri getBusData = Uri.http(baseURL, '/api/Bus/GetBusData');
  static Uri logInBus = Uri.http(baseURL, '/api/shared/LogInBus');
  static Uri postBusLocation = Uri.http(baseURL, "/api/BusLocation/PostBusLocation");

}