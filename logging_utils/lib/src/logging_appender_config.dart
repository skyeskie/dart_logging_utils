import 'package:logging/logging.dart';
import 'package:logging_appenders/logging_appenders.dart';
import 'package:logging_utils/src/logging_config.dart';

class LoggingAppenderConfig extends LoggingConfig {
  LoggingAppenderConfig({
    required this.logAppender,
    this.stdErrLevel = Level.WARNING,
    super.debugLevel,
    required super.debugLevelCallback,
    super.releaseLevel,
    super.levelOverrides,
  });

  final BaseLogAppender logAppender;
  final Level stdErrLevel;

  LogRecordFormatter get formatter => logAppender.formatter;

  @override
  void configureRoot() {
    super.configureRoot();
    final _ = switch (logAppender.runtimeType) {
      PrintAppender => PrintAppender.setupLogging(stderrLevel: stdErrLevel),
      _ => logAppender.attachToLogger(Logger.root),
    };
  }
}
