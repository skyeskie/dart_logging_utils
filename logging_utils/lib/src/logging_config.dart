import 'package:logging/logging.dart';
import 'package:logging_utils/logging_utils.dart';
import 'package:meta/meta.dart';

class LoggingConfig {
  LoggingConfig({
    Level? debugLevel,
    Level? releaseLevel,

    ///TODO: Rather than the root logger, set for the package name
    bool setLevelsAsGlobal = true,

    /// This is used to test for if we are in a debug environment
    /// If using flutter, use [kDebugMode]
    ///
    /// Otherwise, see [debugInEnvironment] for environment declarations
    /// (https://dart.dev/guides/environment-declarations)
    required this.debugLevelCallback,

    /// Level overrides for specific Loggers
    /// Note: if you use generators, make sure the prefixes are correct
    /// Additionally, [hierarchicalLoggingEnabled] is true, so you can configure
    /// level per package or directory
    Map<String, Level> levelOverrides = const {},
  })  : debugLevel = debugLevel ?? releaseLevel ?? Level.FINER,
        releaseLevel = releaseLevel ?? debugLevel ?? Level.WARNING {
    for (final MapEntry(:key, :value) in levelOverrides.entries) {
      Logger(key).level = value;
    }
  }

  final log = Logger('logging_utils.LoggingConfig');

  bool Function() debugLevelCallback;

  bool _rootConfigured = false;

  /// Set root level threshold for logging when in debug mode
  /// If omitted, this falls back to [releaseLevel] then [Level.warning]
  ///
  /// This is not applied until [configureRoot] is run
  final Level debugLevel;

  /// Set root level threshold for logging when in release mode
  /// If omitted, this falls back to [debugLevel] then [Level.warning]
  ///
  /// This is not applied until [configureRoot] is run
  final Level releaseLevel;

  /// Setup logging for the entire application.
  /// Call this as early as possible.
  @mustCallSuper
  void configureRoot() {
    if (_rootConfigured) {
      Logger('logging_utils.LoggingConfig').warning('Root already configured');
    }
    hierarchicalLoggingEnabled = true;
    Logger.root.level = debugLevelCallback() ? debugLevel : releaseLevel;
    _rootConfigured = true;
  }

  void setRootLevel(Level level) => Logger.root.level = level;

  static bool debugInEnvironment() => const bool.hasEnvironment('DEBUG');
}
