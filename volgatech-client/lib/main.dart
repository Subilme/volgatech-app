import 'dart:async';

import 'package:flutter/material.dart';
import 'package:volgatech_client/core/application.dart';

void main() async {
  runZonedGuarded(
    () => runApp(const Application()),
    (error, stack) => print("ERROR: $error"),
  );
}
