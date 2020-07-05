import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:liebeslied/core/lib.dart';
import 'package:logging/logging.dart';
import 'util/metriced_http_client.dart';
import 'util/error.dart';

abstract class Api {
  Future<String> getData();
}

class ApiClient implements Api {
  String baseUrl;
  ApiClient(this.baseUrl);
  final Logger log = new Logger('ApiClient');
  final MetricHttpClient httpClient = MetricHttpClient(http.Client());

  @override
  Future<String> getData() {
    return ErrorTransformer.transform(
        httpClient.get("$baseUrl").then((http.Response response) {
      logHttp(response);
      final statusCode = response.statusCode;
      if (statusCode < 200 || statusCode >= 300) {
        throw new Exception(
            "Error while getting response [StatusCode:$statusCode, Error:${response.reasonPhrase}]");
      }
      return null;
      // return Response.fromBuffer(response.bodyBytes);
    }));
  }

  void logHttp(http.Response response) {
    log.info(response.request.toString());
    log.info(response.headers.toString());
  }
}

