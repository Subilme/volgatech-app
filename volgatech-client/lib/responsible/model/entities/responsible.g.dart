// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'responsible.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Responsible _$ResponsibleFromJson(Map<String, dynamic> json) => Responsible(
      responsibleId: (json['responsibleId'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$ResponsibleToJson(Responsible instance) =>
    <String, dynamic>{
      'responsibleId': instance.responsibleId,
      'name': instance.name,
    };
