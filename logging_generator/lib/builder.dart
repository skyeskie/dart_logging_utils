library logging_generator;

import 'package:build/build.dart';
import 'package:logging_generator/src/auto_log_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder makeAutoLogBuilder(BuilderOptions options) => SharedPartBuilder(
      [AutoLogGenerator()],
      'auto_log_builder',
    );

Builder autoLogAsPart(BuilderOptions options) =>
    PartBuilder([AutoLogGenerator()], '.log.dart');
