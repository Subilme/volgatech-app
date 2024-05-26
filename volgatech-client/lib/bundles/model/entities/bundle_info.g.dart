// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bundle_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BundleInfo _$BundleInfoFromJson(Map<String, dynamic> json) => BundleInfo(
      bundleInfoId: (json['bundleInfoId'] as num).toInt(),
      name: json['name'] as String?,
      count: (json['count'] as num?)?.toInt() ?? 0,
      description: json['description'] as String?,
      category: json['category'] == null
          ? null
          : Category.fromJson(json['category'] as Map<String, dynamic>),
      bundleItemInfos: (json['bundleItemInfos'] as List<dynamic>?)
              ?.map((e) => BundleItemInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      bundles: (json['bundles'] as List<dynamic>?)
              ?.map((e) => Bundle.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$BundleInfoToJson(BundleInfo instance) =>
    <String, dynamic>{
      'bundleInfoId': instance.bundleInfoId,
      'name': instance.name,
      'count': instance.count,
      'description': instance.description,
      'category': instance.category,
      'bundleItemInfos': instance.bundleItemInfos,
      'bundles': instance.bundles,
      'images': instance.images,
    };
