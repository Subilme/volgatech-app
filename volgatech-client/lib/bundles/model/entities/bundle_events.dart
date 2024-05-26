import 'package:volgatech_client/core/model/events/event.dart';

class BundleUpdatedEvent extends BaseEvent {
  BundleUpdatedEvent(super.sender);
}

class BundleDeletedEvent extends BaseEvent {
  BundleDeletedEvent(super.sender);
}

class BundleItemUpdatedEvent extends BaseEvent {
  BundleItemUpdatedEvent(super.sender);
}

class BundleItemDeletedEvent extends BaseEvent {
  BundleItemDeletedEvent(super.sender);
}
