// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bundle_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BundleItem _$BundleItemFromJson(Map<String, dynamic> json) => BundleItem(
      bundleItemId: (json['bundleItemId'] as num).toInt(),
      bundleItemInfo: json['bundleItemInfo'] == null
          ? null
          : BundleItemInfo.fromJson(
              json['bundleItemInfo'] as Map<String, dynamic>),
      functionalType: $enumDecodeNullable(
              _$FunctionalTypeEnumMap, json['functionalType'],
              unknownValue: FunctionalType.unknown) ??
          FunctionalType.unknown,
      project: json['project'] == null
          ? null
          : Project.fromJson(json['project'] as Map<String, dynamic>),
      storage: json['storage'] == null
          ? null
          : Storage.fromJson(json['storage'] as Map<String, dynamic>),
      bundle: json['bundle'] == null
          ? null
          : Bundle.fromJson(json['bundle'] as Map<String, dynamic>),
      unavailableReason: json['unavailableReason'] as String?,
    );

Map<String, dynamic> _$BundleItemToJson(BundleItem instance) =>
    <String, dynamic>{
      'bundleItemId': instance.bundleItemId,
      'bundleItemInfo': instance.bundleItemInfo,
      'functionalType': _$FunctionalTypeEnumMap[instance.functionalType]!,
      'project': instance.project,
      'storage': instance.storage,
      'bundle': instance.bundle,
      'unavailableReason': instance.unavailableReason,
    };

const _$FunctionalTypeEnumMap = {
  FunctionalType.ready: 0,
  FunctionalType.repair: 1,
  FunctionalType.broken: 2,
  FunctionalType.unknown: -1,
};
