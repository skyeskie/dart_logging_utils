import 'package:logging/logging.dart';

class LevelX extends Level {
  const LevelX(super.name, super.value, {String? methodName})
      : _methodName = methodName;

  final String? _methodName;

  String get methodName => _methodName ?? name.toLowerCase();
}

extension ToLevelX on Level {
  LevelX toLevelX() => LevelX(name, value);
}
