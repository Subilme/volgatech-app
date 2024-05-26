import 'package:json_annotation/json_annotation.dart';

part 'storage.g.dart';

@JsonSerializable()
class Storage {
  final int storageId;
  final Storage? parentStorage;
  final bool hasSubstorages;
  final String name;

  Storage({
    required this.storageId,
    this.parentStorage,
    this.hasSubstorages = false,
    required this.name,
  });

  factory Storage.fromJson(Map<String, dynamic> json) =>
      _$StorageFromJson(json);

  Map<String, dynamic> toJson() => _$StorageToJson(this);
}
