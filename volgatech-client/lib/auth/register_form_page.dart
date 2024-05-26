import 'package:flutter/material.dart';
import 'package:volgatech_client/auth/model/register_model.dart';
import 'package:volgatech_client/core/model/entities/user.dart';
import 'package:volgatech_client/core/model/extension/iterable_extension.dart';
import 'package:volgatech_client/core/page/base_form_page.dart';
import 'package:volgatech_client/core/page/base_page.dart';
import 'package:volgatech_client/core/theme/theme_builder.dart';
import 'package:volgatech_client/core/view/widgets/card_widget.dart';
import 'package:volgatech_client/core/view/widgets/custom_back_button.dart';
import 'package:volgatech_client/core/view/widgets/decorated_text_form_field.dart';

class RegisterFormPage extends BasePage {
  const RegisterFormPage({super.key});

  @override
  _RegisterFormPageState createState() => _RegisterFormPageState();
}

class _RegisterFormPageState
    extends BaseFormPageState<RegisterFormPage, RegisterModel> {
  final GlobalKey nameFieldKey = GlobalKey();
  final GlobalKey loginFieldKey = GlobalKey();
  final GlobalKey passwordFieldKey = GlobalKey();

  final FocusNode nameFocusNode = FocusNode();
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
              _buildNameField(context),
              _buildLoginField(context),
              _buildPasswordField(context),
              _buildUserRoleField(context),
              _buildSubmitButton(context),
            ].separate((_, __) => const SizedBox(height: 20)).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildFormTitle(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            Text(
              "Регистрация",
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            const Spacer(),
          ],
        ),
        const CustomBackButton(),
      ],
    );
  }

  Widget _buildNameField(BuildContext context) {
    return DecoratedTextFormField(
      formFieldKey: nameFieldKey,
      focusNode: nameFocusNode,
      controller: formModel.nameController,
      maxLength: 255,
      maxLines: 1,
      textInputAction: TextInputAction.next,
      labelText: "Имя пользователя",
      labelStyle: AppTextStyle.body2.copyWith(fontWeight: FontWeight.w500),
      decoration: const InputDecoration(counterText: ""),
      onFieldSubmitted: (value) {
        nameFocusNode.unfocus();
        FocusScope.of(context).requestFocus(loginFocusNode);
      },
      autofillHints: const [AutofillHints.name],
      validator: formModel.validateLogin,
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

  Widget _buildUserRoleField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Роль пользователя",
          style: AppTextStyle.body2.copyWith(fontWeight: FontWeight.w500),
        ),
        DropdownButtonFormField(
          padding: const EdgeInsets.symmetric(vertical: 12),
          value: formModel.userRole,
          items: UserRole.getValues()
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e.toString()),
                ),
              )
              .toList(),
          borderRadius: BorderRadius.circular(8),
          onChanged: (value) {
            if (value != null) {
              formModel.userRole = value;
            }
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: ElevatedButton(
        onPressed: () => trySubmitForm(context),
        child: Text(
          "Зарегистрироваться",
          style: AppTextStyle.title.copyWith(color: AppColors.white),
        ),
      ),
    );
  }

  @override
  Future<void> submitForm(BuildContext context) async {
    print("Form Submitted");

    var success = await formModel.register();
    if (!success) {
      return;
    }

    Navigator.of(context).push(bundleModule.routes.bundleListRoute());
  }

  @override
  RegisterModel? createModel() => RegisterModel(appModel: appModel);
}
