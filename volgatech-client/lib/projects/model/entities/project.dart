import 'package:json_annotation/json_annotation.dart';
import 'package:volgatech_client/bundles/model/entities/bundle_item_info.dart';
import 'package:volgatech_client/core/model/entities/selectable.dart';
import 'package:volgatech_client/responsible/model/entities/responsible.dart';

part 'project.g.dart';

@JsonSerializable()
class Project extends ISelectable {
  final int projectId;
  final String? name;
  final String? description;
  final Responsible? responsible;
  final List<BundleItemInfo> bundleItems;

  Project({
    required this.projectId,
    this.name,
    this.description,
    this.responsible,
    this.bundleItems = const [],
  });

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectToJson(this);

  @override
  int? get id => projectId;

  @override
  String? get title => name;
}
