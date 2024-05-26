// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      categoryId: (json['categoryId'] as num).toInt(),
      name: json['name'] as String,
      bundleInfos: (json['bundleInfos'] as List<dynamic>?)
              ?.map((e) => BundleInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'categoryId': instance.categoryId,
      'name': instance.name,
      'bundleInfos': instance.bundleInfos,
    };
