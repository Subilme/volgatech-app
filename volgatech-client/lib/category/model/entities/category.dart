import 'package:json_annotation/json_annotation.dart';
import 'package:volgatech_client/bundles/model/entities/bundle_info.dart';
import 'package:volgatech_client/core/model/entities/selectable.dart';

part 'category.g.dart';

@JsonSerializable()
class Category extends ISelectable {
  final int categoryId;
  final String name;
  final List<BundleInfo> bundleInfos;

  Category({
    required this.categoryId,
    required this.name,
    this.bundleInfos = const [],
  });

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  @override
  int get id => categoryId;

  @override
  String? get title => name;
}
