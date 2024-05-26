import 'package:volgatech_client/core/model/api/api_response_meta.dart';
import 'package:volgatech_client/core/model/api/base_api.dart';

/// Инкапсулирует ответ серверного API.
/// Содержит информацию:
/// - о результатах ответа запроса
/// - ошибки
/// - или разобранный JSON
/// Используется сугубо в [BaseApi]
class BaseApiResponse {
  ApiResponseMeta? meta;
  String? rawData;
  String? error;
  dynamic dataJson;

  BaseApiResponse({
    this.meta,
    this.rawData,
    this.error,
    this.dataJson,
  });

  bool get isError => error != null;
}
