library scratch_flutter.logging.builder;

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:logging_utils/logging_utils.dart';
import 'package:source_gen/source_gen.dart';

// References for builder script

// Types
final tLogger = refer('Logger', 'package:logging/logging.dart');
final tLevel = refer('Level', 'package:logging/logging.dart');

extension RefExt on Type {
  Reference get reference => refer(toString());
}

class AutoLogGenerator extends GeneratorForAnnotation<AutoLog> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element.kind != ElementKind.CLASS) return '';
    assert(element.name != null);
    final output = StringBuffer();
    final prefix = element.location?.components.first
            .replaceAll('/', '.')
            .replaceAll('package:', '')
            .replaceAll('.dart', '') ??
        '';

    final levels = annotation.read('methods').listValue;

    final loggingExtension = Extension(
      (ext) => ext
        ..name = '_\$Log${element.name}'
        ..on = refer(element.name!)
        ..fields.addAll([
          Field(
            (f) => f
              ..static = true
              ..name = 'LOGGER'
              ..assignment = Code(
                "Logger('$prefix.${element.name}')",
              )
              ..type = refer('Logger', 'package:logging/logging.dart'),
          ),
        ])
        ..methods.addAll([
          Method.returnsVoid(
            (m) => m
              ..name = 'log'
              ..returns = tLogger
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = 'level'
                    ..type = tLevel,
                ),
                Parameter(
                  (p) => p
                    ..name = 'message'
                    ..type = refer('Object?'),
                ),
              ])
              ..docs.addAll([
                '/// Log [message] at [level]',
                '/// Exceptions are upgraded to 1000 level',
                '/// Errors are upgraded to 1200 level',
              ])
              ..lambda = true
              ..body = Code('''
              switch(message) {
                (Error e) => LOGGER.log(Level.SHOUT, message, e, e.stackTrace),
                (Exception e) => LOGGER.log(Level.SEVERE, message),
                _ => LOGGER.log(level, message),
              }
              '''),
          ),
          ...levels.map(_makeLevelMethod)
        ]),
    );

    final emitter = DartEmitter(useNullSafetySyntax: true);

    output.writeln(DartFormatter().format(
      '// ignore_for_file: non_constant_identifier_names, unusedelement\n\n'
      '${loggingExtension.accept(emitter)}',
    ));

    return output.toString();
  }

  Method _makeLevelMethod(DartObject level) {
    final name = level.getField('name')!.toStringValue()!.toLowerCase();
    final methodName = level.getField('methodName')?.toStringValue() ?? name;
    final value = level.getField('value')!.toIntValue()!;
    return Method.returnsVoid(
      (m) => m
        ..name = methodName
        ..requiredParameters.add(
          Parameter(
            (p) => p
              ..named = false
              ..name = 'message'
              ..type = refer('Object?'),
          ),
        )
        ..docs.addAll([
          '/// Log message at level $name (value $value)',
          '/// Exceptions are upgraded to 1000 level',
          '/// Errors are upgraded to 1200 level',
        ])
        ..lambda = true
        ..body = Code("log(const Level('$name', $value), message)"),
    );
  }
}
