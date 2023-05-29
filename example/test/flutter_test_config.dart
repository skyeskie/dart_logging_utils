import 'dart:async';

import 'package:logging_generator/test_logging.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  initTestLogging();

  return testMain();
}
