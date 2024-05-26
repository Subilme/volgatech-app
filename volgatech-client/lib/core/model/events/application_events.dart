import 'package:volgatech_client/core/model/events/event.dart';

class ApplicationPausedEvent extends BaseEvent {
  ApplicationPausedEvent(super.sender);
}

class ApplicationResumeEvent extends BaseEvent {
  ApplicationResumeEvent(super.sender);
}

class ReloadApplication extends BaseEvent {
  ReloadApplication(super.sender);
}

class NetworkConnectionRestored extends BaseEvent {
  NetworkConnectionRestored(super.sender);
}

class NetworkConnectionSwitch extends BaseEvent {
  NetworkConnectionSwitch(super.sender);
}

class LostNetworkConnection extends BaseEvent {
  LostNetworkConnection(super.sender);
}
