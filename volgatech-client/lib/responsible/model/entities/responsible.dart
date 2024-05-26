import 'package:json_annotation/json_annotation.dart';

part 'responsible.g.dart';

@JsonSerializable()
class Responsible {
  final int responsibleId;
  final String name;

  Responsible({
    required this.responsibleId,
    required this.name,
  });

  factory Responsible.fromJson(Map<String, dynamic> json) =>
      _$ResponsibleFromJson(json);

  Map<String, dynamic> toJson() => _$ResponsibleToJson(this);
}
