import 'package:flutter/widgets.dart';
import 'package:volgatech_client/core/model/models/item_model.dart';
import 'package:volgatech_client/core/page/base_page.dart';
import 'package:volgatech_client/core/page/details/base_item_details_page.dart';

/// Базовые экран для "деталей" сущности. [TItem] - тип сущности.
/// По-умолчанию экран работает в режиме "строк".
///
/// Когда выводятся детали сущности "построчно" и есть вертикальный скролл экрана.
/// Большая часть экранов деталей сущностей так и выглядят. Например, экран профиля:
/// * первая строка с аватаркой
/// * вторая строка с ФИО
/// * третья строка с рейтингом
///
/// Для работы экрана:
/// * переопределить [loadItemImpl]
/// * переопределить [buildItemDetailsRows]
///
abstract class BaseItemDetailsRowedPageState<T extends BasePage,
        TItemModel extends ItemModel>
    extends BaseItemDetailsPageState<T, TItemModel> {
  CrossAxisAlignment get itemsAlignment => CrossAxisAlignment.stretch;

  /// Переопределите, чтобы собрать список строк с данными о сущности.
  List<Widget> buildItemDetailsRows(BuildContext context);

  /// Выводит данные строк в формате сущности
  @override
  Widget buildItemDetails(BuildContext context) {
    return buildItemDetailsRowsList(context);
  }

  /// Собирает список "строк" для сущности и выводит их в виде вертикального списка.
  /// Если экран работает в режиме "строк"
  Widget buildItemDetailsRowsList(BuildContext context) {
    return SingleChildScrollView(
      padding: itemDetailsPadding,
      child: Column(
        crossAxisAlignment: itemsAlignment,
        children: prepareItemDetailsRows(
          context,
          buildItemDetailsRows(context),
        ),
      ),
    );
  }

  EdgeInsets get itemDetailsPadding => EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom,
      );
}
