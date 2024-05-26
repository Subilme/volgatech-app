import 'package:volgatech_client/core/model/app_component.dart';
import 'package:hive/hive.dart';

/// Компонент для хранения данных вида "ключ"->"значение" офлайн.
/// Обычно, здесь хранят небольшие данные, которые должны быть
class KeyValueStorage with AppComponent {
  static String name = "KeyValueStorage";
  late Box _box;

  KeyValueStorage();

  @override
  Future<void> initComponent() async {
    await super.initComponent();
    _box = await Hive.openBox(
      name,
      compactionStrategy: (entries, deletedEntries) {
        return (deletedEntries > 30) || (entries > 50);
      },
    );
  }

  Box get box {
    return _box;
  }

  String? getStringForKey(String key) {
    String? value = box.get(key);
    return value;
  }

  Future<void> setStringForKey(String key, String? value) async {
    await box.put(key, value);
  }

  List<String>? getStringListForKey(String key) {
    List<String>? value = box.get(key);
    if (value == null) {
      return null;
    }
    return value.reversed.toList();
  }

  Future<void> setStringListForKey(String key, List<String> value) async {
    await box.put(key, value);
  }

  Future<void> appendStringListItemForKey(String key, String value) async {
    var listValue = getStringListForKey(key);
    listValue ??= <String>[];
    listValue.add(value);
    setStringListForKey(key, listValue);
  }

  Future<void> appendUniqueStringListItemForKey(
      String key, String value) async {
    if (value.length < 3) {
      return;
    }
    var listValue = getStringListForKey(key);
    listValue ??= <String>[];
    if (listValue.length > 1 &&
        value.contains(listValue.last) &&
        listValue.last.length < value.length) {
      listValue.removeLast();
    }
    listValue.remove(value);
    listValue.add(value);
    setStringListForKey(key, listValue);
  }

  bool getBoolValueForKey(String key) {
    bool value = box.get(key) ?? false;
    return value;
  }

  Future<void> setBoolValueForKey(String key, bool value) async {
    await box.put(key, value);
  }

  Future<void> removeValueForKey(String key) async {
    await box.delete(key);
  }
}
