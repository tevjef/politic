import 'dart:async';
import 'dart:io';

import 'package:http/http.dart';
import 'package:package_info/package_info.dart';

import 'package:firebase_performance/firebase_performance.dart';

class MetricHttpClient extends BaseClient {
  MetricHttpClient(this._inner);

  final Client _inner;

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    request.headers['user-agent'] = await getUserAgent();

    final HttpMetric metric = FirebasePerformance.instance
        .newHttpMetric(request.url.toString(), getRequestMethod(request));

    await metric.start();

    StreamedResponse response;
    try {
      response = await _inner.send(request);
      metric
        ..responsePayloadSize = response.contentLength
        ..responseContentType = response.headers['Content-Type']
        ..requestPayloadSize = request.contentLength
        ..httpResponseCode = response.statusCode;
    } finally {
      await metric.stop();
    }

    return response;
  }

  HttpMethod getRequestMethod(BaseRequest request) {
    HttpMethod method;
    if (request.method == "GET") {
      method = HttpMethod.Get;
    } else if (request.method == "POST") {
      method = HttpMethod.Post;
    } else if (request.method == "PUT") {
      method = HttpMethod.Put;
    } else if (request.method == "DELETE") {
      method = HttpMethod.Delete;
    } else if (request.method == "PATCH") {
      method = HttpMethod.Patch;
    } else if (request.method == "CONNECT") {
      method = HttpMethod.Connect;
    }

    return method;
  }

  Future<String> getUserAgent() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    var userAgent =
        '${appName}/${version} (${packageName}; build:${buildNumber}; ${Platform.operatingSystem} ${Platform.operatingSystemVersion})';

    return userAgent;
  }
}
