import 'package:logging_utils/logging_utils.dart';

class AutoLog {
  const AutoLog({
    this.level,
    this.methods = LoggingSets.loggingDefault,
  });

  final Level? level;
  final List<Level> methods;
}

class AutoLogConfig {
  const AutoLogConfig({
    this.configClassName = '\$LoggingConfig',
    this.levels = const [],
    this.logFormatter = defaultLogFormatter,
    this.logPrinter = print,
    this.debugLevelCallback,
    this.debugLevel = Level.FINER,
    this.releaseLevel = Level.WARNING,
    this.levelOverrides = const {},
  });

  final String configClassName;

  final Level debugLevel;
  final Level releaseLevel;

  final List<Level> levels;

  final Map<String, Level> levelOverrides;

  final void Function(String) logPrinter;
  final String Function(LogRecord) logFormatter;

  /// Sets debug callback. Default depends on presence of Flutter
  /// If Flutter, [kDebugMode], else [LoggingConfig.debugInEnvironment]
  final bool Function()? debugLevelCallback;

  static String defaultLogFormatter(LogRecord record) => record.toString();
}

class LogPart {
  LogPart(this.token, [this.custom]);

  final LogPartType token;
  final String? custom;
}

enum LogPartType {
  level(), //Level
  message(), //String
  object(), //Object?
  loggerName(), //String
  time(), //DateTime
  sequenceNumber(), //int
  error(), // Object?
  stackTrace(), // StackTrace?
  zone(), // Zone?
  text();
}
