import 'dart:convert';

import 'package:http/http.dart' as http;

enum BASE_URL { CLOUD_FUNCTIONS, GOOGLE_APP_ENGINE }

class NetworkHelper {
  String baseURL;

  static const BASE_URL_CLOUD_FUNCTIONS =
      'www.us-central1-betsquad-314ef.cloudfunctions.net';

  static const BASE_URL_GOOGLE_APP_ENGINE =
      'www.betsquad-314ef.appspot.com';

  NetworkHelper(BASE_URL baseUrl) {
    if (baseUrl == BASE_URL.CLOUD_FUNCTIONS)
      this.baseURL = BASE_URL_CLOUD_FUNCTIONS;
    else
      this.baseURL = BASE_URL_GOOGLE_APP_ENGINE;
  }

  Future getString(
      String endpoint, Map<String, String> parameters) async {
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
