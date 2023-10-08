import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart' as code_builder;
import 'package:simple_http_gen/src/parser/parameter_parser.dart';

abstract class MethodParser {
  String parse(Element method, String baseUrl);
}

class HttpMethodParser with ParameterCreator {
  const HttpMethodParser(this.getParser, this.deleteParser, this.postParser,
      this.putParser, this.patchParser);

  final MethodParser getParser;
  final MethodParser deleteParser;
  final MethodParser postParser;
  final MethodParser putParser;
  final MethodParser patchParser;

  code_builder.Class parse(Element classElement, {String? baseUrl}) {
    ClassElement element = classElement as ClassElement;

    List<code_builder.Method> methods = element.methods.map((methodElement) {
      String annotation = methodElement.metadata.first.toString().split(' ')[0];
      MethodParser methodParser = switch (annotation) {
        '@GET' => getParser,
        '@POST' => postParser,
        '@PUT' => putParser,
        '@DELETE' => deleteParser,
        '@PATCH' => patchParser,
        _ => throw ArgumentError('invalid annotation!')
      };
      return code_builder.Method((code_builder.MethodBuilder builder) => builder
        ..name = methodElement.displayName
        ..returns = code_builder.Reference(methodElement.returnType.toString())
        ..annotations.add(code_builder.refer('override'))
        ..modifier = code_builder.MethodModifier.async
        ..requiredParameters.addAll(createRequiredParameter(methodElement))
        ..optionalParameters.addAll(createOptionalParameter(methodElement))
        ..body =
            code_builder.Code(methodParser.parse(methodElement, baseUrl!)));
    }).toList();

    return code_builder.Class((code_builder.ClassBuilder builder) => builder
      ..name = '${classElement.displayName}Impl'
      ..modifier = code_builder.ClassModifier.final$
      ..extend = code_builder.Reference(classElement.name)
      ..methods.addAll(methods));
  }
}
