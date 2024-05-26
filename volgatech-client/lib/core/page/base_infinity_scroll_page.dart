import 'package:flutter/material.dart';
import 'package:volgatech_client/core/base_page_model_mixin.dart';
import 'package:volgatech_client/core/model/models/list_model.dart';
import 'package:volgatech_client/core/page/base_page.dart';

/// Универсальный класс для любых списочных экранов в формате:
/// * список [ListView]
/// * грид (таблица) [GridView]
/// * горизонтальный список [PageView]
/// * и любых других.
///
/// Основная особенность: обеспечивает механику "infinity scroll",
/// которая позволяет листать список и постоянно подгружать с сервера новые
/// порции данных. Пока список данных на сервере не закончится.
///
/// Для работы экрана необходимо:
/// * обеспечить [ListModel]: переопределить [createModel]
/// * обеспечить виджет для ячейки списка: переопределить [buildListItemImpl]
/// * опционально. Добавить обработку нажатия на ячейку списка: переопределить [onListItemTap]
abstract class BaseInfinityScrollPageState<T extends BasePage,
        TListModel extends ListModel> extends BasePageState<T>
    with BasePageModelMixin<T, TListModel> {
  TListModel get model => pageModel!;
  ScrollController? controller;

  /// Включить, если нужно навесить [Scrollbar] на виджет-список.
  bool shouldDecorateScrollbar = false;

  /// Отключить, если ну нужно обрабатывать нажатия на ячейки.
  bool shouldProcessItemTap = true;

  /// Отключить, если не нужно загружать данные из [model] при старте экрана.
  bool shouldAutoLoadListData = true;

  /// Переопределить для построения содержимого страницы -  конкретного вида списка
  Widget buildBodyContent(BuildContext context);

  /// Переопределить для построения ячейки в списке
  Widget buildListItemImpl(BuildContext context, int index);

  /// Вернуть false, если не нужно показывать плейсхолдер, когда загружен пустой список
  bool get shouldBuildEmptyListPlaceholder => true;

  /// Переопределить, чтобы добавить обработку нажатия на элемент списка
  void onListItemTap(BuildContext context, index);

  @protected
  Widget buildListItem(BuildContext context, int index) {
    if (index >= model.items.length) {
      return const SizedBox.shrink();
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      tryPreloadNextItems(index);
    });
    var listItem = buildListItemImpl(context, index);
    if (shouldProcessItemTap) {
      listItem = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onListItemTap(context, index),
        child: listItem,
      );
    }
    return listItem;
  }

  @override
  void initState() {
    super.initState();
    _prepareModel();
  }

  @protected
  void tryPreloadNextItems(int renderedItemIndex) {
    var isListEnd =
        (renderedItemIndex >= (model.items.length - infinityScrollOffset));
    if (isListEnd) {
      model.loadData();
    }
  }

  Future<void> reloadData({
    bool showLoading = true,
  }) async {
    if (showLoading) {
      showLoadingIndicator();
    }
    await model.reloadData();
  }

  @override
  Widget buildBody(BuildContext context) {
    if (model.hasError && model.items.isEmpty) {
      return buildBaseError(
        onPressedButton: () {
          reloadData();
        },
      );
    }
    if (model.isAllLoaded &&
        model.items.isEmpty &&
        shouldBuildEmptyListPlaceholder) {
      return buildEmptyListPlaceholder(context);
    }
    var bodyContent = buildBodyContent(context);
    if (shouldDecorateScrollbar) {
      bodyContent = Scrollbar(
        child: bodyContent,
      );
    }

    return bodyContent;
  }

  Widget buildEmptyListPlaceholder(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          emptyListText(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }

  @protected
  EdgeInsetsGeometry listPadding() => const EdgeInsets.symmetric(
        horizontal: 400,
        vertical: 30,
      );

  @protected
  String emptyListText() {
    return 'Список пуст';
  }

  void _prepareModel() {
    if (model.items.isEmpty && shouldAutoLoadListData) {
      reloadData();
    }
  }

  @override
  void onModelUpdated() {
    hideLoadingIndicator();
    if ((model.items.isEmpty) && !model.isAllLoaded) {
      model.loadData();
    }
  }

  int get infinityScrollOffset {
    return 6;
  }

  int get fullItemCount {
    return totalItemCount + (!model.isAllLoaded ? 1 : 0);
  }

  int get totalItemCount {
    return model.items.length;
  }
}
