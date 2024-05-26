// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Storage _$StorageFromJson(Map<String, dynamic> json) => Storage(
      storageId: (json['storageId'] as num).toInt(),
      parentStorage: json['parentStorage'] == null
          ? null
          : Storage.fromJson(json['parentStorage'] as Map<String, dynamic>),
      hasSubstorages: json['hasSubstorages'] as bool? ?? false,
      name: json['name'] as String,
    );

Map<String, dynamic> _$StorageToJson(Storage instance) => <String, dynamic>{
      'storageId': instance.storageId,
      'parentStorage': instance.parentStorage,
      'hasSubstorages': instance.hasSubstorages,
      'name': instance.name,
    };
