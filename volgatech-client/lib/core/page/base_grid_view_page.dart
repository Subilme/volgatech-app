import 'package:flutter/material.dart';
import 'package:volgatech_client/core/model/models/list_model.dart';
import 'package:volgatech_client/core/theme/theme_builder.dart';

import 'base_infinity_scroll_page.dart';
import 'base_page.dart';

/// Универсальный класс для экранов в формате "Грида" (таблицы) [GridView].
///
/// Для работы экрана необходимо:
/// * обеспечить [ListModel]: переопределить [createModel]
/// * обеспечить виджет для ячейки списка: переопределить [buildListItemImpl]
/// * опционально. Добавить обработку нажатия на ячейку списка: переопределить [onListItemTap]
abstract class BaseGridViewPageState<T extends BasePage, DPT extends ListModel>
    extends BaseInfinityScrollPageState<T, DPT> {
  final UniqueKey gridKey = UniqueKey();

  @override
  Widget buildBodyContent(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        reloadData();
      },
      color: AppColors.updatingIndicatorColor,
      child: GridView.builder(
        key: gridKey,
        controller: controller,
        itemCount: fullItemCount,
        itemBuilder: (context, index) {
          return buildListItem(context, index);
        },
        gridDelegate: createGridDelegate(context),
        padding: listPadding(),
      ),
    );
  }

  @protected
  int getCrossAxisCount(BuildContext context) {
    return 2;
  }

  @protected
  SliverGridDelegate createGridDelegate(BuildContext context) {
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: getCrossAxisCount(context),
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      childAspectRatio: childAspectRatio,
    );
  }

  double get mainAxisSpacing => 10;

  double get crossAxisSpacing => 10;

  double get childAspectRatio => 1.0;
}
