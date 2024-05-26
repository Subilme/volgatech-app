import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:volgatech_client/core/theme/theme_builder.dart';
import 'package:volgatech_client/core/view/image/safe_network_image.dart';

class AvatarImage extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final File? imageFile;
  final bool isShadowNeeded;
  final String placeholder;

  const AvatarImage(
    this.imageUrl, {
    super.key,
    this.size = double.infinity,
    this.isShadowNeeded = false,
    this.placeholder = "assets/user_placeholder.png",
  }) : imageFile = null;

  const AvatarImage.file(
    this.imageFile, {
    super.key,
    this.size = double.infinity,
    this.isShadowNeeded = false,
    this.placeholder = "assets/user_placeholder.png",
  })  : imageUrl = null,
        assert(imageFile != null);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Container(
        decoration: isShadowNeeded
            ? BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 2.0),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    blurRadius: 1.0,
                    offset: Offset(0.0, 0.0),
                    spreadRadius: 4.0,
                  )
                ],
              )
            : null,
        child: ClipOval(
          child: image(context),
        ),
      ),
    );
  }

  Widget image(BuildContext context) {
    if (imageFile != null) {
      return Image.file(
        imageFile!,
        fit: BoxFit.cover,
      );
    }

    return SafeNetworkImage(
      placeholder: placeholder,
      imageUrl: imageUrl,
    );
  }
}
