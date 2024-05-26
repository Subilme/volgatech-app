// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

class ExpandedWidget extends StatefulWidget {
  final Widget child;
  final String? title;
  final Widget? titleChild;
  final bool expanded;
  final VoidCallback? onExpanded;
  final VoidCallback? onCollapsed;
  final Future<void> Function()? beforeCollapsed;
  final double paddingTitle;
  final EdgeInsets? padding;
  final TextStyle? titleStyle;

  const ExpandedWidget({
    super.key,
    required this.child,
    this.title,
    this.titleChild,
    this.expanded = false,
    this.onExpanded,
    this.onCollapsed,
    this.paddingTitle = 12.0,
    this.padding,
    this.beforeCollapsed,
    this.titleStyle,
  }) : assert(title != null || titleChild != null);

  @override
  _ExpandedWidgetState createState() => _ExpandedWidgetState();
}

class _ExpandedWidgetState extends State<ExpandedWidget>
    with TickerProviderStateMixin {
  static const int ANIMATION_DURATION = 500;
  late bool _expanded = widget.expanded;

  late final _expandController = AnimationController(
    value: widget.expanded ? 1 : 0,
    vsync: this,
    duration: const Duration(milliseconds: ANIMATION_DURATION),
  );
  late final _animation = CurvedAnimation(
    parent: _expandController,
    curve: Curves.fastOutSlowIn,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: _onToggle,
          splashFactory: NoSplash.splashFactory,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 12,
              horizontal: widget.paddingTitle,
            ),
            child: _buildTitle(context),
          ),
        ),
        SizeTransition(
          axisAlignment: 1.0,
          sizeFactor: _animation,
          child: widget.padding != null
              ? Padding(
                  padding: widget.padding!,
                  child: widget.child,
                )
              : widget.child,
        ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return widget.titleChild ??
        Row(
          children: [
            Expanded(
              child: Text(
                widget.title!,
                style:
                    widget.titleStyle ?? Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ],
        );
  }

  void _onToggle() async {
    setState(() {
      _expanded = !_expanded;
    });

    if (_expanded) {
      _expandController.forward();
      widget.onExpanded?.call();
    } else {
      await widget.beforeCollapsed?.call();
      _expandController.reverse();
      widget.onCollapsed?.call();
    }
  }
}
