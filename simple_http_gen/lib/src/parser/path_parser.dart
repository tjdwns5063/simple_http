import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:simple_http_gen/src/annotation.dart';
import 'package:simple_http_gen/src/parser/http_method_parser.dart';

final _pathTypeChecker = const TypeChecker.fromRuntime(Path);

mixin PathParser on MethodParser {
  String _parsePath(ParameterElement param, String endPoint) {
    String pathName = _pathTypeChecker
            .firstAnnotationOfExact(param)!
            .getField('name')!
            .toStringValue() ??
        param.name;

    return endPoint.replaceAll('{$pathName}', '\$${param.name}');
  }

  String parsePath(Element method, TypeChecker typeChecker) {
    MethodElement element = method as MethodElement;

    String endPoint = typeChecker
        .firstAnnotationOfExact(element)!
        .getField('endPoint')!
        .toStringValue()!;

    List<ParameterElement> pathParamList = element.parameters
        .where((parameter) => _pathTypeChecker.hasAnnotationOfExact(parameter))
        .toList();

    pathParamList.forEach((pathParam) {
      endPoint = _parsePath(pathParam, endPoint);
    });
    return endPoint;
  }
}
