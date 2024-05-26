import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:volgatech_client/core/view/extension/simple_padding_extension.dart';
import 'package:volgatech_client/core/view/widgets/decorated_text_form_field.dart';
import 'package:volgatech_client/responsible/model/entities/responsible.dart';

class CreateEditResponsibleAlert extends StatelessWidget {
  final Responsible? responsible;

  CreateEditResponsibleAlert({
    super.key,
    this.responsible,
  });

  late final TextEditingController _controller = TextEditingController(
    text: responsible?.name,
  );

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
                      responsible == null ? "Добавление" : "Редактирование",
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
              hintText: "Введите текст",
            ),
          ).bottomPadding(12),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(_controller.text),
            child: const Text("Сохранить"),
          ),
        ],
      ),
    );
  }
}
