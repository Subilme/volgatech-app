import 'package:volgatech_client/core/model/api/api_response.dart';
import 'package:volgatech_client/core/model/api/base_api.dart';
import 'package:volgatech_client/core/model/entities/user.dart';

class AuthApi extends BaseApi {
  AuthApi({required super.appModel});

  Future<ApiResponse<String>> authByLogin({
    required String login,
    required String password,
  }) async {
    var params = {
      'login': login,
      'password': password,
    };

    final response = await sendPostRequest('user/auth', params);

    if (response.isError) {
      return ApiResponse.error(
        baseApiResponse: response,
        error: response.error!,
      );
    }

    return ApiResponse(
      baseApiResponse: response,
      result: response.dataJson,
    );
  }

  Future<ApiResponse<String>> register({
    required String name,
    required String login,
    required String password,
    required UserRole userRole,
  }) async {
    var params = {
      'name': name,
      'login': login,
      'password': password,
      'userRole': userRole.value.toString(),
    };

    final response = await sendPostRequest('user/register', params);

    if (response.isError) {
      return ApiResponse.error(
        baseApiResponse: response,
        error: response.error!,
      );
    }

    return ApiResponse(
      baseApiResponse: response,
      result: response.dataJson,
    );
  }
}
