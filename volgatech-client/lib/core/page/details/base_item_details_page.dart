import 'package:flutter/material.dart';
import 'package:volgatech_client/core/base_page_model_mixin.dart';
import 'package:volgatech_client/core/model/models/item_model.dart';
import 'package:volgatech_client/core/page/base_page.dart';
import 'package:volgatech_client/core/view/extension/simple_padding_extension.dart';

/// Базовые экран для "деталей" сущности. [TItem] - тип сущности.
///
/// Для работы экрана:
/// * переопределить [createModel]
/// * переопределить [buildItemDetails]
///
/// Для настройки, можно переопределить плейсхолдеры для загрузки и для незагруженной сущности:
/// * [buildItemLoadingPlaceholder]
/// * [buildEmptyItemPlaceholder]
///
abstract class BaseItemDetailsPageState<T extends BasePage,
        TItemModel extends ItemModel> extends BasePageState<T>
    with BasePageModelMixin<T, TItemModel> {
  TItemModel get model => pageModel!;

  /// Индикатор того, что есть ошибка
  bool get isError => model.hasError;

  /// Индикатор того, что нет данных
  bool get isItemDataEmpty => !model.isItemLoaded;

  /// Переопределите, чтобы вывести интерфейс для отображения данных сущности.
  Widget buildItemDetails(BuildContext context);

  @override
  void initState() {
    super.initState();
    reloadItem();
  }

  @override
  Widget buildBody(BuildContext context) {
    if (model.isLoading) {
      return buildLoadingIndicator(context);
    }
    return model.isItemLoaded
        ? buildItemDetails(context)
        : buildEmptyItemPlaceholder(context);
  }

  /// Плейсхолдер, который отображается, если данные сущности не были загружены
  Widget buildEmptyItemPlaceholder(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isError ? 'Ошибка загрузки' : isItemDataEmpty ? 'Нет данных' : '',
          style: Theme.of(context).textTheme.headlineMedium,
        ).bottomPadding(10),
        SizedBox(
          width: 300,
          child: ElevatedButton(
            onPressed: reloadItem,
            child: const Text('Попробовать снова'),
          ),
        ),
      ],
    );
  }

  /// Плейсхолдер, который отображается, во время загрузки данных сущности
  Widget buildItemLoadingPlaceholder(BuildContext context) {
    return buildLoadingIndicator(context);
  }

  /// Перезагрузить данные об элементе с сервера.
  Future<void> reloadItem() async {
    model.reloadData();
  }

  List<Widget> prepareItemDetailsRows(
      BuildContext context, List<Widget> itemDetailsRows) {
    return itemDetailsRows;
  }
}
