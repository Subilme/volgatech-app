import 'package:json_annotation/json_annotation.dart';
import 'package:volgatech_client/bundles/model/entities/bundle.dart';
import 'package:volgatech_client/bundles/model/entities/bundle_item_info.dart';
import 'package:volgatech_client/bundles/model/entities/functional_type.dart';
import 'package:volgatech_client/storage/model/entities/storage.dart';
import 'package:volgatech_client/core/model/api/custom_json_formatters.dart';
import 'package:volgatech_client/projects/model/entities/project.dart';

part 'bundle_item.g.dart';

@JsonSerializable()
@BoolJsonConverter()
class BundleItem {
  final int bundleItemId;
  final BundleItemInfo? bundleItemInfo;
  @JsonKey(
    defaultValue: FunctionalType.unknown,
    unknownEnumValue: FunctionalType.unknown,
  )
  FunctionalType functionalType;
  Project? project;
  Storage? storage;
  Bundle? bundle;
  final String? unavailableReason;

  BundleItem({
    required this.bundleItemId,
    this.bundleItemInfo,
    required this.functionalType,
    this.project,
    this.storage,
    this.bundle,
    this.unavailableReason,
  });

  factory BundleItem.fromJson(Map<String, dynamic> json) =>
      _$BundleItemFromJson(json);

  Map<String, dynamic> toJson() => _$BundleItemToJson(this);
}
