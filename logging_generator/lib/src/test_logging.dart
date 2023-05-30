import 'dart:async';

import 'package:logging_utils/logging_utils.dart';
import 'package:test/scaffolding.dart';

//TODO: Make this an extension of/on LoggingConfig
void initTestLogging() {
  final testLoggingListeners = <Zone, StreamSubscription>{};
  final testLoggingBuffers = <Zone, StringBuffer>{};

  final formatter = LogFormatter(
    colorMap: LogFormatter.defaultMap,
    parseLevel: (level) => level.name.substring(0, 4),
  );
  setUp(() {
    Logger.root.level = Level.FINEST;
    final zone = Zone.current.parent?.parent;
    if (zone != null) {
      final buffer = StringBuffer();
      testLoggingBuffers[zone] = buffer;
      final sub = Logger.root.onRecord.listen((event) {
        if (event.level >= Level.SEVERE) {
          // ignore: avoid_print
          print(formatter(event));
        }
        buffer.writeln(formatter(event));
      });
      testLoggingBuffers[zone] = buffer;
      testLoggingListeners[zone] = sub;
    }
  });

  tearDown(() {
    final zone = Zone.current.parent?.parent?.parent;
    testLoggingListeners.remove(zone)?.cancel();
    final buffer = testLoggingBuffers.remove(zone);
    if (buffer != null) printOnFailure(buffer.toString());
  });
}
