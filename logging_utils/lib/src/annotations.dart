import 'package:logging/logging.dart';

import 'constants.dart';

class AutoLog {
  const AutoLog({
    this.level,
    this.methods = LoggingSets.loggingDefault,
  });

  final Level? level;
  final List<Level> methods;
}

const autoLog = AutoLog();
