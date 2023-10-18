import 'package:simple_http_annotation/simple_http_annotation.dart';
import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:simple_http_gen/src/parser/http_method_parser.dart';

import 'body_parser.dart';
import 'header_parser.dart';
import 'path_parser.dart';
import 'query_parser.dart';
import 'uri_parser.dart';

final postTypeChecker = const TypeChecker.fromRuntime(POST);

class PostParser extends MethodParser
    with PathParser, QueryParser, UriParser, HeaderParser, BodyParser {
  @override
  String parse(Element method, String baseUrl) {
    return _parsePost(baseUrl, method as MethodElement);
  }

  String _parsePost(String baseUrl, MethodElement element) {
    return '''
    String endPoint = '${parsePath(element, postTypeChecker)}';
    Map<String, dynamic> queryParam = ${parseQuery(element)};
    String body = ${parseBody(element)};
    Map<String, String> headerParam = ${parseHeader(element)};
    Uri uri = ${parseUri(baseUrl)};
    http.Response response = await http.post(uri, headers: headerParam, body: body);
    
    if (response.statusCode < 200 || response.statusCode >= 300) {
      return Future.error('\${response.statusCode}: \${response.body}');
    }
    
    return response.body;
''';
  }
}
