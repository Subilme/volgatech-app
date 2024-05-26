import 'package:flutter/material.dart';

class ItemFormField<T> extends FormField<T> {
  final Future<T> Function()? onPressed;
  final Widget child;

  ItemFormField({super.key, 
    super.onSaved,
    super.validator,
    this.onPressed,
    required this.child,
    super.initialValue,
    AutovalidateMode super.autovalidateMode = AutovalidateMode.disabled,
  }) : super(
            builder: (FormFieldState<T> fieldState) {
              final state = fieldState as _ItemFormFieldState<T>;
              return state.buildBody();
            });

  @override
  _ItemFormFieldState<T> createState() => _ItemFormFieldState<T>();
}

class _ItemFormFieldState<T> extends FormFieldState<T> {
  @override
  ItemFormField<T> get widget => super.widget as ItemFormField<T>;

  Widget buildBody() {
    return InkWell(
      onTap: () async {
        var selectedValue = await widget.onPressed?.call();
        didChange(selectedValue);
      },
      child: Column(
        children: <Widget>[
          widget.child,
          if (hasError)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      errorText ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.apply(color: Colors.red),
                      maxLines: 3,
                    ),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
