import 'package:flutter/material.dart';
import 'package:volgatech_client/core/model/models/list_model.dart';
import 'package:volgatech_client/core/page/base_infinity_scroll_page.dart';
import 'package:volgatech_client/core/page/base_page.dart';
import 'package:volgatech_client/core/theme/theme_builder.dart';

/// Универсальный класс для экранов в формате "Списка" [ListView].
///
/// Для работы экрана необходимо:
/// * обеспечить [ListModel]: переопределить [createModel]
/// * обеспечить виджет для ячейки списка: переопределить [buildListItemImpl]
/// * опционально. Добавить обработку нажатия на ячейку списка: переопределить [onListItemTap]
abstract class BaseListViewPageState<T extends BasePage,
        TListModel extends ListModel>
    extends BaseInfinityScrollPageState<T, TListModel> {
  final UniqueKey listKey = UniqueKey();

  /// Выключить, если нужно отключить сепараторы (разделители) между ячейками списка.
  bool shouldDisplaySeparator = true;

  /// Включить, для отображения списка в обратном порядке
  bool shouldReverseList = false;

  /// Включить, если нужна "шапка" списка: блок, который будет
  /// отображаться всегда сверху списка. Переопределите [buildListHeaderImpl].
  bool hasListHeader = false;
  bool shrinkWrapList = false;

  /// Переопределить, чтобы задать "шапку" списка.
  Widget? buildListHeaderImpl(BuildContext context) => null;

  @override
  Widget buildBodyContent(BuildContext context) {
    var listView = buildListView(context);
    if (model.items.isEmpty || shouldReverseList) {
      return listView;
    }

    return RefreshIndicator(
      onRefresh: onListRefresh,
      color: AppColors.updatingIndicatorColor,
      child: listView,
    );
  }

  @protected
  Widget buildListView(BuildContext context) {
    return ListView.separated(
      key: listKey,
      shrinkWrap: shrinkWrapList,
      physics: const AlwaysScrollableScrollPhysics(),
      controller: controller,
      reverse: shouldReverseList,
      itemCount: fullItemCount,
      itemBuilder: (context, index) {
        if (hasListHeader) {
          if (index == 0) {
            return buildListHeader(context);
          }
          --index;
        }
        return buildListItem(context, index);
      },
      separatorBuilder: (context, index) {
        if (hasListHeader) {
          if (index == 0) {
            return buildSeparator(shouldBuild: false);
          }
          --index;
        }
        return buildSeparator(
          context: context,
          index: index,
          shouldBuild: (shouldDisplaySeparator && index < totalItemCount - 1),
        );
      },
      padding: listPadding(),
    );
  }

  @protected
  Widget buildSeparator({
    BuildContext? context,
    int? index,
    bool shouldBuild = true,
  }) {
    if (!shouldBuild) {
      return const SizedBox.shrink();
    }
    var insets = separatorInsets();
    return Divider(
      thickness: 1,
      height: insets.top + insets.bottom,
      color: shouldBuild ? AppColors.lightBlack : Colors.transparent,
      indent: insets.left,
      endIndent: insets.right,
    );
  }

  @protected
  EdgeInsets separatorInsets() =>
      const EdgeInsets.symmetric(horizontal: 0, vertical: 0);

  Future<void> onListRefresh() async {
    if (!model.isLoading) {
      await reloadData(
        showLoading: false,
      );
    }
  }

  @override
  int get fullItemCount {
    var itemCount = super.fullItemCount;
    if (hasListHeader) {
      ++itemCount;
    }
    return itemCount;
  }

  @protected
  Widget buildListHeader(BuildContext context) {
    var header = buildListHeaderImpl(context);
    return header ?? const SizedBox.shrink();
  }

  @override
  bool get shouldBuildEmptyListPlaceholder => !hasListHeader;
}
