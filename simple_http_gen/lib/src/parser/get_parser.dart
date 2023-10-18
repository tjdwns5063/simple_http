import 'package:simple_http_annotation/simple_http_annotation.dart';
import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:simple_http_gen/src/parser/http_method_parser.dart';
import 'package:simple_http_gen/src/parser/parameter_parser.dart';

import 'header_parser.dart';
import 'path_parser.dart';
import 'query_parser.dart';
import 'uri_parser.dart';

final getTypeChecker = const TypeChecker.fromRuntime(GET);

class GetParser extends MethodParser
    with PathParser, QueryParser, UriParser, HeaderParser, ParameterCreator {
  @override
  String parse(Element method, String baseUrl) {
    return _parseGet(baseUrl, method as MethodElement);
  }

  String _parseGet(String baseUrl, MethodElement element) {
    return '''
    String endPoint = '${parsePath(element, getTypeChecker)}';
    Map<String, dynamic> queryParam = ${parseQuery(element)};
    Map<String, String> headerParam = ${parseHeader(element)};
    Uri uri = ${parseUri(baseUrl)};
    http.Response response = await http.get(uri, headers: headerParam);
    
    if (response.statusCode < 200 || response.statusCode >= 300) {
      return Future.error('\${response.statusCode}: \${response.body}');
    }
    
    return response.body;
''';
  }
}
