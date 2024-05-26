import 'dart:convert';

import 'package:volgatech_client/core/model/api/api_response.dart';
import 'package:volgatech_client/core/model/api/api_response_meta.dart';
import 'package:volgatech_client/core/model/api/base_api_response.dart';
import 'package:http/http.dart';

/// Утилитарный класс для парсинга ответа сервера.
/// Позволяет парсить список сущностей, возвращенных с сервера.
/// А также одну сущность, возвращенную с сервера.
class ApiResponseParser {
  static BaseApiResponse parseRawResponse(Response response) {
    final statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400) {
      return BaseApiResponse(
        error: "Не удалось отправить запрос. Попробуйте еще раз",
        rawData: response.body,
      );
    }
    return _parseBody(response.body);
  }

  /// Парсинг списка объектов из результата выполненного запроса к API.
  static ApiResponse<List<T>> parseListFromResponse<T>(
    BaseApiResponse response, {
    required T Function(dynamic) fromJson,
    String? emptyError,
  }) {
    try {
      if (response.isError) {
        return ApiResponse.error(
          error: response.error!,
          baseApiResponse: response,
        );
      }

      if (response.dataJson == null) {
        return ApiResponse.error(
          error: emptyError ?? "Данные не найдены",
          baseApiResponse: response,
        );
      }
      final list = (response.dataJson as List).map((e) => fromJson(e)).toList();
      return ApiResponse(
        baseApiResponse: response,
        result: list,
      );
    } catch (e) {
      return ApiResponse.error(
        error: 'Произошла ошибка, Попробуйте позже.',
        baseApiResponse: response,
      );
    }
  }

  /// Парсинг одного объекта из результата выполненного запроса к API.
  static ApiResponse<T> parseObjectFromResponse<T>(
    BaseApiResponse response, {
    required T Function(dynamic) fromJson,
    String? emptyError,
  }) {
    try {
      if (response.isError) {
        return ApiResponse.error(
          error: response.error!,
          baseApiResponse: response,
        );
      }

      var jsonData = response.dataJson;
      if (jsonData == null) {
        return ApiResponse.error(
          error: emptyError ?? "Данные не найдены",
          baseApiResponse: response,
        );
      }
      final object = fromJson(jsonData);
      return ApiResponse(
        baseApiResponse: response,
        result: object,
      );
    } catch (e) {
      return ApiResponse.error(
        error: 'Произошла ошибка, Попробуйте позже.',
        baseApiResponse: response,
      );
    }
  }

  static BaseApiResponse _parseBody(String? body) {
    if (body == null) {
      return BaseApiResponse(
        error: "Bad Request Format",
        rawData: body,
      );
    }
    dynamic responseJson = json.decode(body);
    dynamic dataJson = responseJson["data"];

    try {
      var apiResponseMeta = ApiResponseMeta.fromJson(responseJson);

      if (!apiResponseMeta.success) {
        return BaseApiResponse(
          error: apiResponseMeta.error,
          meta: apiResponseMeta,
          rawData: body,
        );
      }

      return BaseApiResponse(
        dataJson: dataJson,
        meta: apiResponseMeta,
        rawData: body,
      );
    } catch (e) {
      return BaseApiResponse(
        error: "Произошла ошибка, Попробуйте позже.",
        rawData: body,
      );
    }
  }
}
