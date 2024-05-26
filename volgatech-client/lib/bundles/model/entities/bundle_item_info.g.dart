// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bundle_item_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BundleItemInfo _$BundleItemInfoFromJson(Map<String, dynamic> json) =>
    BundleItemInfo(
      bundleItemInfoId: (json['bundleItemInfoId'] as num).toInt(),
      name: json['name'] as String?,
      count: (json['count'] as num?)?.toInt() ?? 0,
      description: json['description'] as String?,
      bundleItems: (json['bundleItems'] as List<dynamic>?)
              ?.map((e) => BundleItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$BundleItemInfoToJson(BundleItemInfo instance) =>
    <String, dynamic>{
      'bundleItemInfoId': instance.bundleItemInfoId,
      'name': instance.name,
      'count': instance.count,
      'description': instance.description,
      'bundleItems': instance.bundleItems,
    };
