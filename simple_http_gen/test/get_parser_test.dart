import 'package:source_gen/source_gen.dart';
import 'package:simple_http_gen/src/parser/get_parser.dart';
import 'package:simple_http_gen/src/parser/http_method_parser.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:test/test.dart';
import 'package:simple_http_annotation/simple_http_annotation.dart';

import 'util.dart';

class GetParserTest {
  MethodParser getParser;
  LibraryReader libraryReader;

  GetParserTest(this.getParser, this.libraryReader);

  void testParsingGetMethod() {
    ClassElement classElement = libraryReader.classes
        .firstWhere((element) => element.name == 'GETAnnotationTest');

    String baseUrl = TypeChecker.fromRuntime(Base)
        .annotationsOfExact(classElement)
        .first
        .getField('baseUrl')!
        .toStringValue()!;
    MethodElement method = classElement.methods[0];

    String result = getParser.parse(method, baseUrl);
    String expected = '''
    String endPoint = '/api/v1/users';
    Map<String, dynamic> queryParam = {'abc': abc};
    Map<String, String> headerParam = {'Authorization': token};
    Uri uri = Uri.https('example.org', endPoint, queryParam);
    http.Response response = await http.get(uri, headers: headerParam);
    
    if (response.statusCode < 200 || response.statusCode >= 300) {
      return Future.error('\${response.statusCode}: \${response.body}');
    }
    
    return response.body;
''';

    expect(result, expected);
  }
}

Future<void> main() async {
  LibraryReader libraryReader = await createLibrayReader();

  GetParserTest getParserTest = GetParserTest(GetParser(), libraryReader);

  test('get parse test', () => getParserTest.testParsingGetMethod());
}
