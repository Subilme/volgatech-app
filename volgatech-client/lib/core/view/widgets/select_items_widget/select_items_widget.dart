import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:volgatech_client/core/model/entities/selectable.dart';
import 'package:volgatech_client/core/model/helpers/assets_catalog.dart';
import 'package:volgatech_client/core/model/models/list_model.dart';
import 'package:volgatech_client/core/theme/theme_builder.dart';
import 'package:volgatech_client/core/view/widgets/select_items_widget/src/select_items_modal_page.dart';

class SelectItemsWidget<TValueType extends ISelectable> extends StatefulWidget {
  final Widget Function(BuildContext, TValueType?, bool)? itemBuilder;
  final Widget Function(BuildContext, TValueType?)? fieldItemBuilder;
  final Widget Function(BuildContext)? separatorBuilder;
  final List<TValueType> selectedItems;
  final bool single;

  final ValueChanged<List<TValueType>>? onChange;
  final String? headerTitle;
  final String? labelTitle;
  final String? hintText;
  final ListModel<TValueType> Function()? modelBuilder;
  final String? emptyText;
  final String? icon;

  const SelectItemsWidget({
    super.key,
    this.itemBuilder,
    this.fieldItemBuilder,
    this.separatorBuilder,
    this.selectedItems = const [],
    this.onChange,
    this.single = false,
    this.headerTitle,
    this.labelTitle,
    this.hintText,
    this.modelBuilder,
    this.emptyText,
    this.icon,
  });

  @override
  _SelectItemsWidgetState<TValueType> createState() =>
      _SelectItemsWidgetState<TValueType>();
}

class _SelectItemsWidgetState<TValueType extends ISelectable>
    extends State<SelectItemsWidget> {
  final ScrollController _controller = ScrollController();

  @override
  SelectItemsWidget<TValueType> get widget =>
      super.widget as SelectItemsWidget<TValueType>;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.labelTitle != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                widget.labelTitle!,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: AppColors.lightBlack),
              ),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (widget.selectedItems.isEmpty) ...[
                    Text(
                      widget.hintText ?? "Выберите элементы'",
                      style: AppTextStyle.body1.copyWith(
                        color: AppColors.sonicSilver,
                      ),
                    ),
                    Image.asset(widget.icon ?? AssetsCatalog.icArrowRight),
                  ] else
                    Flexible(
                      child: OverflowBar(
                        spacing: 8,
                        overflowSpacing: 8,
                        children: widget.selectedItems
                            .map<Widget>((e) => _buildSelectedItem(context, e))
                            .toList(),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedItem(BuildContext context, TValueType item) {
    return widget.fieldItemBuilder?.call(context, item) ??
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColors.secondaryColor.withOpacity(0.6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  item.title ?? "",
                  style: AppTextStyle.body1.copyWith(color: AppColors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () => widget.onChange?.call(widget.selectedItems),
                child: Image.asset(
                  AssetsCatalog.icCancel,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        );
  }

  void onTap() async {
    final selected = await showCustomModalBottomSheet(
      context: context,
      enableDrag: false,
      useRootNavigator: true,
      duration: const Duration(milliseconds: 300),
      containerWidget: (ctx, animation, child) => _buildContainerWidget(
        context: ctx,
        animation: animation,
        child: child,
      ),
      builder: (context) => SelectItemsModalPage<TValueType>(
        controller: _controller,
        selectedItems: widget.selectedItems,
        itemBuilder: widget.itemBuilder,
        model: widget.modelBuilder!(),
        single: widget.single,
        emptyText: widget.emptyText,
        separatorBuilder: widget.separatorBuilder,
        title: widget.headerTitle,
      ),
    );

    if (selected != null) {
      widget.onChange?.call(selected);
    }
  }

  Widget _buildContainerWidget({
    required BuildContext context,
    Animation<double>? animation,
    Widget? child,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        color: Colors.transparent,
        alignment: Alignment.bottomCenter,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {},
              child: Material(
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(12),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
