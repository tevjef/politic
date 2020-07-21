import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:politic/data/models/user.dart';
import 'auth.dart';
import 'models/feed.dart';
import 'models/voter_roll.dart';
import 'util/metriced_http_client.dart';
import 'util/error.dart';
import 'dart:convert';

abstract class Api {
  Future<List<USState>> getStates();
  Future<VoterStatus> checkRegistration(CheckRegistrationRequest request);
  Future<Null> saveVoterEnrollment(EnrollmentRequest request);

  Future<DistrictLocation> saveLocation(LocationUpdateRequest request);
  Future<DistrictLocation> getLocation();
}

class ApiClient implements Api {
  String baseUrl;
  Auth auth;

  ApiClient(this.baseUrl, this.auth);
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
    return CheckRegistrationResponse.fromJson(await makePostRequest("/voterRoll/checkRegistration", request.toJson()))
        .voterStatus;
  }

  @override
  Future<Null> saveVoterEnrollment(EnrollmentRequest request) async {
    return Future<Null>.value(await makePostRequest("/voterRoll/save", request.toJson()).then((value) => null));
  }

  @override
  Future<DistrictLocation> getLocation() async {
    return GetLocationResponse.fromJson(await getAuthenticatedResponse("/user/location")).location;
  }

  @override
  Future<DistrictLocation> saveLocation(LocationUpdateRequest request) async {
    return LocationUpdateResponse.fromJson(await makePostRequest("/user/location", request.toJson())).location;
  }

  Future<Map<String, dynamic>> getResponse(String url) {
    return ErrorTransformer.transform(httpClient.get("$baseUrl" + "$url").then((http.Response response) {
      logHttp(response);
      final statusCode = response.statusCode;
      if (statusCode < 200 || statusCode >= 300) {
        throw new Exception("Error while getting response [StatusCode:$statusCode, Error:${response.reasonPhrase}]");
      }

      if (response.body.isEmpty) {
        return {};
      }
      
      return jsonDecode(response.body) as Map<String, dynamic>;
    }));
  }

  Future<Map<String, dynamic>> getAuthenticatedResponse(String url) async {
    var authToken = await auth.getAuthToken();
    if (authToken == null) {
      return Future.error(AuthException("User is not signed in", authToken));
    }

    return ErrorTransformer.transform(httpClient.get("$baseUrl" + "$url",
        headers: {'Content-Type': 'application/json', 'Authorization': authToken}).then((http.Response response) {
      logHttp(response);

      final statusCode = response.statusCode;
      if (statusCode < 200 || statusCode >= 300) {
        throw new Exception("Error while getting response [StatusCode:$statusCode, Error:${response.reasonPhrase}]");
      }

      if (response.body.isEmpty) {
        return {};
      }

      return jsonDecode(response.body) as Map<String, dynamic>;
    }));
  }

  @override
  Future<Map<String, dynamic>> makePostRequest(String path, Map<String, dynamic> request) async {
    String requestBody = jsonEncode(request);
    log.info("REQUEST: " + requestBody);

    var authToken = await auth.getAuthToken();
    if (authToken == null) {
      return Future.error(AuthException("User is not signed in", authToken));
    }

    return ErrorTransformer.transform(httpClient
        .post("$baseUrl" + path,
            headers: {'Content-Type': 'application/json', 'Authorization': authToken}, body: requestBody)
        .then((http.Response response) {
      logHttp(response);
      final statusCode = response.statusCode;
      if (statusCode < 200 || statusCode >= 300) {
        throw new Exception("Error while getting response [StatusCode:$statusCode, Error:${response.reasonPhrase}]");
      }

      if (response.body.isEmpty) {
        return {};
      }

      return jsonDecode(response.body);
    }));
  }

  void logHttp(http.Response response) {
    log.info(response.request.toString());
    log.info(response.headers.toString());
    log.info(response.body.toString());
  }
}
