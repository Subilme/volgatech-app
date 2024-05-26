import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volgatech_client/category/model/entities/category.dart';
import 'package:volgatech_client/core/model/app_model.dart';
import 'package:volgatech_client/core/model/extension/iterable_extension.dart';
import 'package:volgatech_client/core/theme/theme_builder.dart';
import 'package:volgatech_client/core/view/extension/simple_padding_extension.dart';
import 'package:volgatech_client/core/view/image/safe_network_image.dart';
import 'package:volgatech_client/core/view/widgets/card_widget.dart';
import 'package:volgatech_client/core/view/widgets/expanded_widget.dart';

class CategoryListItem extends StatelessWidget {
  final Category category;
  final Function(Category)? onEdit;
  final Function(Category)? onDelete;

  const CategoryListItem({
    super.key,
    required this.category,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ExpandedWidget(
      titleChild: _buildTitle(context),
      child: _buildItemsList(context),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              category.name,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: AppColors.white),
            ),
          ),
          Row(
            children: [
              if (onEdit != null)
                InkWell(
                  onTap: () => onEdit?.call(category),
                  child: const Icon(
                    Icons.edit,
                    color: AppColors.white,
                  ),
                ).rightPadding(10),
              if (onDelete != null)
                InkWell(
                  onTap: () => onDelete?.call(category),
                  child: const Icon(
                    Icons.delete,
                    color: AppColors.white,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList(BuildContext context) {
    if (category.bundleInfos.isEmpty) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: const Text("Нет наборов"),
      );
    }

    final appModel = context.read<AppModel>();
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        var item = category.bundleInfos[index];
        return GestureDetector(
          onTap: () => Navigator.of(context).push(
            appModel.bundleModule.routes.bundleDetailsRoute(
              bundleId: item.bundleInfoId,
            ),
          ),
          child: CardWidget(
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  margin: const EdgeInsets.only(right: 12),
                  child: SafeNetworkImage(
                    file: item.images.isEmpty ? null : File(item.images.first),
                    imageUrl: item.images.safeFirst,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        item.name ?? "Элемент ${item.bundleInfoId}",
                        style: AppTextStyle.body1,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ).bottomPadding(8),
                      Text(
                        "Всего: ${item.count} шт.",
                        style: AppTextStyle.body1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemCount: category.bundleInfos.length,
    );
  }
}
