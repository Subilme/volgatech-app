// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Project _$ProjectFromJson(Map<String, dynamic> json) => Project(
      projectId: (json['projectId'] as num).toInt(),
      name: json['name'] as String?,
      description: json['description'] as String?,
      responsible: json['responsible'] == null
          ? null
          : Responsible.fromJson(json['responsible'] as Map<String, dynamic>),
      bundleItems: (json['bundleItems'] as List<dynamic>?)
              ?.map((e) => BundleItemInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
      'projectId': instance.projectId,
      'name': instance.name,
      'description': instance.description,
      'responsible': instance.responsible,
      'bundleItems': instance.bundleItems,
    };
