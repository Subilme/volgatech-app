import 'package:volgatech_client/core/model/events/event.dart';

class LogoutEvent extends BaseEvent {
  LogoutEvent(super.sender);
}

class LoginEvent extends BaseEvent {
  LoginEvent(super.sender);
}

class InvalidAccessToken extends BaseEvent {
  InvalidAccessToken(super.sender);
}
