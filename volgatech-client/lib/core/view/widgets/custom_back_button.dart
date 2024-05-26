import 'package:flutter/material.dart';
import 'package:volgatech_client/core/model/helpers/assets_catalog.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    super.key,
    this.color,
    this.onPressed,
  });

  final Color? color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    return IconButton(
      icon: Image.asset(AssetsCatalog.icArrowBack),
      color: color,
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      splashRadius: 24,
      onPressed: () {
        if (onPressed != null) {
          onPressed!();
        } else {
          Navigator.maybePop(context);
        }
      },
    );
  }
}
