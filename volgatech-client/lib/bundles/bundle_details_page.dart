import 'dart:io';

import 'package:flutter/material.dart';
import 'package:volgatech_client/bundles/create_edit_bundle_page.dart';
import 'package:volgatech_client/bundles/model/bundle_details_model.dart';
import 'package:volgatech_client/bundles/view/bundle_item_list_widget.dart';
import 'package:volgatech_client/bundles/view/bundle_table.dart';
import 'package:volgatech_client/core/page/base_page.dart';
import 'package:volgatech_client/core/page/details/base_item_details_rowed_page.dart';
import 'package:volgatech_client/core/theme/theme_builder.dart';
import 'package:volgatech_client/core/view/extension/simple_padding_extension.dart';
import 'package:volgatech_client/core/view/image/safe_network_image.dart';
import 'package:volgatech_client/core/view/widgets/base_alert_dialog.dart';
import 'package:volgatech_client/core/view/widgets/custom_back_button.dart';

class BundleDetailsPage extends BasePage {
  final int bundleId;

  const BundleDetailsPage({
    super.key,
    required this.bundleId,
  });

  @override
  _BundleDetailsPageState createState() => _BundleDetailsPageState();
}

class _BundleDetailsPageState extends BaseItemDetailsRowedPageState<
    BundleDetailsPage, BundleDetailsModel> {
  @override
  CrossAxisAlignment get itemsAlignment => CrossAxisAlignment.stretch;

  @override
  Widget decorateBody(BuildContext context, Widget body) {
    return Column(
      children: [
        _buildHeader(context).bottomPadding(15),
        Expanded(
          child: super.decorateBody(context, body),
        ),
      ],
    );
  }

  @override
  List<Widget> buildItemDetailsRows(BuildContext context) {
    return [
      if (model.item?.images.isNotEmpty ?? false)
        _buildImageList(context).bottomPadding(15),
      if (model.item?.description?.isNotEmpty ?? false)
        Text(
          model.item?.description ?? "",
          style: AppTextStyle.title,
        ).bottomPadding(15),
      if (model.item?.bundleItemInfos.isNotEmpty ?? false)
        BundleItemListWidget(
          bundleItems: model.item!.bundleItemInfos,
        ).bottomPadding(15),
      if (model.item!.bundles.isNotEmpty)
        BundleItemTable(
          bundles: model.item!.bundles,
          storages: storageModule.storages,
          canMove: appUser.canMoveToStorage,
          onStorageChanged: model.changeBundleItemStorage,
        ),
    ];
  }

  Widget _buildHeader(BuildContext context) {
    if (model.isLoading) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 300, vertical: 20),
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 50),
              Flexible(
                child: Text(
                  model.item?.name ?? "#${model.item?.bundleInfoId}",
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
                      _editBundle();
                    } else {
                      _deleteBundle();
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
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageList(BuildContext context) {
    return SizedBox(
      height: (MediaQuery.of(context).size.width - 800) / 16 * 9,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          var imageUrl = model.item?.images[index];
          return Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            child: SafeNetworkImage(
              file: File(imageUrl!),
              imageUrl: imageUrl,
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemCount: model.item?.images.length ?? 0,
      ),
    );
  }

  void _editBundle() async {
    showDialog(
      context: context,
      builder: (context) => CreateEditBundlePage(bundleInfo: model.item!),
    );
  }

  void _deleteBundle() async {
    var result = await BaseAlertDialog.showDialog(
      context: context,
      title: "Вы действительно хотите удалить компонент?",
      onPositiveButtonPressed: () => Navigator.of(context).pop(true),
      onNegativeButtonPressed: () => Navigator.of(context).pop(false),
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

  @override
  BundleDetailsModel? createModel() => BundleDetailsModel(
        appModel: appModel,
        bundleId: widget.bundleId,
      );

  @override
  EdgeInsets get itemDetailsPadding => const EdgeInsets.symmetric(
        horizontal: 300,
      );
}
