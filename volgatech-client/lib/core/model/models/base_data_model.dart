import 'dart:async';

import 'package:volgatech_client/core/model/events/application_events.dart';
import 'package:volgatech_client/core/model/models/base_model.dart';


typedef UpdateViewModelFunction<T> = Function(BaseDataModel<T> model);

/// Базовая модель для загрузки, хранения и обработки любых данных.
/// Для реализации:
/// * Реализовать загрузку данных в [loadData]. Обычно из API.
///
abstract class BaseDataModel<T> extends BaseModel {
  T? data;
  bool isLoading = false;

  /// Включите, если нужно перезагрузить экран после "разворачивания" приложения,
  /// когда оно было свернуто.
  bool shouldReloadAfterAppResuming = false;

  /// Включите, если нужно перезагрузить экран после подключения к интернету
  bool shouldReloadAfterNetworkRestored = false;

  /// Включите, если нужно перезагрузить экран после смены интернет подключения
  bool shouldReloadAfterNetworkSwitch = false;

  BaseDataModel({
    required super.appModel,
    this.data,
  });

  @override
  void subscribeToEvents() {
    super.subscribeToEvents();
    if (shouldReloadAfterAppResuming) {
      addSubscription(eventBus
          .on<ApplicationResumeEvent>()
          .listen((event) => reloadData()));
    }
    if (shouldReloadAfterNetworkRestored) {
      addSubscription(eventBus
          .on<NetworkConnectionRestored>()
          .listen((event) => reloadData()));
    }
    if (shouldReloadAfterNetworkSwitch) {
      addSubscription(eventBus
          .on<NetworkConnectionSwitch>()
          .listen((event) => reloadData()));
    }
  }

  /// Переопределить для загрузки данных модели
  Future<void> loadData();

  Future<void> reloadData({
    bool soft = false,
  }) async {
    reset(
      soft: soft,
    );
    await loadData();
  }

  @override
  void dispose() {
    clearData();
    super.dispose();
  }

  void update(UpdateViewModelFunction<T> changeFunction) {
    changeFunction(this);
    clearCache();
    if (!isDisposed) {
      notifyModelListeners();
    }
  }

  void reset({
    bool soft = false,
  }) {
    isLoading = false;
    if (!soft) {
      clearData();
    }
  }

  void clearData() {
    clearError();
    clearCache();
  }

  void clearCache() {
    /// Add impl if need
  }

  void onLoadingError(String error) {
    isLoading = false;
    addError(error);
  }
}
