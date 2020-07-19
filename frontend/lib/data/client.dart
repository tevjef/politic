import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'models/feed.dart';
import 'models/voter_roll.dart';
import 'util/metriced_http_client.dart';
import 'util/error.dart';
import 'dart:convert';

abstract class Api {
  Future<List<USState>> getStates();
  Future<VoterStatus> checkRegistration(CheckRegistrationRequest request);
}

class ApiClient implements Api {
  String baseUrl;
  ApiClient(this.baseUrl);
  final Logger log = new Logger('ApiClient');
  final MetricHttpClient httpClient = MetricHttpClient(http.Client());

  @override
  Future<List<USState>> getStates() async {
    return StatesResponse.fromJson(await getResponse("/voterRoll/states")).states;
  }

  @override
  Future<StateFeedResponse> getStatesFeed(String state) async {
    return StateFeedResponse.fromJson(await getResponse("/feeds/states/$state"));
  }

  @override
  Future<VoterStatus> checkRegistration(CheckRegistrationRequest request) async {
    String requestBody = jsonEncode(request);
    log.info(requestBody);

    return ErrorTransformer.transform(httpClient
        .post("$baseUrl" + "/voterRoll/checkRegistration",
            headers: {'Content-Type': 'application/json'}, body: requestBody)
        .then((http.Response response) {
      logHttp(response);
      final statusCode = response.statusCode;
      if (statusCode < 200 || statusCode >= 300) {
        throw new Exception("Error while getting response [StatusCode:$statusCode, Error:${response.reasonPhrase}]");
      }

      return CheckRegistrationResponse.fromJson(jsonDecode(response.body) as Map<String, dynamic>).voterStatus;
    }));
  }

  Future<Map<String, dynamic>> getResponse(String url) {
    return ErrorTransformer.transform(httpClient.get("$baseUrl" + "$url").then((http.Response response) {
      logHttp(response);
      final statusCode = response.statusCode;
      if (statusCode < 200 || statusCode >= 300) {
        throw new Exception("Error while getting response [StatusCode:$statusCode, Error:${response.reasonPhrase}]");
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
