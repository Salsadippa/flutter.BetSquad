import 'dart:convert';

import 'package:http/http.dart' as http;

enum BASE_URL { CLOUD_FUNCTIONS, GOOGLE_APP_ENGINE, BASE_URL_PAYMENT_SERVER }

class NetworkHelper {
  String baseURL;

  static const BASE_URL_CLOUD_FUNCTIONS =
      'www.us-central1-betsquad-314ef.cloudfunctions.net';

  static const BASE_URL_GOOGLE_APP_ENGINE = 'www.betsquad-314ef.appspot.com';

  static const BASE_URL_PAYMENT_SERVER = 'wwww.api.bet-squad.com';

  NetworkHelper(BASE_URL baseUrl) {
    if (baseUrl == BASE_URL.CLOUD_FUNCTIONS)
      this.baseURL = BASE_URL_CLOUD_FUNCTIONS;
    else if (baseUrl == BASE_URL.GOOGLE_APP_ENGINE)
      this.baseURL = BASE_URL_GOOGLE_APP_ENGINE;
    else
      this.baseURL = BASE_URL_PAYMENT_SERVER;
  }

  Future getString(String endpoint, Map<String, String> parameters) async {
    var uri = Uri.http(this.baseURL, endpoint, parameters);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      String data = response.body;
      return data;
    } else {
      print(response.statusCode);
    }
  }

  Future getJSON(String endpoint, Map<String, String> parameters) async {
    var uri = Uri.http(this.baseURL, endpoint, parameters);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      print(response.statusCode);
    }
  }
}
