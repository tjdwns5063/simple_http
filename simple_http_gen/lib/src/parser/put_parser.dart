import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:simple_http_gen/src/annotation.dart';
import 'package:simple_http_gen/src/parser/http_method_parser.dart';

import 'body_parser.dart';
import 'header_parser.dart';
import 'path_parser.dart';
import 'query_parser.dart';
import 'uri_parser.dart';

final putTypeChecker = const TypeChecker.fromRuntime(PUT);

class PutParser extends MethodParser
    with PathParser, QueryParser, UriParser, HeaderParser, BodyParser {
  @override
  String parse(Element method, String baseUrl) {
    return _parsePut(baseUrl, method as MethodElement);
  }

  String _parsePut(String baseUrl, MethodElement element) {
    return '''
    String endPoint = '${parsePath(element, putTypeChecker)}';
    Map<String, dynamic> queryParam = ${parseQuery(element)};
    String body = ${parseBody(element)};
    Map<String, String> headerParam = ${parseHeader(element)};
    Uri uri = ${parseUri(baseUrl)};
    http.Response response = await http.put(uri, headers: headerParam, body: body);
    
    if (response.statusCode < 200 || response.statusCode >= 300) {
      return Future.error('\${response.statusCode}: \${response.body}');
    }
    
    return response.body;
''';
  }
}
