import 'package:flutter/material.dart';
import 'package:volgatech_client/bundles/model/bundle_api.dart';
import 'package:volgatech_client/bundles/model/entities/bundle_info.dart';
import 'package:volgatech_client/bundles/model/entities/bundle_item_info.dart';
import 'package:volgatech_client/category/model/entities/category.dart';
import 'package:volgatech_client/core/model/api/api_response.dart';
import 'package:volgatech_client/core/model/extension/iterable_extension.dart';
import 'package:volgatech_client/core/model/models/form_model.dart';

class CreateEditBundleModel extends FormModel {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController countController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Map<BundleItemInfo, int> bundleItemsMap = {};

  List<BundleItemInfo> bundleItemInfos = [];
  List<Category> categories = [];

  Category? selectedCategory;

  BundleApi get api => appModel.bundleModule.api;

  CreateEditBundleModel({
    required super.appModel,
    BundleInfo? bundleInfo,
  }) {
    _prepareData(bundleInfo);
    _loadCategories();
    _loadBundleInfo(bundleInfo);
  }

  void _prepareData(BundleInfo? bundleInfo) {
    if (bundleInfo == null) {
      return;
    }

    nameController.text = bundleInfo.name ?? "";
    countController.text = bundleInfo.count.toString();
    descriptionController.text = bundleInfo.description ?? "";
    selectedCategory = bundleInfo.category;

    for (var element in bundleInfo.bundleItemInfos) {
      bundleItemsMap[element] = element.count;
    }
  }

  /// Загрузка информации о компонентах проекта для возможности изменения их количества
  void _loadBundleInfo(BundleInfo? bundleInfo) async {
    if (bundleInfo == null) {
      return;
    }

    var list =
        (await appModel.bundleModule.api.loadBundleItemList()).result ?? [];
    for (var e in bundleInfo.bundleItemInfos) {
      var item = list.firstWhereOrNull(
            (x) => x.bundleItemInfoId == e.bundleItemInfoId,
      );
      if (item != null) {
        bundleItemInfos.add(item);
      }
    }
  }

  void _loadCategories() async {
    var response = await appModel.categoryModule.api.loadCategoryList();
    categories = response.result ?? [];
    notifyModelListeners();
  }

  Future<ApiResponse<BundleInfo>> createBundle() async {
    var response = await api.createBundle(
      categoryId: selectedCategory?.categoryId,
      name: nameController.text,
      count: int.tryParse(countController.text) ?? 0,
      description: descriptionController.text,
      bundleItems: bundleItemsMap,
    );
    return response;
  }

  Future<ApiResponse<BundleInfo>> editBundle({
    required int bundleId,
  }) async {
    var response = await api.editBundle(
      bundleId: bundleId,
      categoryId: selectedCategory?.categoryId,
      name: nameController.text,
      count: int.tryParse(countController.text) ?? 0,
      description: descriptionController.text,
      bundleItems: bundleItemsMap,
    );

    return response;
  }

  String? validateField(String? value) =>
      (value?.isEmpty ?? true) ? "Заполните поле" : null;
}
