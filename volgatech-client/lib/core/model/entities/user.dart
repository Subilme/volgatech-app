import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

enum UserRole {
  @JsonValue(0)
  student,
  @JsonValue(1)
  laborant,
  @JsonValue(2)
  teacher,
  @JsonValue(-1)
  unknown;

  @override
  String toString() {
    switch (this) {
      case UserRole.student:
        return "Студент";
      case UserRole.laborant:
        return "Лаборант";
      case UserRole.teacher:
        return "Преподаватель";
      default:
        return "";
    }
  }

  static List<UserRole> getValues() => [
        UserRole.student,
        UserRole.laborant,
        UserRole.teacher,
      ];

  int get value => _$UserRoleEnumMap[this]!;
}

@JsonSerializable()
class User {
  int? userId;
  String? name;
  String? avatar;
  String? login;
  @JsonKey(
    defaultValue: UserRole.unknown,
    unknownEnumValue: UserRole.unknown,
  )
  UserRole userRole;

  User({
    this.userId,
    this.name,
    this.avatar,
    this.login,
    this.userRole = UserRole.unknown,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  bool get isEmptyProfile => name?.isEmpty ?? true;
}
