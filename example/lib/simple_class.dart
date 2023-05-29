import 'package:logging_utils/logging_utils.dart';

part 'simple_class.g.dart';

@AutoLog()
class SimpleClass {
  void test() {
    info('Test');
  }
}
