import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:volgatech_client/core/theme/theme_builder.dart';
import 'package:provider/provider.dart';

class CardWidget extends StatelessWidget {
  final Widget? child;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double? height;

  const CardWidget({
    super.key,
    this.child,
    this.borderRadius,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    var themeBuilder = context.read<ThemeBuilder>();
    var cardDecoration = themeBuilder.buildCardDecoration(context).copyWith(
          borderRadius: borderRadius,
        );
    return Container(
      width: width,
      height: height,
      decoration: cardDecoration,
      margin: margin,
      padding: padding,
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}
