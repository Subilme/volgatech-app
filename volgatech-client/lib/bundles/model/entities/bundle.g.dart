// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bundle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bundle _$BundleFromJson(Map<String, dynamic> json) => Bundle(
      bundleId: (json['bundleId'] as num).toInt(),
      bundleInfo: json['bundleInfo'] == null
          ? null
          : BundleInfo.fromJson(json['bundleInfo'] as Map<String, dynamic>),
      storage: json['storage'] == null
          ? null
          : Storage.fromJson(json['storage'] as Map<String, dynamic>),
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      bundleItems: (json['bundleItems'] as List<dynamic>?)
              ?.map((e) => BundleItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$BundleToJson(Bundle instance) => <String, dynamic>{
      'bundleId': instance.bundleId,
      'bundleInfo': instance.bundleInfo,
      'storage': instance.storage,
      'images': instance.images,
      'bundleItems': instance.bundleItems,
    };
