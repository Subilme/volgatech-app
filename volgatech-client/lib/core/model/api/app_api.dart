import 'package:volgatech_client/core/model/app_model.dart';

/// Класс для создания "утилитарных" классов API, которые могут быть
/// использованы по всему проекту, в любом модуле
class AppApi {
  final AppModel appModel;

  AppApi({required this.appModel});
}
