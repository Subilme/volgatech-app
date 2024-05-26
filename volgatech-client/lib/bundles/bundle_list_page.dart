import 'package:flutter/material.dart';
import 'package:volgatech_client/bundles/create_edit_bundle_page.dart';
import 'package:volgatech_client/bundles/model/bundle_list_model.dart';
import 'package:volgatech_client/bundles/model/entities/bundle_info.dart';
import 'package:volgatech_client/bundles/view/bundle_list_item.dart';
import 'package:volgatech_client/category/create_edit_category_page.dart';
import 'package:volgatech_client/category/model/entities/category.dart';
import 'package:volgatech_client/category/view/category_list_item.dart';
import 'package:volgatech_client/core/page/base_list_view_page.dart';
import 'package:volgatech_client/core/page/base_page.dart';
import 'package:volgatech_client/core/view/widgets/app_search_bar.dart';
import 'package:volgatech_client/core/view/widgets/base_alert_dialog.dart';

class BundleListPage extends BasePage {
  const BundleListPage({super.key});

  @override
  _BundleListPageState createState() => _BundleListPageState();
}

class _BundleListPageState
    extends BaseListViewPageState<BundleListPage, BundleListModel> {
  @override
  bool get shouldProcessItemTap => !model.groupItemsByCategory;

  @override
  Widget decorateBody(BuildContext context, Widget body) {
    return Column(
      children: [
        if (model.isAllLoaded && !model.hasError) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 400, vertical: 20),
            child: Column(
              children: [
                if (appUser.canAddEdit)
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _addCategory,
                          child: const Text("Создать новую категорию"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _addBundle,
                          child: const Text("Создать новый набор"),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Flexible(
                      flex: 5,
                      child: AppSearchBar(
                        initString: model.searchString,
                        onChanged: _onSearch,
                        onSubmitted: _onSearch,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text("По категориям"),
                        Checkbox(
                          value: model.groupItemsByCategory,
                          onChanged: (value) => setState(() {
                            model.groupItemsByCategory = value!;
                            model.reloadData();
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
        Expanded(child: super.decorateBody(context, body)),
      ],
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    if (model.isLoading) {
      return buildLoadingIndicator(context);
    }

    if (model.hasError && model.items.isEmpty) {
      return buildBaseError(
        onPressedButton: () {
          reloadData();
        },
      );
    }
    if (model.isAllLoaded &&
        (model.items.isEmpty && model.categories.isEmpty) &&
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

  @override
  Widget buildListView(BuildContext context) {
    if (!model.groupItemsByCategory) {
      return super.buildListView(context);
    }

    return ListView.separated(
      key: listKey,
      shrinkWrap: shrinkWrapList,
      physics: const AlwaysScrollableScrollPhysics(),
      controller: controller,
      reverse: shouldReverseList,
      itemCount: model.categories.length + (hasListHeader ? 1 : 0),
      itemBuilder: buildListItem,
      separatorBuilder: (context, index) => buildSeparator(
        context: context,
        index: index,
        shouldBuild:
            (shouldDisplaySeparator && index < model.categories.length - 1),
      ),
      padding: listPadding(),
    );
  }

  @override
  Widget buildListItem(BuildContext context, int index) {
    var listItem = model.groupItemsByCategory
        ? CategoryListItem(
            category: model.categories[index],
            onEdit: appUser.canAddEdit ? _editCategory : null,
            onDelete: appUser.canAddEdit ? _deleteCategory : null,
          )
        : BundleListItem(bundleInfo: model.items[index]);
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
  Widget buildListItemImpl(BuildContext context, int index) => const SizedBox();

  @override
  Widget buildSeparator({
    BuildContext? context,
    int? index,
    bool shouldBuild = true,
  }) =>
      const SizedBox(height: 10);

  @override
  void onListItemTap(BuildContext context, index) {
    Navigator.of(context).push(
      appModel.bundleModule.routes.bundleDetailsRoute(
        bundleId: model.items[index].bundleInfoId,
      ),
    );
  }

  @override
  BundleListModel? createModel() => BundleListModel(appModel: appModel);

  void _addCategory() async {
    var result = await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) => const CreateEditCategoryFormPage(),
    );

    if (result is Category) {
      showMessage(message: "Категория добавлена");
      if (model.groupItemsByCategory) {
        model.reloadData();
      }
    }
  }

  void _editCategory(Category category) async {
    var result = await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) => CreateEditCategoryFormPage(category: category),
    );

    if (result is Category) {
      showMessage(message: "Категория изменена");
    }
  }

  void _deleteCategory(Category category) async {
    var result = await BaseAlertDialog.showDialog(
      context: context,
      title: "Вы действительно хотите удалить категорию?",
      onPositiveButtonPressed: () => Navigator.of(context).pop(true),
      onNegativeButtonPressed: () => Navigator.of(context).pop(false),
    );

    if (result == true) {
      showLoadingIndicator();
      var success = await model.deleteCategory(category);
      hideLoadingIndicator();
      if (success) {
        showMessage(message: "Категория удалена");
      }
    }
  }

  void _addBundle() async {
    var result = await showDialog(
      context: context,
      builder: (context) => const CreateEditBundlePage(),
    );

    if (result is BundleInfo) {
      showMessage(message: "Набор добавлен");
    }
  }

  void _onSearch(String searchString) async {
    if (model.searchString.trim() == searchString.trim()) {
      return;
    }

    model.searchString = searchString;
    model.reloadData();
  }
}
