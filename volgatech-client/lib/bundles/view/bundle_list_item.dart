import 'dart:io';

import 'package:flutter/material.dart';
import 'package:volgatech_client/bundles/model/entities/bundle_info.dart';
import 'package:volgatech_client/core/model/extension/iterable_extension.dart';
import 'package:volgatech_client/core/theme/theme_builder.dart';
import 'package:volgatech_client/core/view/extension/simple_padding_extension.dart';
import 'package:volgatech_client/core/view/image/safe_network_image.dart';
import 'package:volgatech_client/core/view/widgets/card_widget.dart';

class BundleListItem extends StatelessWidget {
  final BundleInfo bundleInfo;

  const BundleListItem({
    super.key,
    required this.bundleInfo,
  });

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            height: 100,
            width: 100,
            margin: const EdgeInsets.only(right: 12),
            child: SafeNetworkImage(
              file: bundleInfo.images.isEmpty
                  ? null
                  : File(bundleInfo.images.first),
              imageUrl: bundleInfo.images.safeFirst,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  bundleInfo.name ?? "Элемент ${bundleInfo.bundleInfoId}",
                  style: AppTextStyle.body1,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ).bottomPadding(8),
                Text(
                  "Всего: ${bundleInfo.count} шт.",
                  style: AppTextStyle.body1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
