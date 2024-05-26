import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:volgatech_client/core/model/app_component.dart';
import 'package:volgatech_client/core/model/events/application_events.dart';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/foundation.dart';

/// Компонент для мониторинга наличия/отстутсвия интернета.
class InternetMonitor extends ValueNotifier<bool> with AppComponent {
  late final StreamSubscription _connectivitySubscription;

  /// For mock
  late Connectivity connectivity;
  final EventBus eventBus;
  List<ConnectivityResult> previousConnection = [ConnectivityResult.none];

  InternetMonitor({
    Connectivity? connectivity,
    required this.eventBus,
  }) : super(true) {
    this.connectivity = connectivity ?? Connectivity();
    subscribeToInternetConnectivity();
  }

  @override
  Future<void> initComponent() async {
    await checkConnection();
    await super.initComponent();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<List<ConnectivityResult>> checkConnection() async {
    var connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet)) {
      value = true;
    } else {
      value = false;
    }
    return connectivityResult;
  }

  void subscribeToInternetConnectivity() {
    _connectivitySubscription = connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> result) {
        if (result.contains(ConnectivityResult.wifi)) {
          value = true;
          eventBus.fire(NetworkConnectionRestored(this));
        } else {
          value = false;
          eventBus.fire(LostNetworkConnection(this));
        }
        if (!result.contains(ConnectivityResult.none)) {
          previousConnection = result;
        }
      },
    );
  }
}
