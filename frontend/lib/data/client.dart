import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'models/states_response.dart';
import 'util/metriced_http_client.dart';
import 'util/error.dart';
import 'dart:convert';

abstract class Api {
  Future<List<State>> getStates();
}

class ApiClient implements Api {
  String baseUrl;
  ApiClient(this.baseUrl);
  final Logger log = new Logger('ApiClient');
  final MetricHttpClient httpClient = MetricHttpClient(http.Client());


  @override
  Future<List<State>> getStates() async {
    return StatesResponse.fromJson(await getResponse("/voterRoll/states")).states;
  }

  Future<Map<String, dynamic>> getResponse(String url) {
    return ErrorTransformer.transform(
        httpClient.get("$baseUrl" + "$url").then((http.Response response) {
      logHttp(response);
      final statusCode = response.statusCode;
      if (statusCode < 200 || statusCode >= 300) {
        throw new Exception(
            "Error while getting response [StatusCode:$statusCode, Error:${response.reasonPhrase}]");
      }

      return jsonDecode(response.body) as Map<String, dynamic>;
    }));
  }

  void logHttp(http.Response response) {
    log.info(response.request.toString());
    log.info(response.headers.toString());
    log.info(response.body.toString());
  }
}

