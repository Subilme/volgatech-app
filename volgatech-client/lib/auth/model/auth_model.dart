import 'package:flutter/cupertino.dart';
import 'package:volgatech_client/auth/model/auth_api.dart';
import 'package:volgatech_client/core/model/models/form_model.dart';

class AuthModel extends FormModel {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  AuthApi get api => appModel.authModule.api;

  AuthModel({required super.appModel});

  Future<bool> authByLogin() async {
    var response = await api.authByLogin(
      login: loginController.text,
      password: passwordController.text,
    );
    if (response.isError) {
      addError(response.error!);
      return false;
    }

    await appModel.appUser.setAccessToken(response.result);
    var userResponse = await appModel.appUser.loadProfile();
    if (userResponse.isError) {
      addError(userResponse.error!);
      return false;
    }

    return true;
  }

  String? validateLogin(String? value) {
    if (value?.isEmpty ?? true) {
      return "Поле не может быть пустым";
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value?.isEmpty ?? true) {
      return "Поле не может быть пустым";
    }
    return null;
  }
}
