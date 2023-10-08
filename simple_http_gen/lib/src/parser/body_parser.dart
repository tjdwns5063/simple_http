import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:simple_http_gen/src/annotation.dart';
import 'package:simple_http_gen/src/parser/http_method_parser.dart';

final _bodyTypeChecker = const TypeChecker.fromRuntime(Body);

mixin BodyParser on MethodParser {
  String parseBody(Element method) {
    MethodElement element = method as MethodElement;

    List<ParameterElement> bodyParamList = element.parameters
        .where((parameter) => _bodyTypeChecker.hasAnnotationOfExact(parameter))
        .toList();

    if (bodyParamList.isEmpty) {
      return '\'{}\'';
    }

    if (bodyParamList.length > 1) {
      throw ArgumentError('body annotation is too many!');
    }

    return 'jsonEncode(${bodyParamList[0].name}.toJson())';
  }
}
