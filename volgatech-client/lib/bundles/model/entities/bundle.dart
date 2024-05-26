import 'package:json_annotation/json_annotation.dart';
import 'package:volgatech_client/bundles/model/entities/bundle_item.dart';
import 'package:volgatech_client/bundles/model/entities/bundle_info.dart';
import 'package:volgatech_client/storage/model/entities/storage.dart';
import 'package:volgatech_client/core/model/entities/selectable.dart';

part 'bundle.g.dart';

@JsonSerializable()
class Bundle extends ISelectable {
  final int bundleId;
  final BundleInfo? bundleInfo;
  Storage? storage;
  final List<String> images;
  final List<BundleItem> bundleItems;

  Bundle({
    required this.bundleId,
    this.bundleInfo,
    this.storage,
    this.images = const [],
    this.bundleItems = const [],
  });

  factory Bundle.fromJson(Map<String, dynamic> json) => _$BundleFromJson(json);

  Map<String, dynamic> toJson() => _$BundleToJson(this);

  @override
  int get id => bundleId;

  @override
  String? get title => bundleInfo?.name;
}
