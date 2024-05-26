import 'package:volgatech_client/core/model/api/api_response.dart';
import 'package:volgatech_client/core/model/api/api_response_parser.dart';
import 'package:volgatech_client/core/model/api/private_api.dart';
import 'package:volgatech_client/core/model/entities/user.dart';

class ProfileApi extends PrivateApi {
  ProfileApi({required super.appModel});

  Future<ApiResponse<User>> loadOwnUserProfile() async {
    final response = await sendGetRequest('user/profile', {});

    return ApiResponseParser.parseObjectFromResponse(
      response,
      fromJson: (json) => User.fromJson(json),
      emptyError: 'Данные пользователя не найдены',
    );
  }
}
