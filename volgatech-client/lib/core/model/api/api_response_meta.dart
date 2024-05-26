/// Часть стандартного ответа любого API.
/// Содержит информацию о том:
/// - успешный ли запрос
/// - есть ли какая-то ошибка с сервера (ошибка валидаци данных или выполнения метода API)
class ApiResponseMeta {
  final String? error;
  final bool invalidAccessToken;
  final bool success;

  ApiResponseMeta({
    this.error,
    this.invalidAccessToken = false,
    this.success = false,
  });

  factory ApiResponseMeta.fromJson(Map<String, dynamic> json) {
    return ApiResponseMeta(
      error: json['error'],
      invalidAccessToken: json['invalidAccessToken'] ?? false,
      success: json['success'] ?? false,
    );
  }
}
