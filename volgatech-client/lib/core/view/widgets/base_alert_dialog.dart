import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:volgatech_client/core/theme/theme_builder.dart';
import 'package:volgatech_client/core/view/extension/simple_padding_extension.dart';

class BaseAlertDialog extends StatelessWidget {
  BaseAlertDialog({
    super.key,
    this.title,
    this.text,
    this.positiveButtonTitle,
    this.onPositiveButtonPressed,
    this.negativeButtonTitle,
    this.onNegativeButtonPressed,
    this.isPositiveDefaultActionIOS = false,
  });

  final String? title;
  final String? text;
  final String? negativeButtonTitle;
  final String? positiveButtonTitle;

  final Function? onPositiveButtonPressed;
  final Function? onNegativeButtonPressed;

  final bool isPositiveDefaultActionIOS;
  final AutoSizeGroup autoSizeGroup = AutoSizeGroup();

  @override
  Widget build(BuildContext context) {
    return _buildCustomMaterialDialog(context);
  }

  Widget _buildCustomMaterialDialog(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            content: Container(
              width: 300,
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (title != null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        title!,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ).bottomPadding(16),
                  if (text != null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(text!),
                    ).bottomPadding(16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      _buildPositiveButton(context),
                      if (onNegativeButtonPressed != null)
                        _buildNegativeButton(context),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPositiveButton(BuildContext context) {
    return TextButton(
      onPressed: () => onPositiveButtonPressed?.call(),
      child: AutoSizeText(
        positiveButtonTitle ?? 'Да',
        group: autoSizeGroup,
        maxFontSize: 16,
      ),
    );
  }

  Widget _buildNegativeButton(BuildContext context) {
    return TextButton(
      onPressed: () => onNegativeButtonPressed?.call(),
      child: AutoSizeText(
        negativeButtonTitle ?? 'Нет',
        group: autoSizeGroup,
        maxFontSize: 16,
      ),
    );
  }

  static Future<dynamic> showWithAnimation({
    required BuildContext context,
    required Widget Function(BuildContext) builder,
  }) async {
    return showGeneralDialog(
      barrierColor: AppColors.lightBlack.withOpacity(0.4),
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: Curves.easeInOut.transform(a1.value),
          child: Opacity(
            opacity: a1.value,
            child: widget,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 250),
      barrierDismissible: false,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return builder.call(context);
      },
    );
  }

  static Future<dynamic> showDialog({
    required BuildContext context,
    String? title,
    String? text,
    String positiveButtonTitle = "Да",
    String negativeButtonTitle = "Нет",
    Function()? onNegativeButtonPressed,
    Function()? onPositiveButtonPressed,
  }) async {
    return BaseAlertDialog.showWithAnimation(
      context: context,
      builder: (context) {
        return BaseAlertDialog(
          title: title,
          text: text,
          positiveButtonTitle: positiveButtonTitle,
          negativeButtonTitle: negativeButtonTitle,
          onPositiveButtonPressed: onPositiveButtonPressed,
          onNegativeButtonPressed: onNegativeButtonPressed,
        );
      },
    );
  }
}
