import 'package:volgatech_client/core/model/app_component.dart';
import 'package:volgatech_client/core/model/app_model.dart';
import 'package:provider/single_child_widget.dart';

/// Базовый класс для любого модуля приложения.
///
/// Обычно каждый модуль:
/// * создает постоянные модели для использования в модуле: API, классы бизнес-логики и т.д.
/// * создает классы с роутингом по модулю
/// * обрабатывает PUSH уведомления [processPushData]
/// * обработывает WebSocket уведомления (предназначены для онлайн обновления данных) [processWebSocketData]
///
/// Типовая структура папки модуля (<module_name>):
/// * в папке модуля "<module_name>" располагаются экраны модуля
/// * папка "<module_name>/module" содержит стандартные файлы модуля: класс-модуль, роутинг (экраны) для навигации по модулю
/// * папка "<module_name>/model" содержит модели: сущности, API, ViewModel, бизнес-логика и т.д.
/// * папка "<module_name>/view" содержит виджеты - представления: ячейки списков, визуальные виджеты - компоненты и т.д.
abstract class BaseAppModule with AppComponent {
  late final AppModel appModel;

  BaseAppModule({
    required this.appModel,
  });

  List<SingleChildWidget>? getProviders() => null;
}
