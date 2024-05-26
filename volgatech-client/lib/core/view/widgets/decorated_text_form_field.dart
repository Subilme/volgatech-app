import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DecoratedTextFormField extends StatelessWidget {
  final Key? formFieldKey;
  final EdgeInsets? contentPadding;
  final String? labelText;
  final TextStyle? labelStyle;
  final EdgeInsets? labelPadding;
  final TextEditingController? controller;
  final String? initialValue;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool autofocus;
  final bool readOnly;
  final EditableTextContextMenuBuilder? contextMenuBuilder;
  final bool showCursor;
  final bool obscureText;
  final bool autocorrect;
  final bool enableSuggestions;
  final AutovalidateMode autovalidateMode;
  final int maxLines;
  final int minLines;
  final bool expands;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final double cursorWidth;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool enableInteractiveSelection;
  final InputCounterWidgetBuilder? buildCounter;
  final Widget? suffix;
  final Widget? preffix;
  final Iterable<String>? autofillHints;
  final MaxLengthEnforcement maxLengthEnforcement;

  const DecoratedTextFormField({
    super.key,
    this.formFieldKey,
    this.labelText,
    this.labelStyle,
    this.labelPadding,
    this.contentPadding,
    this.controller,
    this.initialValue,
    this.focusNode,
    this.suffix,
    this.preffix,
    this.decoration = const InputDecoration(),
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.style,
    this.strutStyle,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.autofocus = false,
    this.readOnly = false,
    this.contextMenuBuilder = _defaultContextMenuBuilder,
    this.showCursor = true,
    this.obscureText = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.maxLines = 1,
    this.minLines = 1,
    this.expands = false,
    this.maxLength,
    this.onChanged,
    this.onTap,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onSaved,
    this.validator,
    this.inputFormatters,
    this.enabled = true,
    this.cursorWidth = 2.0,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableInteractiveSelection = true,
    this.buildCounter,
    this.autofillHints,
    this.maxLengthEnforcement = MaxLengthEnforcement.enforced,
  });

  static Widget _defaultContextMenuBuilder(
    BuildContext context,
    EditableTextState editableTextState,
  ) {
    return AdaptiveTextSelectionToolbar.editableText(
      editableTextState: editableTextState,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: contentPadding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if ((labelText?.length ?? 0) > 0)
            Padding(
              padding: labelPadding ?? const EdgeInsets.only(bottom: 10),
              child: Text(
                labelText!,
                style: labelStyle ??
                    Theme.of(context).inputDecorationTheme.labelStyle,
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (preffix != null) preffix!,
              Expanded(
                child: TextFormField(
                  key: formFieldKey,
                  controller: controller,
                  initialValue: initialValue,
                  focusNode: focusNode,
                  decoration: decoration,
                  keyboardType: keyboardType,
                  textCapitalization: textCapitalization,
                  textInputAction: textInputAction,
                  style: style,
                  strutStyle: strutStyle,
                  textDirection: textDirection,
                  textAlign: textAlign,
                  textAlignVertical: textAlignVertical,
                  autofocus: autofocus,
                  readOnly: readOnly,
                  contextMenuBuilder: contextMenuBuilder,
                  showCursor: showCursor,
                  obscureText: obscureText,
                  autocorrect: autocorrect,
                  enableSuggestions: enableSuggestions,
                  autovalidateMode: autovalidateMode,
                  maxLengthEnforcement: maxLengthEnforcement,
                  maxLines: maxLines,
                  minLines: minLines,
                  expands: expands,
                  maxLength: maxLength,
                  onChanged: onChanged,
                  onTap: onTap,
                  onEditingComplete: onEditingComplete,
                  onFieldSubmitted: onFieldSubmitted,
                  onSaved: onSaved,
                  validator: validator,
                  inputFormatters: inputFormatters,
                  enabled: enabled,
                  cursorWidth: cursorWidth,
                  cursorRadius: cursorRadius,
                  cursorColor: cursorColor,
                  keyboardAppearance: keyboardAppearance,
                  scrollPadding: scrollPadding,
                  enableInteractiveSelection: enableInteractiveSelection,
                  buildCounter: buildCounter,
                  autofillHints: autofillHints,
                ),
              ),
              if (suffix != null) suffix!,
            ],
          )
        ],
      ),
    );
  }
}
