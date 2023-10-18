import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:simple_http_annotation/simple_http_annotation.dart';
import 'package:simple_http_gen/src/parser/http_method_parser.dart';

final _headerTypeChecher = const TypeChecker.fromRuntime(Header);

mixin HeaderParser on MethodParser {
  Map<String, dynamic> _parseHeader(List<ParameterElement> param) {
    Map<String, dynamic> header = {};

    Iterable<MapEntry<String, dynamic>> entries = param.map((parameter) {
      String queryKey = _headerTypeChecher
          .firstAnnotationOfExact(parameter)!
          .getField('name')!
          .toStringValue()!;

      return MapEntry('\'${queryKey}\'', '${parameter.name}');
    });

    header.addEntries(entries);

    return header;
  }

  Map<String, dynamic> parseHeader(Element method) {
    MethodElement element = method as MethodElement;

    List<ParameterElement> headerParamList = element.parameters
        .where(
            (parameter) => _headerTypeChecher.hasAnnotationOfExact(parameter))
        .toList();

    return _parseHeader(headerParamList);
  }
}
