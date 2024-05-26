import 'package:flutter/material.dart';
import 'package:volgatech_client/auth/model/auth_api.dart';
import 'package:volgatech_client/core/model/entities/user.dart';
import 'package:volgatech_client/core/model/models/form_model.dart';

class RegisterModel extends FormModel {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  UserRole userRole = UserRole.student;

  AuthApi get api => appModel.authModule.api;

  RegisterModel({required super.appModel});

  Future<bool> register() async {
    var response = await api.register(
      name: nameController.text,
      login: loginController.text,
      password: passwordController.text,
      userRole: userRole,
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

  String? validateName(String? value) {
    if (value?.isEmpty ?? true) {
      return "Поле не может быть пустым";
    }
    return null;
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
