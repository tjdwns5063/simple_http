import 'dart:async';
import 'package:analyzer/dart/element/element.dart';
import 'package:simple_http_annotation/simple_http_annotation.dart';
import 'package:simple_http_gen/src/parser/delete_parser.dart';
import 'package:simple_http_gen/src/parser/http_method_parser.dart';
import 'package:simple_http_gen/src/parser/get_parser.dart';
import 'package:code_builder/code_builder.dart' as code_builder;
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:source_gen/src/output_helpers.dart';
import 'package:dart_style/dart_style.dart';
import 'package:simple_http_gen/src/parser/patch_parser.dart';
import 'package:simple_http_gen/src/parser/post_parser.dart';
import 'package:simple_http_gen/src/parser/put_parser.dart';

class SimpleHttpGenerator extends Generator {
  final _dartfmt = DartFormatter();

  TypeChecker typeChecker = TypeChecker.fromRuntime(Base);

  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) async {
    Set<code_builder.Directive> import = {
      code_builder.Directive.import('dart:convert'),
      code_builder.Directive.import('package:http/http.dart', as: 'http')
    };

    final values = <String>{};

    for (var annotatedElement in library.annotatedWith(typeChecker)) {
      import.add(code_builder.Directive.import(
          annotatedElement.element.source!.shortName));
      values.addAll(import
          .map((e) => e.accept(code_builder.DartEmitter.scoped()).toString()));
      final generatedValue = generateForAnnotatedElement(
        annotatedElement.element,
        annotatedElement.annotation,
        buildStep,
      );

      await for (var value in normalizeGeneratorOutput(generatedValue)) {
        assert(value.length == value.trim().length);
        values.add(value);
      }
    }

    return values.join('\n\n');
  }

  FutureOr<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    element as ClassElement;

    String baseUrl = annotation.peek('baseUrl')!.stringValue;

    HttpMethodParser methodParser = HttpMethodParser(
        GetParser(), DeleteParser(), PostParser(), PutParser(), PatchParser());

    code_builder.Class createdClass =
        methodParser.parse(element, baseUrl: baseUrl);

    return _dartfmt
        .format('${createdClass.accept(code_builder.DartEmitter())}');
  }
}

Builder httpBuilder(BuilderOptions options) => LibraryBuilder(
      SimpleHttpGenerator(),
    );
