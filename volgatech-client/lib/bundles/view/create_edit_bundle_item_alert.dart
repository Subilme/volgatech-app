import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:volgatech_client/bundles/model/entities/bundle_item_info.dart';
import 'package:volgatech_client/core/view/extension/simple_padding_extension.dart';
import 'package:volgatech_client/core/view/widgets/decorated_text_form_field.dart';

class CreateEditBundleItemAlert extends StatefulWidget {
  final BundleItemInfo? bundleItem;

  const CreateEditBundleItemAlert({
    super.key,
    this.bundleItem,
  });

  @override
  State<CreateEditBundleItemAlert> createState() =>
      _CreateEditBundleItemAlertState();
}

class _CreateEditBundleItemAlertState extends State<CreateEditBundleItemAlert> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _countController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _nameController.text = widget.bundleItem?.name ?? "";
    _countController.text = widget.bundleItem?.count.toString() ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context).bottomPadding(12),
            _buildTextFields(context).bottomPadding(12),
            _buildSaveButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 50),
            Flexible(
              child: Text(
                widget.bundleItem == null ? "Добавление" : "Редактирование",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 50),
          ],
        ),
        Row(
          children: [
            const Spacer(),
            CupertinoButton(
              minSize: 24,
              padding: EdgeInsets.zero,
              onPressed: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.close,
                color: Colors.black,
                size: 24,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextFields(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 5,
          child: DecoratedTextFormField(
            controller: _nameController,
            labelText: "Название",
            decoration: const InputDecoration(
              hintText: "Название",
            ),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          flex: 2,
          child: DecoratedTextFormField(
            controller: _countController,
            labelText: "Кол-во",
            onChanged: (value) {
              var intValue = int.tryParse(value);
              if (intValue == null) {
                var list = value.split("");
                list.removeLast();
                _countController.text = list.join();
              }
            },
            decoration: const InputDecoration(
              hintText: "Кол-во",
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        var bundleItem = BundleItemInfo(
          bundleItemInfoId: widget.bundleItem?.bundleItemInfoId ?? -1,
          name: _nameController.text,
          count: int.tryParse(_countController.text) ?? 0,
        );

        Navigator.of(context).pop(bundleItem);
      },
      child: const Text("Сохранить"),
    );
  }
}
