import 'package:flutter/material.dart';
import 'package:volgatech_client/bundles/model/bundle_item_details_model.dart';
import 'package:volgatech_client/bundles/model/entities/bundle_item_info.dart';
import 'package:volgatech_client/bundles/view/create_edit_bundle_item_alert.dart';
import 'package:volgatech_client/core/theme/theme_builder.dart';
import 'package:volgatech_client/core/view/widgets/base_alert_dialog.dart';
import 'package:volgatech_client/bundles/view/bundle_item_table.dart';
import 'package:volgatech_client/core/page/base_page.dart';
import 'package:volgatech_client/core/page/details/base_item_details_rowed_page.dart';
import 'package:volgatech_client/core/view/extension/simple_padding_extension.dart';
import 'package:volgatech_client/core/view/widgets/custom_back_button.dart';

class BundleItemDetailsPage extends BasePage {
  final int bundleItemInfoId;

  const BundleItemDetailsPage({
    super.key,
    required this.bundleItemInfoId,
  });

  @override
  _BundleItemDetailsPageState createState() => _BundleItemDetailsPageState();
}

class _BundleItemDetailsPageState extends BaseItemDetailsRowedPageState<
    BundleItemDetailsPage, BundleItemDetailsModel> {
  @override
  CrossAxisAlignment get itemsAlignment => CrossAxisAlignment.stretch;

  @override
  List<Widget> buildItemDetailsRows(BuildContext context) {
    return [
      _buildHeader(context).bottomPadding(20),
      if (model.item!.description?.isNotEmpty ?? false)
        Text(
          model.item!.description!,
          style: AppTextStyle.title,
        ).bottomPadding(20),
      BundleItemTable(
        bundleItems: model.item!.bundleItems,
        projects: model.projects,
        storages: model.storages,
        canEdit: appUser.canAddEdit,
        canMove: appUser.canMoveToStorage,
        onTypeSelected: model.changeBundleItemFunctional,
        onStorageChanged: model.changeBundleItemStorage,
        onProjectSelected: model.changeBundleItemProject,
      ),
    ];
  }

  Widget _buildHeader(BuildContext context) {
    if (model.isLoading) return const SizedBox();
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 50),
            Flexible(
              child: Text(
                model.item!.name ??
                    "Компонент #${model.item!.bundleItemInfoId}",
                style: Theme.of(context)
                    .textTheme
                    .displaySmall
                    ?.copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 50),
          ],
        ),
        Row(
          children: [
            const CustomBackButton(),
            const Spacer(),
            if (appUser.canAddEdit)
              PopupMenuButton(
                onSelected: (value) async {
                  if (value == 0) {
                    var result = await showDialog(
                      context: context,
                      builder: (context) => CreateEditBundleItemAlert(
                        bundleItem: model.item,
                      ),
                    );

                    if (result is BundleItemInfo) {
                      await model.editBundleItem(result);
                      showMessage(message: "Компонент изменен");
                    }
                  } else {
                    var result = await BaseAlertDialog.showDialog(
                      context: context,
                      title: "Вы действительно хотите удалить компонент?",
                      onPositiveButtonPressed: () =>
                          Navigator.of(context).pop(true),
                      onNegativeButtonPressed: () =>
                          Navigator.of(context).pop(false),
                    );

                    if (result == true) {
                      showLoadingIndicator();
                      var success = await model.deleteBundleItem();
                      hideLoadingIndicator();
                      if (success) {
                        Navigator.of(context).pop();
                        showMessage(message: "Компонент удален");
                      }
                    }
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 0,
                    child: Row(
                      children: [
                        const Icon(Icons.edit).rightPadding(6),
                        const Text("Редактировать"),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: [
                        const Icon(Icons.delete).rightPadding(6),
                        const Text("Удалить"),
                      ],
                    ),
                  ),
                ],
              )
          ],
        ),
      ],
    );
  }

  @override
  BundleItemDetailsModel? createModel() => BundleItemDetailsModel(
        appModel: appModel,
        bundleItemInfoId: widget.bundleItemInfoId,
      );

  @override
  EdgeInsets get itemDetailsPadding => const EdgeInsets.symmetric(
        horizontal: 200,
        vertical: 20,
      );
}
