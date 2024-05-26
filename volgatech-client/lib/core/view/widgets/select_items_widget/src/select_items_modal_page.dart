import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:volgatech_client/core/model/models/list_model.dart';
import 'package:volgatech_client/core/page/base_list_view_page.dart';
import 'package:volgatech_client/core/page/base_page.dart';
import 'package:volgatech_client/core/theme/theme_builder.dart';
import 'package:volgatech_client/core/model/entities/selectable.dart';
import 'package:volgatech_client/core/view/widgets/app_search_bar.dart';
import 'package:volgatech_client/core/view/widgets/select_items_widget/src/default_list_item.dart';

class SelectItemsModalPage<TFieldValueType extends ISelectable>
    extends BasePage {
  final Widget Function(BuildContext, TFieldValueType?, bool)? itemBuilder;
  final Widget Function(BuildContext)? separatorBuilder;
  final ListModel<TFieldValueType>? model;
  final List<TFieldValueType>? selectedItems;
  final ScrollController? controller;
  final String? emptyText;
  final bool single;

  const SelectItemsModalPage({
    super.key,
    super.title,
    this.itemBuilder,
    this.selectedItems,
    this.separatorBuilder,
    this.model,
    this.single = false,
    this.controller,
    this.emptyText,
  });

  @override
  _SelectModalPageState<TFieldValueType> createState() =>
      _SelectModalPageState<TFieldValueType>();
}

class _SelectModalPageState<TFieldValueType extends ISelectable>
    extends BaseListViewPageState<SelectItemsModalPage,
        ListModel<TFieldValueType>> {
  late List<TFieldValueType> selectedItems;

  @override
  void initState() {
    selectedItems = widget.selectedItems as List<TFieldValueType>? ?? [];
    super.initState();
  }

  @override
  bool get shouldBuildNavigatorAppBar => false;

  @override
  String emptyListText() => widget.emptyText ?? super.emptyListText();

  @override
  Widget decorateBody(BuildContext context, Widget body) {
    return Column(
      children: <Widget>[
        if (widget.title?.isNotEmpty ?? false)
          Container(
            color: AppColors.secondaryColor,
            padding: const EdgeInsets.all(16),
            child: _buildHeaderWidget(context: context),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(400, 20, 400, 0),
          child: AppSearchBar(
            initString: (model as SearchFilter).searchString,
            onChanged: _onSearch,
            onSubmitted: _onSearch,
          ),
        ),
        Expanded(
          child: Container(
            color: AppColors.white,
            child: super.decorateBody(context, body),
          ),
        ),
      ],
    );
  }

  @override
  Widget buildListItemImpl(BuildContext context, int index) {
    var item = model.items[index];
    return widget.itemBuilder?.call(
          context,
          item,
          selectedItems.any((e) => e.id == item.id),
        ) ??
        DefaultModalSelectListItem(
          item: item,
          selected: selectedItems.any((e) => e.id == item.id),
        );
  }

  @override
  void onListItemTap(BuildContext context, index) {
    var item = model.items[index];
    if (widget.single) {
      Navigator.of(context).pop([item]);
      return;
    }
    setState(() {
      if (selectedItems.contains(item)) {
        selectedItems.remove(item);
      } else {
        selectedItems.add(item);
      }
    });
  }

  @override
  Widget buildSeparator({
    BuildContext? context,
    int? index,
    bool shouldBuild = true,
  }) {
    return !shouldBuild
        ? const SizedBox()
        : const Divider(
            indent: 12,
            endIndent: 12,
          );
  }

  @override
  ListModel<TFieldValueType> createModel() =>
      widget.model as ListModel<TFieldValueType>;

  void _onSearch(String searchString) async {
    if ((model as SearchFilter).searchString.trim() == searchString.trim()) {
      return;
    }

    (model as SearchFilter).searchString = searchString;
    model.reloadData();
  }

  Widget _buildHeaderWidget({
    required BuildContext context,
  }) {
    return Row(
      children: <Widget>[
        const SizedBox(width: 28),
        Expanded(
          child: Text(
            widget.title ?? '',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: AppColors.white),
          ),
        ),
        const SizedBox(width: 4),
        CupertinoButton(
          minSize: 24,
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(selectedItems),
          child: const Icon(
            Icons.close,
            color: AppColors.white,
            size: 24,
          ),
        ),
      ],
    );
  }
}
