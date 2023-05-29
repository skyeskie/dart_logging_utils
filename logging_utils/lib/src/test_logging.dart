import 'dart:async';

import 'package:logging/logging.dart';

import 'log_formatter.dart';

//TODO: Temporary until figure out test importing
void setUp(void Function() function) {}

void tearDown(void Function() function) {}

void printOnFailure(Object? object) {}

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
