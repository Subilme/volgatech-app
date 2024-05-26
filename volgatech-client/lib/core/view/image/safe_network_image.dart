import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:volgatech_client/core/model/helpers/assets_catalog.dart';
import 'package:volgatech_client/core/theme/theme_builder.dart';

class SafeNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final File? file;
  final String placeholder;

  final BoxFit fit;
  final BoxFit placeholderFit;
  final Color placeholderBackgroundColor;

  const SafeNetworkImage({
    super.key,
    this.imageUrl,
    this.file,
    this.placeholderBackgroundColor = AppColors.skyBlue,
    this.placeholder = AssetsCatalog.placeholder,
    this.fit = BoxFit.cover,
    this.placeholderFit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    if ((imageUrl?.isEmpty ?? true) && file == null) {
      return buildPlaceholder();
    }

    if (file != null) {
      return ExtendedImage.file(
        file!,
        fit: fit,
        enableLoadState: true,
        loadStateChanged: (state) => onLoadStateChanged(state),
      );
    }
    return ExtendedImage.network(
      imageUrl ?? '',
      fit: fit,
      enableLoadState: true,
      cache: true,
      loadStateChanged: (state) => onLoadStateChanged(state),
    );
  }

  Widget? onLoadStateChanged(ExtendedImageState state) {
    if (state.extendedImageLoadState == LoadState.completed) {
      return null;
    }
    return buildPlaceholder();
  }

  Widget buildPlaceholder() {
    return Container(
      color: placeholderBackgroundColor,
      child: Image.asset(
        placeholder,
        fit: placeholderFit,
      ),
    );
  }
}
