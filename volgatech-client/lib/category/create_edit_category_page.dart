import 'package:flutter/material.dart';
import 'package:volgatech_client/bundles/model/bundle_list_model.dart';
import 'package:volgatech_client/bundles/model/entities/bundle_info.dart';
import 'package:volgatech_client/category/model/create_edit_category_form_model.dart';
import 'package:volgatech_client/category/model/entities/category.dart';
import 'package:volgatech_client/category/model/entities/category_events.dart';
import 'package:volgatech_client/core/model/api/api_response.dart';
import 'package:volgatech_client/core/page/base_form_page.dart';
import 'package:volgatech_client/core/page/base_page.dart';
import 'package:volgatech_client/core/theme/theme_builder.dart';
import 'package:volgatech_client/core/view/extension/simple_padding_extension.dart';
import 'package:volgatech_client/core/view/widgets/custom_back_button.dart';
import 'package:volgatech_client/core/view/widgets/decorated_text_form_field.dart';
import 'package:volgatech_client/core/view/widgets/select_items_widget/select_items_widget.dart';

class CreateEditCategoryFormPage extends BasePage {
  final Category? category;

  const CreateEditCategoryFormPage({
    super.key,
    this.category,
  });

  @override
  _CreateEditCategoryFormPageState createState() =>
      _CreateEditCategoryFormPageState();
}

class _CreateEditCategoryFormPageState extends BaseFormPageState<
    CreateEditCategoryFormPage, CreateEditCategoryFormModel> {
  bool get isCreation => widget.category == null;

  @override
  Widget buildForm(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildFormTitle(context).bottomPadding(30),
          _buildNameField(context).bottomPadding(10),
          _buildSelectBundleField(context).bottomPadding(30),
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
                isCreation ? "Создать категорию" : "Редактировать категорию",
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

  Widget _buildSelectBundleField(BuildContext context) {
    return SelectItemsWidget<BundleInfo>(
      headerTitle: "Выберите наборы",
      labelTitle: "Наборы",
      hintText: "Выберите наборы",
      selectedItems: formModel.selectedBundles,
      onChange: (items) => setState(() {
        formModel.selectedBundles = items;
      }),
      modelBuilder: () => BundleListModel(appModel: appModel),
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
      response = await formModel.createCategory();
    } else {
      response = await formModel.editCategory(
        categoryId: widget.category!.categoryId,
      );
    }

    if (response.isError) {
      showMessage(message: response.error!);
    } else {
      eventBus.fire(CategoryUpdatedEvent(this));
      Navigator.of(context).pop();
    }
  }

  @override
  CreateEditCategoryFormModel? createModel() => CreateEditCategoryFormModel(
        appModel: appModel,
        category: widget.category,
      );

  @override
  EdgeInsets? formPadding(BuildContext context) => const EdgeInsets.symmetric(
        horizontal: 400,
        vertical: 30,
      );
}
