import 'dart:async';

import 'package:volgatech_client/auth/model/entities/auth_events.dart';
import 'package:volgatech_client/core/model/api/api_response.dart';
import 'package:volgatech_client/core/model/app_model.dart';
import 'package:volgatech_client/core/model/entities/user.dart';

/// Класс для хранения данных текущего пользователя приложения.
/// * Профиль пользователя [User]
/// * accessToken - для доступа к авторизованным методам API
/// * pushToken - для push уведомлений
class AppUser {
  static const String _accessTokenKey = "accessToken";

  late final AppModel appModel;

  User? user;
  late StreamSubscription invalidAccessTokenEventSubscription;

  AppUser({required this.appModel}) {
    _registerEventBus();
  }

  bool get canAddEdit => user?.userRole == UserRole.teacher;

  bool get canMoveToStorage => user?.userRole != UserRole.student;

  Future<ApiResponse<User>> loadProfile() async {
    var apiResponse = await appModel.profileModule.api.loadOwnUserProfile();
    if (!apiResponse.isError) {
      user = apiResponse.result;
    }
    return apiResponse;
  }

  Future<String?> checkUserProfile() async {
    if (isAuthenticated()) {
      final response = await appModel.appUser.loadProfile();
      if (response.isError) {
        return response.error;
      }
    }
    return null;
  }

  String? getAccessToken() {
    return appModel.keyValueStorage.getStringForKey(_accessTokenKey);
  }

  Future<void> setAccessToken(String? value) async {
    await appModel.keyValueStorage.setStringForKey(_accessTokenKey, value);
    if (value != null) {
      appModel.eventBus.fire(LoginEvent(this));
    }
  }

  Future<void> logout() async {
    appModel.eventBus.fire(LogoutEvent(this));
    await setAccessToken(null);
  }

  bool isAuthenticated() {
    var accessToken = getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      return false;
    }
    return true;
  }

  void _registerEventBus() {
    invalidAccessTokenEventSubscription =
        appModel.eventBus.on<InvalidAccessToken>().listen(
              (event) => logout(),
            );
  }
}
