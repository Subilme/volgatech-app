import 'package:flutter/material.dart';
import 'package:volgatech_client/core/theme/theme_builder.dart';
import 'package:volgatech_client/core/view/extension/simple_padding_extension.dart';

class SelectableField extends StatelessWidget {
  final String? title;
  final String? value;
  final String? hintText;

  const SelectableField({super.key, this.title, this.value, this.hintText});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if ((title?.length ?? 0) > 0)
          Text(
            title!,
            style: Theme.of(context).inputDecorationTheme.labelStyle,
          ).bottomPadding(8),
        Row(
          children: <Widget>[
            Expanded(
              child: (value != null)
                  ? Text(
                      value ?? '',
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 3,
                    )
                  : Text(
                      hintText ?? 'Выберите элемент',
                      textAlign: TextAlign.left,
                      style: Theme.of(context).inputDecorationTheme.hintStyle,
                      maxLines: 3,
                    ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 22,
              color: AppColors.midGrey,
            ),
          ],
        ),
      ],
    );
  }
}
