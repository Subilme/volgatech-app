import 'package:flutter/material.dart';
import 'package:volgatech_client/bundles/model/entities/bundle_item.dart';
import 'package:volgatech_client/bundles/model/entities/functional_type.dart';
import 'package:volgatech_client/storage/model/entities/storage.dart';
import 'package:volgatech_client/core/theme/theme_builder.dart';
import 'package:volgatech_client/core/view/extension/simple_padding_extension.dart';
import 'package:volgatech_client/projects/model/entities/project.dart';

class BundleItemTable extends StatelessWidget {
  final List<BundleItem> bundleItems;
  final List<Storage> storages;
  final List<Project> projects;
  final bool canEdit;
  final bool canMove;
  final Function(BundleItem, FunctionalType)? onTypeSelected;
  final Function(BundleItem, Project)? onProjectSelected;
  final Function(BundleItem, Storage)? onStorageChanged;

  const BundleItemTable({
    super.key,
    this.bundleItems = const [],
    this.storages = const [],
    this.projects = const [],
    this.canEdit = false,
    this.canMove = false,
    this.onTypeSelected,
    this.onProjectSelected,
    this.onStorageChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (bundleItems.isEmpty) return const SizedBox();

    return DataTable(
      showCheckboxColumn: false,
      headingRowColor: const MaterialStatePropertyAll<Color>(AppColors.grey),
      dataRowMinHeight: 60,
      dataRowMaxHeight: 60,
      columns: const [
        DataColumn(
          label: Text(
            "Номер",
            style: TextStyle(
              color: AppColors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "Состояние",
            style: TextStyle(
              color: AppColors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "Находится",
            style: TextStyle(
              color: AppColors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "Используется в проекте",
            style: TextStyle(
              color: AppColors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
      rows: bundleItems
          .map((e) => DataRow(
                cells: [
                  DataCell(
                    SizedBox(
                      width: 160,
                      height: 50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "#${e.bundleItemId.toString()}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (e.bundle != null)
                            const Expanded(
                              child: Text(
                                "Является частью набора. Нельзя изменить местоположение",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.red,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  DataCell(
                    PopupMenuButton<FunctionalType>(
                      initialValue: e.functionalType,
                      enabled: canEdit,
                      onSelected: (value) => onTypeSelected?.call(e, value),
                      itemBuilder: (BuildContext context) =>
                          FunctionalType.values
                              .map((e) => PopupMenuItem<FunctionalType>(
                                    value: e,
                                    child: Text(e.toString()),
                                  ))
                              .toList(),
                      offset: const Offset(-30, 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(e.functionalType.toString()).rightPadding(4),
                          if (canEdit) const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                  DataCell(
                    PopupMenuButton<Storage>(
                      initialValue: e.storage,
                      enabled: canMove && e.bundle == null,
                      onSelected: (value) => onStorageChanged?.call(e, value),
                      itemBuilder: (BuildContext context) => storages
                          .map((x) => PopupMenuItem<Storage>(
                                value: x,
                                child: Text(x.name),
                              ))
                          .toList(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            e.storage == null
                                ? "Нет информации"
                                : e.storage!.name,
                          ).rightPadding(4),
                          if (canMove && e.bundle == null)
                            const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                  DataCell(
                    PopupMenuButton<Project>(
                      initialValue: e.project,
                      enabled: canEdit,
                      onSelected: (value) => onProjectSelected?.call(e, value),
                      itemBuilder: (BuildContext context) => projects
                          .map((x) => PopupMenuItem<Project>(
                                value: x,
                                child: Text(x.name ?? "Проект #${x.projectId}"),
                              ))
                          .toList(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            e.project == null
                                ? "Не выбрано"
                                : e.project?.name ??
                                    "Проект #${e.project?.projectId}",
                          ).rightPadding(4),
                          if (canEdit) const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                ],
              ))
          .toList(),
    );
  }
}
