library scratch_flutter.logging.builder;

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:logging_utils/logging_utils.dart';
import 'package:source_gen/source_gen.dart';

Builder makeAutoLogBuilder(BuilderOptions options) => SharedPartBuilder(
      [AutoLogGenerator()],
      'auto_log_builder',
    );

Builder autoLogAsPart(BuilderOptions options) =>
    PartBuilder([AutoLogGenerator()], '.log.dart');

class AutoLogGenerator extends GeneratorForAnnotation<AutoLog> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element.kind != ElementKind.CLASS) return '';
    final output = StringBuffer();
    final prefix = element.location?.components.first
            .replaceAll('/', '.')
            .replaceAll('package:', '')
            .replaceAll('.dart', '') ??
        '';
    // final ClassElement c = element as ClassElement;
    final loggingMixin = Mixin((b) => b
      ..name = '_Log${element.name}'
      ..methods.addAll([
        Method((m) => m
          ..name = 'logFatal'
          ..body = const Code('_log.info("FOO")')
          ..returns = refer('void')
          ..lambda = true)
      ])
      ..fields.addAll([
        Field(
          (f) => f
            ..name = '_log'
            ..assignment = Code(
              "Logger('$prefix.${element.name}')",
            )
            ..modifier = FieldModifier.final$
            // ..docs.add(element.location?.components.join('|') ?? '')
            ..type = refer('Logger', 'package:logging/logging.dart'),
        ),
      ]));
    final emitter = DartEmitter(useNullSafetySyntax: true);

    output.writeln(DartFormatter().format('${loggingMixin.accept(emitter)}'));

    return output.toString();
  }
}
