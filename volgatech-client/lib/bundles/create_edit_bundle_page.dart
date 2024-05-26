import 'dart:math';

import 'package:flutter/material.dart';
import 'package:volgatech_client/bundles/model/bundle_item_list_model.dart';
import 'package:volgatech_client/bundles/model/create_edit_bundle_model.dart';
import 'package:volgatech_client/bundles/model/entities/bundle_events.dart';
import 'package:volgatech_client/bundles/model/entities/bundle_info.dart';
import 'package:volgatech_client/bundles/model/entities/bundle_item_info.dart';
import 'package:volgatech_client/category/model/category_list_model.dart';
import 'package:volgatech_client/category/model/entities/category.dart';
import 'package:volgatech_client/core/model/api/api_response.dart';
import 'package:volgatech_client/core/model/entities/selectable.dart';
import 'package:volgatech_client/core/model/extension/iterable_extension.dart';
import 'package:volgatech_client/core/page/base_form_page.dart';
import 'package:volgatech_client/core/page/base_page.dart';
import 'package:volgatech_client/core/theme/theme_builder.dart';
import 'package:volgatech_client/core/view/extension/simple_padding_extension.dart';
import 'package:volgatech_client/core/view/widgets/custom_back_button.dart';
import 'package:volgatech_client/core/view/widgets/decorated_text_form_field.dart';
import 'package:volgatech_client/core/view/widgets/select_items_widget/select_items_widget.dart';
import 'package:volgatech_client/projects/view/add_bundle_list_item.dart';

class CreateEditBundlePage extends BasePage {
  final BundleInfo? bundleInfo;

  const CreateEditBundlePage({
    super.key,
    this.bundleInfo,
  });

  @override
  _CreateEditBundlePageState createState() => _CreateEditBundlePageState();
}

class _CreateEditBundlePageState
    extends BaseFormPageState<CreateEditBundlePage, CreateEditBundleModel> {
  bool get isCreation => widget.bundleInfo == null;

  @override
  Widget buildForm(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildFormTitle(context).bottomPadding(30),
          _buildNameField(context).bottomPadding(10),
          _buildCountField(context).bottomPadding(10),
          _buildDescriptionField(context).bottomPadding(10),
          _buildCategoryField(context).bottomPadding(10),
          _buildSelectBundleItemField(context).bottomPadding(30),
          _buildSubmitButton(context),
        ],
      ),
    );
  }

  Widget _buildFormTitle(BuildContext context) {
    return Stack(
      children: [
        const CustomBackButton(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 50),
            Flexible(
              child: Text(
                isCreation ? "Создать набор" : "Редактировать набор",
                style: Theme.of(context)
                    .textTheme
                    .displaySmall
                    ?.copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 50),
          ],
        ),
      ],
    );
  }

  Widget _buildNameField(BuildContext context) {
    return DecoratedTextFormField(
      controller: formModel.nameController,
      labelText: "Название*",
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        hintText: "Введите название",
        isDense: true,
      ),
      validator: formModel.validateField,
    );
  }

  Widget _buildCountField(BuildContext context) {
    return DecoratedTextFormField(
      controller: formModel.countController,
      labelText: "Количество*",
      decoration: const InputDecoration(
        hintText: "Введите количество",
        isDense: true,
      ),
      validator: formModel.validateField,
    );
  }

  Widget _buildDescriptionField(BuildContext context) {
    return DecoratedTextFormField(
      controller: formModel.descriptionController,
      labelText: "Описание",
      textCapitalization: TextCapitalization.sentences,
      minLines: 4,
      maxLines: 4,
      decoration: const InputDecoration(
        hintText: "Введите описание",
        isDense: true,
      ),
    );
  }

  Widget _buildCategoryField(BuildContext context) {
    return SelectItemsWidget<Category>(
      headerTitle: "Выберите категорию",
      labelTitle: "Категория",
      hintText: "Выберите категорию",
      single: true,
      selectedItems: formModel.selectedCategory == null
          ? []
          : [formModel.selectedCategory!],
      onChange: (items) => setState(() {
        formModel.selectedCategory = items.safeFirst;
      }),
      modelBuilder: () => CategoryListModel(appModel: appModel),
    );
  }

  Widget _buildSelectBundleItemField(BuildContext context) {
    return SelectItemsWidget<BundleItemInfo>(
      headerTitle: "Выберите компоненты",
      labelTitle: "Компоненты",
      hintText: "Выберите компоненты",
      selectedItems: formModel.bundleItemsMap.keys.toList(),
      itemBuilder: (BuildContext context, ISelectable? item, bool selected) {
        var bundleItem = item as BundleItemInfo;
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(bundleItem.title ?? bundleItem.id.toString()),
                    const SizedBox(width: 8),
                    Text(
                      "Свободно ${bundleItem.count}",
                      style: AppTextStyle.small.copyWith(color: AppColors.grey),
                    ),
                  ],
                ),
              ),
              if (selected) const Icon(Icons.check),
            ],
          ),
        );
      },
      fieldItemBuilder: (context, item) {
        return AddBundleListItem(
          bundleItem: item!,
          count: formModel.bundleItemsMap[item] ?? 0,
          onCountChanged: (value) {
            if (formModel.bundleItemsMap.containsKey(item)) {
              var maxCount = formModel.bundleItemInfos
                  .firstWhereOrNull(
                    (e) => e.bundleItemInfoId == item.bundleItemInfoId,
                  )
                  ?.count;
              formModel.bundleItemsMap[item] =
                  min(maxCount ?? item.count, value);
            }
            setState(() {});
          },
          onDelete: () {
            formModel.bundleItemsMap.removeWhere(
              (key, value) => key.bundleItemInfoId == item.bundleItemInfoId,
            );
            setState(() {});
          },
        );
      },
      onChange: (items) => setState(() {
        for (var e in items) {
          if (!formModel.bundleItemsMap.containsKey(e)) {
            formModel.bundleItemsMap[e] = min(e.count, 1);
          }
        }
      }),
      modelBuilder: () => BundleItemListModel(appModel: appModel),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => trySubmitForm(context),
      child: Text(
        "Сохранить",
        style: AppTextStyle.title2.copyWith(color: Colors.white),
      ),
    );
  }

  @override
  Future<void> submitForm(BuildContext context) async {
    ApiResponse? response;
    if (isCreation) {
      response = await formModel.createBundle();
    } else {
      response = await formModel.editBundle(
        bundleId: widget.bundleInfo!.bundleInfoId,
      );
    }

    if (response.isError) {
      showMessage(message: response.error!);
    } else {
      showMessage(
        message: isCreation ? "Набор создан" : "Данные обновлены",
      );
      eventBus.fire(BundleUpdatedEvent(this));
      Navigator.of(context).pop();
    }
  }

  @override
  CreateEditBundleModel? createModel() => CreateEditBundleModel(
        appModel: appModel,
        bundleInfo: widget.bundleInfo,
      );

  @override
  EdgeInsets? formPadding(BuildContext context) => const EdgeInsets.symmetric(
        horizontal: 400,
        vertical: 30,
      );
}
