import 'package:volgatech_client/core/model/events/event.dart';

class CategoryUpdatedEvent extends BaseEvent {
  CategoryUpdatedEvent(super.sender);
}

class CategoryDeletedEvent extends BaseEvent {
  CategoryDeletedEvent(super.sender);
}
