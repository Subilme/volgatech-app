// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:volgatech_client/core/theme/theme_builder.dart';
import 'package:volgatech_client/core/view/extension/simple_padding_extension.dart';

/// виджет для данных вида: title -> data,
/// имеет два макета: горизонтальный/вертикальный, и два источника data: (String text)/(Widget child)
class ItemRow extends StatefulWidget {
  final String title;
  final String? text;
  final TextStyle? titleStyle;
  final TextStyle? textStyle;

  final Widget? titleChild;
  final Widget? child;

  final EdgeInsets? titlePadding;
  final EdgeInsets? contentPadding;
  final EdgeInsets? padding;

  final CrossAxisAlignment crossAxisAlignment;

  final bool isVertical;

  final int? maxLines;
  final Alignment? childAlignment;
  final int? titleFlex;
  final int? dataFlex;
  final TextAlign? textAlign;

  const ItemRow({
    super.key,
    this.isVertical = true,
    this.title = '',
    this.text = '',
    this.titleStyle,
    this.textStyle,
    this.maxLines,
    this.titlePadding,
    this.contentPadding,
    this.padding,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.titleChild,
    this.child,
    this.childAlignment,
    this.dataFlex,
    this.titleFlex,
    this.textAlign,
  });

  const ItemRow.vertical({
    super.key,
    required this.title,
    this.text,
    this.titleStyle,
    this.textStyle,
    this.maxLines,
    this.titlePadding,
    this.contentPadding,
    this.padding,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.titleChild,
    this.child,
    this.childAlignment,
    this.dataFlex,
    this.titleFlex,
    this.textAlign,
  }) : isVertical = true;

  const ItemRow.horizontal({
    super.key,
    required this.title,
    this.text,
    this.titleStyle,
    this.textStyle,
    this.maxLines,
    this.titlePadding,
    this.contentPadding,
    this.padding,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.titleChild,
    this.child,
    this.childAlignment,
    this.dataFlex,
    this.titleFlex,
    this.textAlign,
  }) : isVertical = false;

  @override
  ItemRowState createState() {
    return isVertical ? ItemRowVertical() : ItemRowHorizontal();
  }

  bool get isHorizontal => !isVertical;
}

abstract class ItemRowState extends State<ItemRow> {
  Widget buildChild(BuildContext context) {
    if (widget.child != null) {
      return widget.child!;
    }
    return buildText(context);
  }

  Widget buildText(BuildContext context) {
    var style = widget.textStyle ?? Theme.of(context).textTheme.bodyMedium;
    var alignment = widget.textAlign ??
        (widget.isHorizontal ? TextAlign.right : TextAlign.left);
    return Text(
      widget.text ?? '',
      style: style,
      textAlign: alignment,
      overflow: TextOverflow.clip,
      maxLines: widget.maxLines,
    );
  }

  Widget buildTitleText(BuildContext context) {
    if (widget.titleChild != null) {
      return widget.titleChild!;
    }
    var style = widget.titleStyle ?? Theme.of(context).textTheme.bodyLarge;
    return Text(
      widget.title,
      style: style,
    );
  }

  EdgeInsets getTitlePadding(BuildContext context) {
    if (widget.titlePadding != null) {
      return widget.titlePadding!;
    }
    return EdgeInsets.only(
      bottom: (widget.isVertical) ? ThemeBuilder.defaultPadding : 0,
      right: (widget.isHorizontal) ? ThemeBuilder.defaultPadding : 0,
    );
  }

  EdgeInsets getContentPadding(BuildContext context) {
    if (widget.contentPadding != null) {
      return widget.contentPadding!;
    }
    return EdgeInsets.zero;
  }

  List<Widget> buildChildren(BuildContext context) {
    var alignment = widget.childAlignment ??
        (widget.isHorizontal ? Alignment.centerRight : Alignment.centerLeft);
    return [
      if (widget.titleFlex != null)
        Expanded(
          flex: widget.titleFlex!,
          child: buildTitleText(context).allPadding(getTitlePadding(context)),
        )
      else
        buildTitleText(context).allPadding(getTitlePadding(context)),
      Flexible(
        flex: widget.dataFlex ?? 1,
        child: Align(
          alignment: alignment,
          child: buildChild(context).allPadding(getContentPadding(context)),
        ),
      ),
    ];
  }

  EdgeInsets getPadding() {
    if (widget.padding != null) {
      return widget.padding!;
    }
    return const EdgeInsets.symmetric(
      horizontal: ThemeBuilder.defaultPadding,
      vertical: ThemeBuilder.defaultPadding,
    );
  }
}

class ItemRowVertical extends ItemRowState {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: widget.crossAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: buildChildren(context),
    ).allPadding(getPadding());
  }
}

class ItemRowHorizontal extends ItemRowState {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: widget.crossAxisAlignment,
      children: buildChildren(context),
    ).allPadding(getPadding());
  }
}
