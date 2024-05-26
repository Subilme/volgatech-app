import 'package:flutter/material.dart';
import 'package:volgatech_client/bundles/model/entities/bundle.dart';
import 'package:volgatech_client/core/theme/theme_builder.dart';
import 'package:volgatech_client/core/view/extension/simple_padding_extension.dart';
import 'package:volgatech_client/storage/model/entities/storage.dart';

class BundleItemTable extends StatelessWidget {
  final List<Bundle> bundles;
  final List<Storage> storages;
  final bool canMove;
  final Function(Bundle, Storage)? onStorageChanged;

  const BundleItemTable({
    super.key,
    this.bundles = const [],
    this.storages = const [],
    this.canMove = false,
    this.onStorageChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (bundles.isEmpty) return const SizedBox();

    return DataTable(
      showCheckboxColumn: false,
      headingRowColor: const MaterialStatePropertyAll<Color>(AppColors.grey),
      columns: const [
        DataColumn(
          label: Center(
            child: Text(
              "Номер",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        DataColumn(
          label: Center(
            child: Text(
              "Находится",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
      rows: bundles
          .map((e) => DataRow(
                cells: [
                  DataCell(
                    Text(
                      "#${e.bundleId.toString()}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  DataCell(
                    PopupMenuButton<Storage>(
                      initialValue: e.storage,
                      enabled: canMove,
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
                          if (canMove) const Icon(Icons.arrow_drop_down),
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
