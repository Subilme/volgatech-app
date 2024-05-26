

import 'package:json_annotation/json_annotation.dart';

enum FunctionalType {
  @JsonValue(0)
  ready,
  @JsonValue(1)
  repair,
  @JsonValue(2)
  broken,
  @JsonValue(-1)
  unknown;

  @override
  String toString() {
    switch (this) {
      case FunctionalType.ready:
        return "Исправен";
      case FunctionalType.repair:
        return "В ремонте";
      case FunctionalType.broken:
        return "Не исправен";
      default:
        return "Нет информации";
    }
  }

  int? get value =>  switch (this) {
    FunctionalType.ready => 0,
    FunctionalType.repair => 1,
    FunctionalType.broken => 2,
    FunctionalType.unknown => -1,

  };
}