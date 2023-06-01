import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart' show BuildStep;
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:logging_utils/logging_utils.dart';
import 'package:source_gen/source_gen.dart';

class LoggingConfigGenerator extends GeneratorForAnnotation<AutoLogConfig> {
  // Cache for use in other generators
  late List<Level> levels;

  final tKDebugMode = refer('kDebugMode', 'package:flutter/foundation.dart');
  final tLevel = refer('Level', 'package:logging/logging.dart');

  @override
  generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    print('LOGGING CONFIG');
    levels = _mapLevels(annotation.read('levels').listValue);
    final allocator = Allocator();

    final loggingConfigClass = Class(
      (c) => c
        ..name = annotation.read('configClassName').stringValue
        ..extend = refer(
          'LoggingConfigBasic',
          'package:logging_utils/logging_utils.dart',
        )
        ..constructors.add(Constructor(
          (ctor) => ctor
            ..optionalParameters.addAll([
              Parameter((p) => p
                ..name = 'isDebugLogging'
                ..required = false
                ..named = true
                ..toSuper = true
                ..defaultTo = annotation.read('debugLevelCallback').isNull
                    ? refer(allocator.allocate(tKDebugMode)).code
                    : refer(
                        'defaultLogFormatter',
                        'package:logging_utils/logging_utils.dart',
                      ).code),
              Parameter((p) => p
                ..name = 'debugLevel'
                ..required = false
                ..named = true
                ..toSuper = true
                ..defaultTo = Code('Level.INFO')),
              Parameter((p) => p
                ..name = 'releaseLevel'
                ..required = false
                ..named = true
                ..toSuper = true
                ..defaultTo = Code('Level.INFO')),
              // Parameter((p) => p
              //   ..name = 'levelOverrides'
              //   ..type = refer('Map<String,int>')
              //   ..required = false
              //   ..named = true
              //   ..defaultTo = Code('const {}')),
            ])
            ..initializers.add(Code(
              'super(levelOverrides: const {})',
            )),
        ))
        ..methods.addAll([
          Method(
            (m) => m
              ..name = 'formatLogRecord'
              ..annotations.add(CodeExpression(Code('override')))
              ..returns = refer('String')
              ..requiredParameters.add(Parameter(
                (p) => p
                  ..name = 'record'
                  ..type = refer('LogRecord', 'package:logging/logging.dart'),
              ))
              ..body = Code('return record.toString();'),
          ),
          Method.returnsVoid(
            (m) => m
              ..name = 'outputLogLine'
              ..annotations.add(CodeExpression(Code('override')))
              ..requiredParameters.add(Parameter(
                (p) => p
                  ..name = 'formattedLogLine'
                  ..type = refer('String'),
              ))
              ..lambda = true
              ..body = Code('print(formattedLogLine)'),
          )
        ]),
    );

    final emitter =
        DartEmitter(allocator: allocator, useNullSafetySyntax: true);
    final out = DartFormatter().format(
      '//${allocator.imports.toString().replaceAll('\n', '\n//')}'
      '// ignore_for_file: non_constant_identifier_names, unused_element\n\n'
      '${loggingConfigClass.accept(emitter)}',
    );
    print(out);
    return out;
  }

  List<Level> _mapLevels(List<DartObject> levels) => levels
      .map((e) => Level(
            e.getField('name')!.toStringValue()!,
            e.getField('value')!.toIntValue()!,
          ))
      .toList();
}
