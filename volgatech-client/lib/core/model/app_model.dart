import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:volgatech_client/auth/module/auth_module.dart';
import 'package:volgatech_client/bundles/module/bundle_module.dart';
import 'package:volgatech_client/category/module/category_module.dart';
import 'package:volgatech_client/core/model/api/app_api.dart';
import 'package:volgatech_client/core/model/app/internet_monitor.dart';
import 'package:volgatech_client/core/model/app/module/base_app_module.dart';
import 'package:volgatech_client/core/model/app_component.dart';
import 'package:volgatech_client/core/page/mixin/module_fast_access_mixin.dart';
import 'package:provider/provider.dart';
import 'package:volgatech_client/profile/module/profile_module.dart';
import 'package:volgatech_client/projects/module/project_module.dart';
import 'package:volgatech_client/report/module/report_module.dart';
import 'package:volgatech_client/responsible/module/responsible_module.dart';
import 'package:volgatech_client/storage/module/storage_module.dart';

import 'app/key_value_storage.dart';
import 'app_user.dart';

/// Главный класс Модели приложения.
/// Содержит в себе все необходимые данные модели для работы приложения.
class AppModel with ModuleFastAccessMixin, AppComponent {
  /// Шина для асинхронного обмена данными и/или событиями
  /// между разными модулями и компонентами приложения
  final EventBus eventBus = EventBus();
  AppUser? _appUser;
  KeyValueStorage? _keyValueStorage;
  AppApi? _appApi;
  late StreamSubscription _logoutSubscription;
  late StreamSubscription _loginSubscription;

  InternetMonitor? _internetMonitor;

  /// Модули приложения
  late final List<BaseAppModule> _modules = [
    AuthModule(appModel: this),
    BundleModule(appModel: this),
    ProfileModule(appModel: this),
    CategoryModule(appModel: this),
    ProjectModule(appModel: this),
    ReportModule(appModel: this),
    ResponsibleModule(appModel: this),
    StorageModule(appModel: this),
  ];

  List<BaseAppModule> get modules => _modules;

  AppModel();

  static AppModel of(BuildContext context) => context.read<AppModel>();

  @override
  List<AppComponent> prepareComponents() {
    return [
      keyValueStorage,
      internetMonitor,
      ..._modules,
    ];
  }

  void dispose() {
    _unsubscribe();
    _internetMonitor?.dispose();
  }

  AppUser get appUser {
    _appUser ??= AppUser(
      appModel: this,
    );
    return _appUser!;
  }

  KeyValueStorage get keyValueStorage {
    _keyValueStorage ??= KeyValueStorage();
    return _keyValueStorage!;
  }

  AppApi get appApi {
    _appApi ??= AppApi(appModel: this);
    return _appApi!;
  }

  InternetMonitor get internetMonitor {
    _internetMonitor ??= InternetMonitor(eventBus: eventBus);
    return _internetMonitor!;
  }

  void _unsubscribe() {
    _logoutSubscription.cancel();
    _loginSubscription.cancel();
  }

  @override
  T getModule<T extends BaseAppModule>() =>
      modules.firstWhere((module) => module is T) as T;
}
