import 'package:logging_utils/logging_utils.dart';

part 'simple_class.g.dart';

@AutoLog(level: Level.FINER, methods: debugTraceLevels)
class SimpleClass {
  void test() {
    info('Test');
  }
}
