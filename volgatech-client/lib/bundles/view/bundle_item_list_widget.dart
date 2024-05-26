// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:volgatech_client/bundles/model/entities/bundle_item_info.dart';
import 'package:volgatech_client/core/model/extension/iterable_extension.dart';
import 'package:volgatech_client/core/theme/theme_builder.dart';

class BundleItemListWidget extends StatefulWidget {
  final List<BundleItemInfo> bundleItems;

  const BundleItemListWidget({
    super.key,
    this.bundleItems = const [],
  });

  @override
  _BundleItemListWidgetState createState() => _BundleItemListWidgetState();
}

class _BundleItemListWidgetState extends State<BundleItemListWidget>
    with TickerProviderStateMixin {
  static const int ANIMATION_DURATION = 500;
  late bool _expanded = false;

  late final _expandController = AnimationController(
    value: _expanded ? 1 : 0,
    vsync: this,
    duration: const Duration(milliseconds: ANIMATION_DURATION),
  );

  late final _animation = CurvedAnimation(
    parent: _expandController,
    curve: Curves.fastOutSlowIn,
  );

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: AppColors.border,
        width: 1,
      ),
    );

    return Container(
      decoration: decoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: _onToggle,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: _buildTitle(context),
            ),
          ),
          SizeTransition(
            axisAlignment: 1.0,
            sizeFactor: _animation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Divider(),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: _buildBundleItem,
                  separatorBuilder: (context, index) => const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Divider(),
                  ),
                  itemCount: widget.bundleItems.length,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            "Состав набора",
            style: AppTextStyle.title,
          ),
        ),
        Icon(_expanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
      ],
    );
  }

  Widget _buildBundleItem(BuildContext context, int index) {
    var item = widget.bundleItems[index];
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  item.name ?? "Элемент ${item.bundleItemInfoId}",
                  style: AppTextStyle.body1.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "Всего: ${item.count} шт.",
                  style: AppTextStyle.body1,
                ),
              ].separate((index, length) => const SizedBox(height: 6)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _onToggle() {
    setState(() {
      _expanded = !_expanded;
    });

    if (_expanded) {
      _expandController.forward();
    } else {
      _expandController.reverse();
    }
  }
}
