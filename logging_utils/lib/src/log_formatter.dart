import 'package:ansi_codes/ansi_codes.dart';
import 'package:logging/logging.dart';

class LogFormatter {
  LogFormatter({
    this.loggerLength = 40,
    this.colorMap = const {},
    this.parseLevel = defaultLevelString,
  });

  final int loggerLength;
  final Map<Level, (String, String)> colorMap;
  String Function(Level) parseLevel;

  String call(LogRecord record) {
    return [
      colorMap[record.level]?.$1 ?? '',
      record.time.toIso8601String().split('T').last,
      ' [',
      parseLevel(record.level),
      '] ',
      record.loggerName.fromRight(loggerLength),
      ' - ',
      record.message,
      colorMap[record.level]?.$2 ?? '',
    ].join('');
  }

  static String defaultLevelString(Level level) => level.name.padRight(5);

  static Map<Level, (String, String)> defaultMap = {
    Level.SHOUT: _parse(
      AnsiCodes().bgRed,
      AnsiCodes().whiteBright,
      AnsiCodes().bold,
    ),
    Level.SEVERE: _parse(AnsiCodes().redBright, AnsiCodes().bold),
    Level.WARNING: _parse(AnsiCodes().yellow, AnsiCodes().bold),
    Level.INFO: _parse(AnsiCodes().blue),
    Level.CONFIG: _parse(AnsiCodes().cyan),
    Level.FINE: _parse(AnsiCodes().white),
    Level.FINER: _parse(AnsiCodes().grey),
    Level.FINEST: _parse(AnsiCodes().grey, AnsiCodes().italic),
  };

  static (String, String) _parse(
    AnsiCode code, [
    AnsiCode? code2,
    AnsiCode? code3,
  ]) {
    final openStr = code.open + _open(code2) + _open(code3);
    final closeStr = code.close + _close(code2) + _close(code3);
    return (openStr, closeStr);
  }
}

String _open(AnsiCode? code) => code?.open ?? '';

String _close(AnsiCode? code) => code?.close ?? '';

extension RightSlice on String {
  String fromRight(int len) =>
      length < len ? padLeft(len) : substring(length - len);
}
