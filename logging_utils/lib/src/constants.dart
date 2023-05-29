import 'package:logging/logging.dart';

class LoggingSets {
  static const loggingDefault = [
    Level.FINEST,
    Level.FINER,
    Level.FINE,
    Level.CONFIG,
    Level.INFO,
    Level.WARNING,
    Level.SEVERE,
    Level.SHOUT,
  ];

  static const debugTraceFatal = [
    Level('FATAL', 1200),
    Level('ERROR', 1000),
    Level('WARN', 900),
    Level.INFO,
    Level('CFG', 700),
    Level('DEBUG', 500),
    Level('FINER', 400),
    Level('TRACE', 300),
  ];
}
