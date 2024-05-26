import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:volgatech_client/core/theme/theme_builder.dart';
import 'package:volgatech_client/storage/model/entities/storage.dart';
import 'package:volgatech_client/core/view/extension/simple_padding_extension.dart';
import 'package:volgatech_client/core/view/widgets/decorated_text_form_field.dart';

class CreateEditStorageAlert extends StatefulWidget {
  final Storage? storage;
  final List<Storage> storages;

  const CreateEditStorageAlert({
    super.key,
    this.storage,
    this.storages = const [],
  });

  @override
  State<CreateEditStorageAlert> createState() => _CreateEditStorageAlertState();
}

class _CreateEditStorageAlertState extends State<CreateEditStorageAlert> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.storage?.name,
  );

  Storage? parentStorage;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 50),
                  Flexible(
                    child: Text(
                      widget.storage == null ? "Добавление" : "Редактирование",
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
          ).bottomPadding(12),
          DecoratedTextFormField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: "Введите название",
            ),
          ).bottomPadding(12),
          if (widget.storages.isNotEmpty)
            DropdownButtonFormField(
              hint: Text(
                "Выберите родительский склад",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.grey),
              ),
              items: widget.storages
                  .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                  .toList(),
              onChanged: (value) => setState(() {
                parentStorage = value;
              }),
            ).bottomPadding(12),
          ElevatedButton(
            onPressed: () {
              if (_controller.text.isEmpty) {
                Navigator.of(context).pop(null);
                return;
              }
              var newStorage = Storage(
                storageId: widget.storage?.storageId ?? -1,
                name: _controller.text,
                parentStorage: parentStorage,
              );
              Navigator.of(context).pop(newStorage);
            },
            child: const Text("Сохранить"),
          ),
        ],
      ),
    );
  }
}
