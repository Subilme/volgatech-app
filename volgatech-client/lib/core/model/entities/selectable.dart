import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
abstract class ISelectable {
  @JsonKey(
    includeFromJson: false,
    includeToJson: false,
  )
  dynamic id;
  @JsonKey(
    includeFromJson: false,
    includeToJson: false,
  )
  String? title;
  @JsonKey(
    includeFromJson: false,
    includeToJson: false,
  )
  String? image;
}
