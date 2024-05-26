import 'package:flutter/material.dart';
import 'package:volgatech_client/bundles/model/entities/bundle_item_info.dart';
import 'package:volgatech_client/core/model/helpers/assets_catalog.dart';

class AddBundleListItem extends StatelessWidget {
  final BundleItemInfo bundleItem;
  final int count;
  final Function(int) onCountChanged;
  final VoidCallback onDelete;

  AddBundleListItem({
    super.key,
    required this.bundleItem,
    this.count = 0,
    required this.onCountChanged,
    required this.onDelete,
  });

  late final TextEditingController _nameController = TextEditingController(
    text: bundleItem.title,
  );

  late final TextEditingController _countController = TextEditingController(
    text: count.toString(),
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 4,
          child: IgnorePointer(
            ignoring: true,
            child: TextField(
              controller: _nameController,
              readOnly: true,
              showCursor: false,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: TextField(
            controller: _countController,
            onChanged: (value) {
              var intValue = int.tryParse(value);
              if (intValue == null) {
                var list = value.split("");
                list.removeLast();
                return;
              }
              onCountChanged.call(intValue);
            },
          ),
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: onDelete,
          child: Image.asset(
            AssetsCatalog.icCancel,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
