import 'package:flutter/cupertino.dart';
import 'package:volgatech_client/bundles/model/entities/bundle_item_info.dart';
import 'package:volgatech_client/core/model/api/api_response.dart';
import 'package:volgatech_client/core/model/extension/iterable_extension.dart';
import 'package:volgatech_client/core/model/models/form_model.dart';
import 'package:volgatech_client/projects/model/entities/project.dart';
import 'package:volgatech_client/projects/model/project_api.dart';

class CreateEditProjectFormModel extends FormModel {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController responsibleController = TextEditingController();

  Map<BundleItemInfo, int> bundleMap = {};

  List<BundleItemInfo> bundleItemInfos = [];

  ProjectApi get api => appModel.projectModule.api;

  CreateEditProjectFormModel({
    required super.appModel,
    Project? project,
  }) {
    _prepareData(project);
    _loadBundleInfo(project);
  }

  void _prepareData(Project? project) async {
    if (project == null) {
      return;
    }

    nameController.text = project.name ?? "";
    descriptionController.text = project.description ?? "";
    responsibleController.text = project.responsible?.name ?? "";

    for (var element in project.bundleItems) {
      bundleMap[element] = element.count;
    }
  }

  /// Загрузка информации о компонентах проекта для возможности изменения их количества
  void _loadBundleInfo(Project? project) async {
    if (project == null) {
      return;
    }

    var list =
        (await appModel.bundleModule.api.loadBundleItemList()).result ?? [];
    for (var e in project.bundleItems) {
      var item = list.firstWhereOrNull(
        (x) => x.bundleItemInfoId == e.bundleItemInfoId,
      );
      if (item != null) {
        bundleItemInfos.add(item);
      }
    }
  }

  Future<ApiResponse<Project>> createProject() async {
    var response = await api.createProject(
      name: nameController.text,
      description: descriptionController.text,
      responsible: responsibleController.text,
      bundleItems: bundleMap,
    );
    return response;
  }

  Future<ApiResponse<Project>> editProject({
    required int projectId,
  }) async {
    var response = await api.editProject(
      projectId: projectId,
      name: nameController.text,
      description: descriptionController.text,
      responsible: responsibleController.text,
      bundleItems: bundleMap,
    );
    return response;
  }

  String? validateField(String? value) =>
      (value?.isEmpty ?? true) ? "Заполните поле" : null;
}
