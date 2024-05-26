import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:volgatech_client/core/model/api/api_response_parser.dart';
import 'package:volgatech_client/core/model/api/base_api_response.dart';
import 'package:volgatech_client/core/model/app_model.dart';

/// Предоставляет возможности для отправки
/// - GET запросов
/// - POST запросов
/// - POST запросов с файлами (например, для загрузки аватарки для редактирования профиля пользователя)
/// А также парсит ответ сервера в json.
/// - Возвращает [BaseApiResponse]
/// - Который содержит json или ошибку
abstract class BaseApi {
  final AppModel appModel;

  BaseApi({required this.appModel});

  @protected
  Future<Uri> buildUri({
    required String relativePath,
    Map<String, dynamic>? queryParameters,
  }) async {
    queryParameters ??= {};
    var uri = Uri.http(
      "localhost:5000",
      "/api/$relativePath",
      queryParameters,
    );
    return uri;
  }

  Future<BaseApiResponse> sendGetRequest(
    String relativePath,
    Map<String, dynamic>? params,
  ) async {
    if (await isInternetNotAvailable()) {
      return BaseApiResponse(
        error: "Вероятно потеряно интернет соединение. Повторите позднее.",
      );
    }
    var uri = await buildUri(
      relativePath: relativePath,
      queryParameters: params,
    );

    print("Send GET: ${uri.toString()}");
    return get(uri)
        .then((Response response) => parseResponse(response))
        .catchError(
      (error) {
        if (error is String) {
          return BaseApiResponse(error: error.toString());
        }
        if (error is SocketException) {
          return BaseApiResponse(
            error: "Ошибка подключения к интернету",
          );
        }
        return BaseApiResponse(
          error: "Произошла непредвиденная ошибка",
        );
      },
    );
  }

  Future<BaseApiResponse> sendPostRequest(
    String relativePath,
    Map<String, dynamic>? params,
  ) async {
    if (await isInternetNotAvailable()) {
      return BaseApiResponse(
        error: "Вероятно потеряно интернет соединение. Повторите позднее.",
      );
    }
    var uri = await buildUri(relativePath: relativePath);

    print("Send POST: ${uri.toString()}");
    print("params: ${params.toString()}");
    return post(
      uri,
      body: json.encode(params),
      headers: {'Content-Type': 'application/json'},
    ).then((Response response) => parseResponse(response)).catchError(
          (error) => BaseApiResponse(
            error: (error is String)
                ? error
                : "Возникла неизвестная ошибка. Повторите позднее.",
          ),
        );
  }

  Future<BaseApiResponse> sendPostRequestWithFiles(
    String relativePath,
    Map<String, String> params,
    List<MultipartFile> files,
  ) async {
    if (await isInternetNotAvailable()) {
      return BaseApiResponse(
        error: "Вероятно потеряно интернет соединение. Повторите позднее.",
      );
    }
    var uri = await buildUri(relativePath: relativePath);
    print("Send POST: ${uri.toString()}");
    var request = MultipartRequest("POST", uri);
    request.fields.addAll(params);
    request.files.addAll(files);
    return await request
        .send()
        .then((streamedResponse) => Response.fromStream(streamedResponse))
        .then((Response response) => parseResponse(response))
        .catchError(
          (error) => BaseApiResponse(
            error: (error is String)
                ? error
                : "Возникла неизвестная ошибка. Повторите позднее.",
          ),
        );
  }

  @protected
  BaseApiResponse parseResponse(Response response) {
    return ApiResponseParser.parseRawResponse(response);
  }

  Future<bool> isInternetNotAvailable() async {
    var connectivityResult = await appModel.internetMonitor.checkConnection();
    if (connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet)) {
      return false;
    }
    return true;
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) =>
      super.createHttpClient(context)
        ..badCertificateCallback = (
          X509Certificate cert,
          String host,
          int port,
        ) =>
            true;
}
