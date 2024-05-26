import 'package:volgatech_client/core/model/models/base_data_model.dart';
import 'package:flutter/foundation.dart';

/// Модель для загрузки, хранения и обработки единственной модели данных.
///
/// Для реализации:
/// * Реализовать загрузку следующей порции данных списка в [startLoadingData]. Обычно из API.
/// * При успешной загрузке вызвать [onItemLoaded]
/// * Если в процессе загрузки данных возникла ошибка, вызвать [onLoadingError]
///
abstract class ItemModel<T> extends BaseDataModel<T> {
  ItemModel({
    required super.appModel,
    T? item,
  }) : super(
          data: item,
        );

  /// Переопределить для загрузки данных модели.
  @protected
  Future<void> loadItemData();

  /// Доступ к данным загруженной сущности
  T? get item => data;

  /// Индикатор того, что данные о сущности уже загружены.
  bool get isItemLoaded => (data != null);

  /// Обновляет данные о сущности и сообщает об изменении модели.
  @protected
  Future<void> onItemLoaded(T loadedItem) async {
    isLoading = false;
    updateItem(loadedItem);
  }

  @override
  Future<void> loadData() async {
    if (isLoading) {
      return;
    }
    isLoading = true;
    await loadItemData();
  }

  void updateItem(T item) {
    update((_) {
      data = item;
    });
  }

  @override
  void clearData() {
    super.clearData();
    data = null;
  }
}
