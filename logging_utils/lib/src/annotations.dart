import 'package:logging/logging.dart';

const defaultLoggingLevels = Level.LEVELS;

const debugTraceLevels = [
  Level('FATAL', 1200),
  Level('ERROR', 1000),
  Level('WARN', 900),
  Level.INFO,
  Level('CFG', 700),
  Level('DEBUG', 500),
  Level('FINER', 400),
  Level('TRACE', 300),
];

class AutoLog {
  const AutoLog({
    this.level,
    this.methods = defaultLoggingLevels,
  });

  final Level? level;
  final List<Level> methods;
}

const autoLog = AutoLog();
