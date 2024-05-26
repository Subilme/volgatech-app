import 'package:json_annotation/json_annotation.dart';
import 'package:volgatech_client/bundles/model/entities/bundle_item.dart';
import 'package:volgatech_client/core/model/entities/selectable.dart';

part 'bundle_item_info.g.dart';

@JsonSerializable()
class BundleItemInfo extends ISelectable {
  final int bundleItemInfoId;
  final String? name;
  final int count;
  final String? description;
  final List<BundleItem> bundleItems;

  BundleItemInfo({
    required this.bundleItemInfoId,
    this.name,
    this.count = 0,
    this.description,
    this.bundleItems = const [],
  });

  factory BundleItemInfo.fromJson(Map<String, dynamic> json) =>
      _$BundleItemInfoFromJson(json);

  Map<String, dynamic> toJson() => _$BundleItemInfoToJson(this);

  @override
  int get id => bundleItemInfoId;

  @override
  String? get title => name;

  @override
  bool operator ==(Object other) =>
      other is BundleItemInfo && bundleItemInfoId == other.bundleItemInfoId;

  @override
  int get hashCode => bundleItemInfoId;
}
