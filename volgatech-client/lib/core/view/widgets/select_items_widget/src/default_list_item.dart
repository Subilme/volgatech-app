import 'package:flutter/material.dart';
import 'package:volgatech_client/core/model/entities/selectable.dart';

class DefaultSelectListItem<TFieldValueType extends ISelectable?>
    extends StatelessWidget {
  final TFieldValueType item;
  final bool selected;

  const DefaultSelectListItem({
    required this.item,
    super.key,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Text(
                item?.title ?? '',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          if (selected) const Icon(Icons.check),
        ],
      ),
    );
  }
}

class DefaultModalSelectListItem<TFieldValueType extends ISelectable?>
    extends StatelessWidget {
  final TFieldValueType item;
  final bool selected;

  const DefaultModalSelectListItem({
    required this.item,
    super.key,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item?.title ?? '',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          if (selected) const Icon(Icons.check),
        ],
      ),
    );
  }
}
