import 'package:logging_utils/logging_utils.dart';

/// Basic logging configuration (suitable for generation/overrides)
/// that directly contains the functions to format and output logs
abstract class LoggingConfigBasic extends LoggingConfig {
  LoggingConfigBasic({
    super.debugLevel,
    super.releaseLevel,
    super.isDebugLogging,
    super.levelOverrides,
    super.setLevelsAsGlobal,
  });

  String formatLogRecord(LogRecord record);

  void outputLogLine(String formattedLogLine);

  @override
  void configureRoot() {
    super.configureRoot();
    Logger.root.onRecord.listen(
      (event) => outputLogLine(
        formatLogRecord(event),
      ),
    );
  }
}
