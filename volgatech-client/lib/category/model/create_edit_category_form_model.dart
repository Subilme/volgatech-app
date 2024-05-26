import 'package:flutter/cupertino.dart';
import 'package:volgatech_client/bundles/model/entities/bundle_info.dart';
import 'package:volgatech_client/category/model/category_api.dart';
import 'package:volgatech_client/category/model/entities/category.dart';
import 'package:volgatech_client/core/model/api/api_response.dart';
import 'package:volgatech_client/core/model/models/form_model.dart';

class CreateEditCategoryFormModel extends FormModel {
  final TextEditingController nameController = TextEditingController();

  CategoryApi get api => appModel.categoryModule.api;

  List<BundleInfo> selectedBundles = [];

  CreateEditCategoryFormModel({
    required super.appModel,
    Category? category,
  }) {
    _prepareData(category);
  }

  void _prepareData(Category? category) {
    if (category == null) {
      return;
    }

    nameController.text = category.name;
    selectedBundles = category.bundleInfos;
  }

  Future<ApiResponse<Category>> createCategory() async {
    var response = await api.createCategory(
      name: nameController.text,
      bundleIds: selectedBundles.map((e) => e.bundleInfoId).toList(),
    );
    return response;
  }

  Future<ApiResponse<Category>> editCategory({
    required int categoryId,
  }) async {
    var response = await api.editCategory(
      categoryId: categoryId,
      name: nameController.text,
      bundleIds: selectedBundles.map((e) => e.bundleInfoId).toList(),
    );
    return response;
  }

  String? validateField(String? value) =>
      (value?.isEmpty ?? true) ? "Заполните поле" : null;
}
