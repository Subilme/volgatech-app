import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:volgatech_client/auth/model/entities/auth_events.dart';
import 'package:volgatech_client/core/custom_scroll_behavior.dart';
import 'package:volgatech_client/core/error_page.dart';
import 'package:volgatech_client/core/model/app_model.dart';
import 'package:volgatech_client/core/model/app_user.dart';
import 'package:volgatech_client/core/model/events/application_events.dart';
import 'package:volgatech_client/core/no_animation_material_page_route.dart';
import 'package:volgatech_client/core/theme/theme_builder.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// Главный класс, который запускается при старте работы приложения.
/// Отвечает за:
/// - инициализацию всех библиотек проекта
/// - создание главной модели проекта [AppModel]
/// - пока происходит загрузка, показывает загрузочный экран [SplashPage]
class Application extends StatefulWidget {
  const Application({super.key});

  @override
  _ApplicationState createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> with WidgetsBindingObserver {
  AppModel? _appModel;

  GlobalKey _materialAppKey = GlobalKey();
  final GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();
  final ThemeBuilder _themeBuilder = ThemeBuilder();
  bool _isInitialized = false;
  String? _error;

  final List<StreamSubscription> _subscriptions = [];

  @override
  void initState() {
    super.initState();

    _prepareSystemChrome();
    _prepareLibs();
  }

  @override
  void dispose() {
    _disposeLibs();
    _unsubscribeAllEvents();
    super.dispose();
  }

  Future<void> _prepareLibs() async {
    await Hive.initFlutter();

    await appModel.initComponent();
    _subscriptions.add(appModel.eventBus
        .on<ReloadApplication>()
        .listen((event) => reloadApp()));
    _preparePushNotificationManager();
    _preloadData();
  }

  Future<void> _preloadData() async {
    final profileError = await appModel.appUser.checkUserProfile();
    if (profileError != null) {
      initializeApp(profileError);
      return;
    }
    initializeApp(null);
  }

  void initializeApp(String? error) {
    setState(() {
      _isInitialized = true;
      _error = error;
    });
  }

  void _disposeLibs() {
    Hive.close();
    WidgetsBinding.instance.removeObserver(this);
  }

  void _prepareSystemChrome() {
    WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setSystemUIOverlayStyle(
      ThemeBuilder.systemUiOverlayStyle,
    );
  }

  NoAnimationMaterialPageRoute prepareStartPage(BuildContext context) {
    if (_error != null) {
      return NoAnimationMaterialPageRoute(
        builder: (BuildContext context) => ErrorPage(
          error: _error!,
          onRetry: () async {
            if (!appModel.internetMonitor.value) {
              await Future.delayed(const Duration(milliseconds: 500));
              return;
            }
            await _preloadData();
          },
        ),
        settings: const RouteSettings(
          name: "App_ErrorPage",
        ),
      );
    }
    if (appModel.appUser.isAuthenticated()) {
      return appModel.bundleModule.routes.bundleListRoute();
    } else {
      return appModel.authModule.routes.authFormRoute();
    }
  }

  @override
  Widget build(BuildContext context) {
    var body = buildApp(context);
    if (_isInitialized) {
      body = MultiProvider(
        providers: buildProviders(context),
        child: body,
      );
    }
    return body;
  }

  List<SingleChildWidget> buildProviders(BuildContext context) {
    return [
      Provider<AppModel>(create: (context) => appModel),
      Provider<AppUser>(create: (context) => appModel.appUser),
      Provider<ThemeBuilder>(create: (context) => _themeBuilder),
      ...getModulesProviders(),
    ];
  }

  Widget buildApp(BuildContext context) {
    return MaterialApp(
      builder: BotToastInit(),
      key: _materialAppKey,
      debugShowCheckedModeBanner: false,
      title: 'Лаборатория Волгатеха',
      theme: _themeBuilder.buildThemeData(),
      themeMode: ThemeMode.light,
      home: !_isInitialized
          ? const SizedBox.shrink()
          : prepareStartPage(context).buildContent(context),
      navigatorKey: _navigationKey,
      locale: const Locale('ru', 'RU'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      scrollBehavior: CustomScrollBehavior(),
      supportedLocales: const [Locale('ru', 'RU')],
      navigatorObservers: [BotToastNavigatorObserver()],
    );
  }

  AppModel get appModel {
    _appModel ??= AppModel();
    return _appModel!;
  }

  List<SingleChildWidget> getModulesProviders() {
    var modulesProviders = <SingleChildWidget>[];
    for (var element in appModel.modules) {
      modulesProviders.addAll(element.getProviders() ?? []);
    }
    return modulesProviders;
  }

  Future<void> _preparePushNotificationManager() async {
    _addLoginEventSubscription();
    _addLogoutEventSubscription();
  }

  void _addLoginEventSubscription() {
    _subscriptions.add(
      appModel.eventBus.on<LoginEvent>().listen((LoginEvent event) {
        _addLogoutEventSubscription();
      }),
    );
  }

  void _addLogoutEventSubscription() {
    _subscriptions.add(
      appModel.eventBus.on<LogoutEvent>().listen(
        (LogoutEvent event) {
          navigator.pushAndRemoveUntil(
            appModel.authModule.routes.authFormRoute(),
            ModalRoute.withName('/'),
          );
          _unsubscribeAllEvents();
          _addLoginEventSubscription();
        },
      ),
    );
  }

  void _unsubscribeAllEvents() {
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        appModel.eventBus.fire(ApplicationResumeEvent(this));
        break;
      case AppLifecycleState.paused:
        appModel.eventBus.fire(ApplicationPausedEvent(this));
        break;
      default:
        break;
    }
  }

  void reloadApp() {
    _materialAppKey = GlobalKey();
    _isInitialized = false;
    setState(() {});
    _preloadData();
  }

  NavigatorState get navigator => _navigationKey.currentState!;
}
