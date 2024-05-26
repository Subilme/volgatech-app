import 'package:http/http.dart';
import 'package:volgatech_client/auth/model/entities/auth_events.dart';
import 'package:volgatech_client/core/model/api/base_api.dart';
import 'package:volgatech_client/core/model/api/base_api_response.dart';

/// Слой API, предназначенный для вызова тех методов API на сервере,
/// доступ к которым должен быть защищен авторизацией через accessToken (токен доступа).
/// accessToken обычно выдается пользователю после успешной авторизации через соответствующее API:
/// - например, после авторизации по телефону и одноразовому СМС коду
/// - или после авторизации по email и паролю
abstract class PrivateApi extends BaseApi {
  PrivateApi({required super.appModel});

  @override
  Future<Uri> buildUri({
    required String relativePath,
    Map<String, dynamic>? queryParameters,
  }) {
    queryParameters ??= {};
    queryParameters['accessToken'] = appModel.appUser.getAccessToken();

    return super.buildUri(
      relativePath: relativePath,
      queryParameters: queryParameters,
    );
  }

  @override
  BaseApiResponse parseResponse(Response response) {
    var baseApiResponse = super.parseResponse(response);
    if (baseApiResponse.meta?.invalidAccessToken ?? false) {
      appModel.eventBus.fire(InvalidAccessToken(this));
    }
    return baseApiResponse;
  }
}
