// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      userId: (json['userId'] as num?)?.toInt(),
      name: json['name'] as String?,
      avatar: json['avatar'] as String?,
      login: json['login'] as String?,
      userRole: $enumDecodeNullable(_$UserRoleEnumMap, json['userRole'],
              unknownValue: UserRole.unknown) ??
          UserRole.unknown,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userId': instance.userId,
      'name': instance.name,
      'avatar': instance.avatar,
      'login': instance.login,
      'userRole': _$UserRoleEnumMap[instance.userRole]!,
    };

const _$UserRoleEnumMap = {
  UserRole.student: 0,
  UserRole.laborant: 1,
  UserRole.teacher: 2,
  UserRole.unknown: -1,
};
