import 'dart:async';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:volgatech_client/core/model/extension/iterable_extension.dart';
import 'package:volgatech_client/core/model/helpers/assets_catalog.dart';
import 'package:volgatech_client/core/page/mixin/module_fast_access_mixin.dart';
import 'package:volgatech_client/core/theme/theme_builder.dart';
import 'package:volgatech_client/core/view/extension/simple_padding_extension.dart';
import 'package:volgatech_client/core/view/image/avatar_image.dart';
import 'package:volgatech_client/core/view/widgets/base_alert_dialog.dart';
import 'package:volgatech_client/core/view/widgets/base_error_widget.dart';

import 'mixin/app_model_access_mixin.dart';
import 'no_internet_connection.dart';

abstract class BasePage extends StatefulWidget {
  final String? title;

  const BasePage({
    super.key,
    this.title,
  });
}

/// Базовый экран для всех экранов приложения.
///
/// * Создает [Scaffold] для экрана - [buildScaffold]
abstract class BasePageState<T extends BasePage> extends State<T>
    with ModuleFastAccessMixin, AppModelAccessMixin<T> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<StreamSubscription> subscriptions = [];

  /// Выключить, чтобы не оборачивать экран в [Scaffold]
  bool shouldBuildScaffold = true;

  bool shouldBuildNavigatorAppBar = true;

  /// Включить, чтобы обернуть экран в [SafeArea]
  bool isSafeAreaEnabled = false;
  bool _isLoadingIndicatorVisible = false;
  bool _shouldHideContentWithLoadingIndicator = false;
  bool shouldDecorateToAbsorbPointer = false;

  bool showNoInternetConnection = true;

  @override
  Widget build(BuildContext context) {
    var body = buildBody(context);
    body = decorateBody(context, body);
    if (isSafeAreaEnabled) {
      body = SafeArea(
        child: body,
      );
    }
    var scaffold = buildScaffold(context, body);
    return decorateScaffold(context, scaffold);
  }

  @protected
  Widget buildScaffold(BuildContext context, Widget body) {
    if (!shouldBuildScaffold) {
      return body;
    }
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: ThemeBuilder.systemUiOverlayStyle,
      child: Scaffold(
        key: scaffoldKey,
        body: body,
      ),
    );
  }

  @protected
  Widget decorateBody(BuildContext context, Widget body) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        if (!_isLoadingIndicatorVisible ||
            !_shouldHideContentWithLoadingIndicator)
          body,
        if (_isLoadingIndicatorVisible) buildLoadingIndicator(context),
        if (showNoInternetConnection)
          NoInternetConnection(internetMonitor: appModel.internetMonitor),
      ],
    );
  }

  Widget buildLoadingIndicator(
    BuildContext context, {
    double? margin,
    bool needShowOverlay = false,
  }) {
    if (needShowOverlay) {
      return Stack(
        alignment: AlignmentDirectional.center,
        children: [
          buildLoader(context, margin),
          Container(
            color: AppColors.lightBlack.withOpacity(0.2),
            height: double.infinity,
            width: double.infinity,
          ),
        ],
      );
    }
    return buildLoader(context, margin);
  }

  Widget buildLoader(BuildContext context, double? margin) {
    if (Platform.isAndroid) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: margin != null ? EdgeInsets.only(top: margin) : null,
            child: const SizedBox(
              height: 40.0,
              width: 40.0,
              child: CircularProgressIndicator(
                color: AppColors.secondaryColor,
              ),
            ),
          ),
        ],
      );
    }
    return Container(
      margin: margin != null ? EdgeInsets.only(top: margin) : null,
      child: const CupertinoActivityIndicator(
        radius: 25,
        color: AppColors.updatingIndicatorColor,
      ),
    );
  }

  @protected
  Widget buildBaseError({required Function onPressedButton}) => BaseErrorWidget(
        onPressedButton: onPressedButton,
      );

  @protected
  Widget decorateScaffold(BuildContext context, Widget scaffold) {
    return Column(
      children: [
        if (shouldBuildNavigatorAppBar)
          Material(
            child: Container(
              width: double.infinity,
              height: 84,
              color: AppColors.secondaryColor,
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Image.asset(AssetsCatalog.logo).rightPadding(20),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushReplacement(
                      appModel.bundleModule.routes.bundleListRoute(),
                    ),
                    child: Text(
                      "Наборы",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.white),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushReplacement(
                      appModel.projectModule.routes.projectListRoute(),
                    ),
                    child: Text(
                      "Проекты",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.white),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushReplacement(
                      appModel.reportModule.routes.reportRoute(),
                    ),
                    child: Text(
                      "Отчеты",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.white),
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton(
                    offset: const Offset(0.0, 55.0),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        enabled: false,
                        child: Text(
                          appUser.user?.name ?? "Пользователь",
                        ),
                      ),
                      PopupMenuItem(
                        onTap: () {
                          BaseAlertDialog.showDialog(
                            context: context,
                            title: "Внимание",
                            text:
                                "Вы уверены, что хотите выйти из своего аккаунта?",
                            onPositiveButtonPressed: () {
                              Navigator.pop(context);
                              showLoadingIndicator();
                              appUser.logout();
                            },
                            onNegativeButtonPressed: () =>
                                Navigator.pop(context),
                          );
                        },
                        child: const Text(
                          "Выйти",
                        ),
                      ),
                    ],
                    child: AvatarImage(
                      appUser.user?.avatar,
                      size: 50,
                    ),
                  ),
                ].separate((_, __) => const SizedBox(width: 20)).toList(),
              ),
            ),
          ),
        Expanded(
          child: AbsorbPointer(
            absorbing: shouldDecorateToAbsorbPointer,
            child: scaffold,
          ),
        ),
      ],
    );
  }

  /// Переопределите для построения тела экрана приложения.
  Widget buildBody(BuildContext context);


  Future<void> logout() async {
    showLoadingIndicator();
    await appUser.logout();
  }

  void showMessage({String? message}) {
    if (message == null) {
      return;
    }
    BotToast.showText(
      text: message,
    );
  }

  void showLoadingIndicator({
    bool shouldHideContentWithLoadingIndicator = false,
  }) {
    setState(() {
      _isLoadingIndicatorVisible = true;
      _shouldHideContentWithLoadingIndicator =
          shouldHideContentWithLoadingIndicator;
    });
  }

  void hideLoadingIndicator() {
    setState(() {
      _isLoadingIndicatorVisible = false;
      _shouldHideContentWithLoadingIndicator = false;
    });
  }

  bool get isLoadingIndicatorVisible {
    return _isLoadingIndicatorVisible;
  }
}
