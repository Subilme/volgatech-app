import 'package:volgatech_client/core/model/events/event.dart';

class ProjectUpdatedEvent extends BaseEvent {
  ProjectUpdatedEvent(super.sender);
}

class ProjectDeletedEvent extends BaseEvent {
  ProjectDeletedEvent(super.sender);
}
