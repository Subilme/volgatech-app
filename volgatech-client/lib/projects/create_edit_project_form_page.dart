import 'dart:math';

import 'package:flutter/material.dart';
import 'package:volgatech_client/bundles/model/bundle_item_list_model.dart';
import 'package:volgatech_client/bundles/model/entities/bundle_item_info.dart';
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
import 'package:volgatech_client/projects/model/create_edit_project_form_model.dart';
import 'package:volgatech_client/projects/model/entities/project.dart';
import 'package:volgatech_client/projects/model/entities/project_events.dart';
import 'package:volgatech_client/projects/view/add_bundle_list_item.dart';

class CreateEditProjectFormPage extends BasePage {
  final Project? project;

  const CreateEditProjectFormPage({
    super.key,
    this.project,
  });

  @override
  _CreateEditProjectFormPageState createState() =>
      _CreateEditProjectFormPageState();
}

class _CreateEditProjectFormPageState extends BaseFormPageState<
    CreateEditProjectFormPage, CreateEditProjectFormModel> {
  bool get isCreation => widget.project == null;

  @override
  Widget buildForm(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 24.0,
      ),
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      content: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildFormTitle(context).bottomPadding(30),
                _buildNameField(context).bottomPadding(10),
                _buildDescriptionField(context).bottomPadding(10),
                _buildResponsibleField(context).bottomPadding(10),
                _buildSelectBundleField(context).bottomPadding(20),
                _buildSubmitButton(context),
              ],
            ),
          ),
        ),
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
                isCreation ? "Создать проект" : "Редактировать проект",
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

  Widget _buildResponsibleField(BuildContext context) {
    return DecoratedTextFormField(
      controller: formModel.responsibleController,
      labelText: "Ответственный",
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        hintText: "Введите имя",
        isDense: true,
      ),
      validator: formModel.validateField,
    );
  }

  Widget _buildSelectBundleField(BuildContext context) {
    return SelectItemsWidget<BundleItemInfo>(
      headerTitle: "Выберите компоненты",
      labelTitle: "Компоненты",
      hintText: "Выберите компоненты",
      selectedItems: formModel.bundleMap.keys.toList(),
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
          count: formModel.bundleMap[item] ?? 0,
          onCountChanged: (value) {
            if (formModel.bundleMap.containsKey(item)) {
              var maxCount = formModel.bundleItemInfos
                  .firstWhereOrNull(
                    (e) => e.bundleItemInfoId == item.bundleItemInfoId,
                  )
                  ?.count;
              formModel.bundleMap[item] = min(maxCount ?? item.count, value);
            }
            setState(() {});
          },
          onDelete: () {
            formModel.bundleMap.removeWhere(
              (key, value) => key.bundleItemInfoId == item.bundleItemInfoId,
            );
            setState(() {});
          },
        );
      },
      onChange: (items) => setState(() {
        for (var e in items) {
          if (!formModel.bundleMap.containsKey(e)) {
            formModel.bundleMap[e] = min(e.count, 1);
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
        style: AppTextStyle.title2.copyWith(color: AppColors.white),
      ),
    );
  }

  @override
  Future<void> submitForm(BuildContext context) async {
    ApiResponse? response;
    if (isCreation) {
      response = await formModel.createProject();
    } else {
      response = await formModel.editProject(
        projectId: widget.project!.projectId,
      );
    }

    if (response.isError) {
      showMessage(message: response.error!);
    } else {
      showMessage(
        message: isCreation ? "Проект создан" : "Данные обновлены",
      );
      eventBus.fire(ProjectUpdatedEvent(this));
      Navigator.of(context).pop();
    }
  }

  @override
  CreateEditProjectFormModel? createModel() => CreateEditProjectFormModel(
        appModel: appModel,
        project: widget.project,
      );

  @override
  EdgeInsets? formPadding(BuildContext context) => const EdgeInsets.symmetric(
        horizontal: 400,
        vertical: 30,
      );
}
