import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:volgatech_client/auth/model/auth_model.dart';
import 'package:volgatech_client/core/model/extension/iterable_extension.dart';
import 'package:volgatech_client/core/page/base_form_page.dart';
import 'package:volgatech_client/core/page/base_page.dart';
import 'package:volgatech_client/core/theme/theme_builder.dart';
import 'package:volgatech_client/core/view/widgets/card_widget.dart';
import 'package:volgatech_client/core/view/widgets/decorated_text_form_field.dart';

class AuthFormPage extends BasePage {
  const AuthFormPage({super.key});

  @override
  _AuthFormPageState createState() => _AuthFormPageState();
}

class _AuthFormPageState extends BaseFormPageState<AuthFormPage, AuthModel> {
  final GlobalKey loginFieldKey = GlobalKey();
  final GlobalKey passwordFieldKey = GlobalKey();

  final FocusNode loginFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  @override
  bool get isFullScreenSizeForm => true;

  @override
  bool get isSafeAreaEnabled => true;

  @override
  bool get shouldBuildNavigatorAppBar => false;

  @override
  Widget buildForm(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 600,
        child: CardWidget(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildFormTitle(context),
              _buildLoginField(context),
              _buildPasswordField(context),
              _buildSubmitButton(context),
              _buildRegisterButton(context),
            ].separate((_, __) => const SizedBox(height: 20)).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildFormTitle(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: const [
          TextSpan(text: "Вход в учетную запись "),
          TextSpan(
            text: "Волгатех",
            style: TextStyle(color: AppColors.secondaryColor),
          ),
        ],
        style: Theme.of(context).textTheme.displaySmall,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildLoginField(BuildContext context) {
    return DecoratedTextFormField(
      formFieldKey: loginFieldKey,
      focusNode: loginFocusNode,
      controller: formModel.loginController,
      maxLength: 255,
      maxLines: 1,
      textInputAction: TextInputAction.next,
      labelText: "Логин",
      labelStyle: AppTextStyle.body2.copyWith(fontWeight: FontWeight.w500),
      decoration: const InputDecoration(counterText: ""),
      onFieldSubmitted: (value) {
        loginFocusNode.unfocus();
        FocusScope.of(context).requestFocus(passwordFocusNode);
      },
      autofillHints: const [AutofillHints.username],
      validator: formModel.validateLogin,
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return DecoratedTextFormField(
      formFieldKey: passwordFieldKey,
      focusNode: passwordFocusNode,
      controller: formModel.passwordController,
      obscureText: true,
      maxLength: 255,
      maxLines: 1,
      textInputAction: TextInputAction.done,
      labelText: "Пароль",
      labelStyle: AppTextStyle.body2.copyWith(fontWeight: FontWeight.w500),
      decoration: const InputDecoration(counterText: ""),
      onFieldSubmitted: (value) => passwordFocusNode.unfocus(),
      validator: formModel.validatePassword,
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: ElevatedButton(
        onPressed: () => trySubmitForm(context),
        child: Text(
          "Войти",
          style: AppTextStyle.title.copyWith(color: AppColors.white),
        ),
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => Navigator.of(context).push(
        authModule.routes.registerFormRoute(),
      ),
      child: const Text(
        "Зарегистрироваться",
        style: TextStyle(
          color: AppColors.secondaryColor,
          fontSize: 17,
          fontWeight: FontWeight.w500,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  @override
  Future<void> submitForm(BuildContext context) async {
    print("Form Submitted");

    var success = await formModel.authByLogin();
    if (!success) {
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      appModel.bundleModule.routes.bundleListRoute(),
      (route) => false,
    );
  }

  @override
  AuthModel? createModel() => AuthModel(appModel: appModel);
}
