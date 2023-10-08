import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:simple_http_gen/src/annotation.dart';
import 'package:simple_http_gen/src/parser/http_method_parser.dart';

final _queryTypeChecker = const TypeChecker.fromRuntime(Query);

mixin QueryParser on MethodParser {
  Map<String, dynamic> _parseQuery(List<ParameterElement> param) {
    Map<String, dynamic> query = {};

    Iterable<MapEntry<String, dynamic>> entries = param.map((parameter) {
      String queryKey = _queryTypeChecker
              .firstAnnotationOfExact(parameter)!
              .getField('name')!
              .toStringValue() ??
          '${parameter.name}';

      return MapEntry('\'$queryKey\'', '${parameter.name}');
    });

    query.addEntries(entries);

    return query;
  }

  Map<String, dynamic> parseQuery(Element method) {
    MethodElement element = method as MethodElement;

    List<ParameterElement> queryParamList = element.parameters
        .where((parameter) => _queryTypeChecker.hasAnnotationOfExact(parameter))
        .toList();

    return _parseQuery(queryParamList);
  }
}
