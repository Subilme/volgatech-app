import 'package:json_annotation/json_annotation.dart';
import 'package:volgatech_client/bundles/model/entities/bundle.dart';
import 'package:volgatech_client/bundles/model/entities/bundle_item_info.dart';
import 'package:volgatech_client/category/model/entities/category.dart';
import 'package:volgatech_client/core/model/entities/selectable.dart';

part 'bundle_info.g.dart';

@JsonSerializable()
class BundleInfo extends ISelectable {
  final int bundleInfoId;
  final String? name;
  final int count;
  final String? description;
  final Category? category;
  final List<BundleItemInfo> bundleItemInfos;
  final List<Bundle> bundles;
  final List<String> images;

  BundleInfo({
    required this.bundleInfoId,
    this.name,
    this.count = 0,
    this.description,
    this.category,
    this.bundleItemInfos = const [],
    this.bundles = const [],
    this.images = const [],
  });

  factory BundleInfo.fromJson(Map<String, dynamic> json) =>
      _$BundleInfoFromJson(json);

  Map<String, dynamic> toJson() => _$BundleInfoToJson(this);

  @override
  int get id => bundleInfoId;

  @override
  String? get title => name;
}
